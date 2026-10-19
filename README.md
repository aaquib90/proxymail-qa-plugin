# Proxy Mail QA plugin

[Proxy Mail QA](https://proxymail.qa) gives coding agents disposable email
inboxes for testing sign-up, login-code, magic-link and password-reset emails.
Your agent creates an address, signs up with it in the app you're building, and
gets the verification code or link back, without the rest of the email.

This plugin adds, for Claude Code, Cursor and Qoder:

- **The Proxy Mail QA MCP server** at `https://api.proxymail.qa/mcp`. It signs
  in through your browser: you choose one project and allow it, with no API key
  to copy.
- **Two skills**: `proxymail-qa` walks the agent through testing a sign-up end
  to end, and `auth-regression-pack` checks sign-up, password reset and
  invitations the same way every time, including reused and replaced links.

It works on the Free plan.

## Install

### Claude Code

```
/plugin marketplace add aaquib90/proxymail-qa-plugin
/plugin install proxymail-qa@proxymail-qa
```

Then type `/mcp`, choose **proxymail-qa** and **Authenticate**. Your browser
opens to sign in to Proxy Mail QA and choose a project.

### Cursor

Click **Add to Cursor** on [Proxy Mail QA's Cursor Directory
page](https://cursor.directory/plugins/proxymail-qa), then log in to it from
the MCP section of Cursor Settings.

### Qoder

In Qoder, open **Extensions → Plugins**, search for **Proxy Mail QA** and
choose **Install**. With the Qoder CLI:

```
qoder plugins marketplace add aaquib90/proxymail-qa-plugin
qoder plugins install proxymail-qa@proxymail-qa
```

The first time the agent uses a tool, Qoder opens your browser to sign in to
Proxy Mail QA and choose a project.

### The skill on its own

To add just the skill to Claude Code, Codex, Cursor, OpenCode and other agents
that read skills ([skills.sh](https://skills.sh/aaquib90/proxymail-qa-plugin/proxymail-qa)):

```
npx skills add aaquib90/proxymail-qa-plugin
```

The skill uses the MCP server, so connect it too: see the [setup
guide](https://proxymail.qa/docs/api#agent-setup).

### Other agents

GitHub Copilot, Antigravity, Codex and other tools that support remote MCP
servers: see the [setup guide](https://proxymail.qa/docs/api#agent-setup), or
paste its setup block into your agent.

## What the agent can do

| Tool | What it does |
| --- | --- |
| `get_project` | The project it works in: default mail domain and the others, email prefix, limits |
| `create_address` | A new test address, with a fictional name and username, a date of birth for an `age` (such as `under13`), a `country` (such as `GB`), and a password if asked; `site` and `environment` record where it's used |
| `form_values` | For a form with more than an email field: what to type or pick in each field, from a new address made for it (a username and password that fit the rules, the date of birth in the field's format, a country the drop-down offers). The agent fills in the form |
| `wait_for_code` | Waits up to 30 seconds for a verification or login code, or with `kind: coupon` an offer's coupon with its discount and valid-until date |
| `wait_for_link` | The same for a verify, magic sign-in, invite or password-reset link, or with `kind: unsubscribe` (or `list_unsubscribe`) the email's unsubscribe link. `app: true` asks for the link that opens a mobile app (`myapp://…`) |
| `get_address_variants` | Unusual versions of an address for testing sign-up forms: ones whose mail still arrives (capitals, plus tags with special characters), and invalid ones |
| `check_delivery` | Explains an address's mail without waiting: what reached it, anything refused, and the likely cause when nothing did |
| `list_addresses` | The project's addresses, each with its newest code or link. Filters find a test account made earlier: tags, country, age, saved password, text, site or environment |
| `update_address` | Its first name, last name, username, date of birth or country if the app changed them, and notes, tags or a label |
| `set_password` | Saves the password the test account uses now, after the app changed or reset it |
| `delete_address` | Deletes an address and its mail |
| `mark_dev_host` | Marks a host such as `localhost:3000` as a dev environment, so `check_email` passes links to it |
| `check_email` | Checks an email that arrived: SPF, DKIM and DMARC, links to localhost or plain http, where its link goes, a stated expiry or coupon end date, its size, whether it fits a phone, and the text, language and attachments you expect. Verdicts only, never the email |
| `count_emails`, `expect_no_email` | How many emails arrived (to catch duplicates), and a check that nothing arrives (`until` for up to an hour); `category: marketing` looks at marketing email only |
| `mark_unsubscribed`, `mark_resubscribed`, `check_unsubscribe` | Record that the address unsubscribed from a sender (after the agent did it in its browser), and list any marketing email that came after |
| `check_out_account`, `extend_checkout`, `return_account` | Borrow a test account in a known state that no other test has, hold it longer if needed, and give it back |
| `start_run`, `add_run_note`, `finish_run` | Record a session as a run, each call naming its step (`test`); `finish_run` returns the report in Markdown for a pull request, compared with the last runs of the same name |

Prompts, ready-made checklists: `test_signup_flow`, `test_password_reset`,
`test_sign_in_code`, `prepare_account` (an account confirmed to be in the state
a test needs), `auth_regression_pack` (the same checks every time, compared
with the last runs), `audit_auth_emails`, `audit_marketing_emails` and `test_unsubscribe`.

Then ask in plain words: "Sign up on localhost:3000 with a new Proxy Mail QA
address and confirm the email."

## Safety

- Results contain only the code or link, the service that sent it and when it
  expires, never the email's text, so an email can't pass instructions to the
  agent.
- Proxy Mail QA never opens links, so single-use links still work.
- A connected agent works in one project and can't read passwords saved
  earlier. Disconnect it any time in **Project settings → API keys** at
  [app.proxymail.qa](https://app.proxymail.qa).

[Privacy policy](https://proxymail.qa/privacy) ·
[Terms](https://proxymail.qa/terms) · [Full guide](https://proxymail.qa/docs/api) ·
hello@proxymail.qa

## Licence

MIT. The skills in `skills/` are the MCP-only versions of the ones published
at `https://proxymail.qa/.well-known/agent-skills/`, which also cover the REST
API with a key: the plugin signs in through the browser and never reads a key
from the machine.
