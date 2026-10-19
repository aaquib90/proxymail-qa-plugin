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

# No placeholders (Qoder refuses TODO and <your-token>, 17 Oct 2026).
grep -rnE '<[A-Za-z][A-Za-z0-9_ -]*>|\bTODO\b|\bTBD\b|FIXME' skills README.md README.qoder.md && problem "placeholder text above"

# Each skill says how to check it worked (Qoder wants steps, precautions and a check).
for f in skills/*/SKILL.md; do
  grep -q '^## Check it' "$f" || problem "$f has no 'Check it worked' section"
done

[ "$fail" = 0 ] && echo "check-submission: ok ($versions)"
exit "$fail"
