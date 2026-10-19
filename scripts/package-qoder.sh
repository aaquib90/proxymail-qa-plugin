#!/bin/sh
# Builds the ZIP to upload at qoder.com → My Publications → Publish → Plugin:
# the Qoder manifest at the ZIP's root, the MCP server, the skills, the README,
# the licence and the icon. Bump the version in .qoder-plugin/ first.
#
# Qoder's review refuses a package that tells people how to install on other
# platforms (19 Oct 2026), so the ZIP carries README.qoder.md as its README,
# and the skill's setup names Qoder alone. The build stops if anything in it
# still names another platform.
set -eu
cd "$(dirname "$0")/.."
version=$(sed -n 's/^  "version": "\(.*\)",$/\1/p' .qoder-plugin/plugin.json)
out="$PWD/dist/proxymail-qa-qoder-$version.zip"
stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT

mkdir -p "$stage/.qoder-plugin" "$stage/assets"
cp .qoder-plugin/plugin.json "$stage/.qoder-plugin/"
cp .mcp.json LICENSE "$stage/"
cp assets/logo.png "$stage/assets/"
cp -R skills "$stage/skills"
cp README.qoder.md "$stage/README.md"

# The skill's setup: the two lines for other tools become one for Qoder.
skill="$stage/skills/proxymail-qa/SKILL.md"
grep -q '^- Claude Code: run `/mcp`' "$skill" && grep -q '^- Qoder, Cursor and other tools:' "$skill" || {
  echo "package-qoder: the setup lines in skills/proxymail-qa/SKILL.md changed; update this script" >&2
  exit 1
}
sed -i '' \
  -e '/^- Claude Code: run `\/mcp`/d' \
  -e 's|^- Qoder, Cursor and other tools:.*|- In Qoder, install the Proxy Mail QA plugin from Extensions → Plugins. The first time a tool runs, Qoder opens the browser to sign in to Proxy Mail QA and choose a project.|' \
  "$skill"

if grep -rniE 'cursor|claude|codex|copilot|antigravity|opencode|windsurf|skills\.sh|npx skills|cursor\.directory' "$stage" --include='*.md' --include='*.json'; then
  echo "package-qoder: the lines above name another platform; Qoder's review refuses them" >&2
  exit 1
fi

mkdir -p dist
rm -f "$out"
(cd "$stage" && zip -q -r -X "$out" .qoder-plugin/plugin.json .mcp.json skills README.md LICENSE assets/logo.png -x '*.DS_Store')
echo "dist/proxymail-qa-qoder-$version.zip"
