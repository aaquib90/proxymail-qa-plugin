# Installing Proxy Mail QA for an AI coding agent

Proxy Mail QA is a hosted MCP server: there is nothing to download, build or run.

1. Add a remote MCP server named `proxymail-qa` with the address `https://api.proxymail.qa/mcp`. It uses the Streamable HTTP transport.
2. Connect it. The server signs people in by browser (OAuth with dynamic client registration): a Proxy Mail QA page opens, where the person signs in or creates a free account, chooses the project the agent may use, and allows it.
3. If the agent can't sign in by browser, stop and point the person to https://proxymail.qa/docs/mcp, which shows how to connect Proxy Mail QA to each tool.
4. Check it worked: call `get_project`. It returns the project's name and the mail domains new test addresses use.

Then follow the server's instructions: `create_address` for a new test inbox, sign up in the app under test with it, and `wait_for_code` or `wait_for_link` for the email's code or link.
