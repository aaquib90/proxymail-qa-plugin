#!/bin/sh
# Builds the ZIP to upload at qoder.com → My Publications → Publish → Plugin:
# the Qoder manifest at the ZIP's root, the MCP server, the skill, the README,
# the licence and the icon. Bump the version in .qoder-plugin/ first.
set -eu
cd "$(dirname "$0")/.."
version=$(sed -n 's/^  "version": "\(.*\)",$/\1/p' .qoder-plugin/plugin.json)
out="dist/proxymail-qa-qoder-$version.zip"
mkdir -p dist
rm -f "$out"
zip -q -r -X "$out" .qoder-plugin/plugin.json .mcp.json skills README.md LICENSE assets/logo.png -x '*.DS_Store'
echo "$out"
