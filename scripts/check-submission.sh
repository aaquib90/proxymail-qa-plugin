#!/bin/sh
# Checks the plugin against what directory reviews have refused before
# (Proxy Mail QA's mcp/submission-rules.md has the full matrix). Run it before
# any submission; package-qoder.sh runs it first.
set -eu
cd "$(dirname "$0")/.."
fail=0
problem() { echo "check-submission: $*" >&2; fail=1; }

# Every manifest carries the same version (Claude, Cursor, Qoder).
versions=$(grep -ho '"version": *"[^"]*"' .claude-plugin/*.json .cursor-plugin/*.json .qoder-plugin/*.json | sed 's/.*"\([^"]*\)"$/\1/' | sort -u)
[ "$(echo "$versions" | wc -l | tr -d ' ')" = 1 ] || problem "manifest versions differ: $(echo $versions)"

# The MCP configs name the server only: an auth block or a key beside the URL
# made OpenAI drop the server, and Claude's directory hold the plugin.
for f in .mcp.json mcp.json; do
  grep -qiE '"(headers|env|auth|authorization|oauth)"|bearer|api[_-]?key' "$f" && problem "$f has more than the server's type and URL"
done

# The skills use the MCP server only: no REST API, no API key (Claude's plugin
# directory put a credential-policy hold on an env-var key, 13 Oct 2026).
grep -rniE 'PROXYMAIL_QA_API_KEY|api key|/v1/|rest api' skills && problem "a skill mentions the REST API or an API key"

# Nor do they read anyone's secrets: no secret's variable name, and no
# "read it from the environment". Claude's plugin directory flagged 1.8.0 as
# reading a credential from the user's machine beside an MCP server
# (MCP_FORWARDS_CREDENTIAL_ENV, 5 Nov 2026).
grep -rnE '[A-Z0-9]+_(API_KEY|TOKEN|SECRET|PASSWORD)\b|[Rr]ead (them|it) from the environment|code and environment' skills && problem "a skill names a secret's variable or reads the environment"

# Nor do the install guide and the READMEs, which agents and reviewers read
# beside the plugin: no key, no Authorization header and no asking the person
# for a key (llms-install.md asked for one until 6 Nov 2026). The READMEs may
# still say there's no key to copy, and where connections are listed.
grep -niE 'PROXYMAIL_QA_API_KEY|authorization|bearer|qa_[A-Za-z0-9_-]{43}' llms-install.md README.md README.qoder.md && problem "the install guide or a README has a key, or tells an agent to send one"
grep -niE 'api key|/v1/|rest api' llms-install.md && problem "llms-install.md mentions an API key or the REST API"

# No placeholders (Qoder refuses TODO and <your-token>, 17 Oct 2026).
grep -rnE '<[A-Za-z][A-Za-z0-9_ -]*>|\bTODO\b|\bTBD\b|FIXME' skills README.md README.qoder.md && problem "placeholder text above"

# Each skill says how to check it worked (Qoder wants steps, precautions and a check).
for f in skills/*/SKILL.md; do
  grep -q '^## Check it' "$f" || problem "$f has no 'Check it worked' section"
done

[ "$fail" = 0 ] && echo "check-submission: ok ($versions)"
exit "$fail"
