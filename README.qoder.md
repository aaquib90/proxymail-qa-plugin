# Proxy Mail QA plugin for Qoder

[Proxy Mail QA](https://proxymail.qa) gives Qoder disposable email inboxes for
testing sign-up, login-code, magic-link and password-reset emails. The agent
creates an address, signs up with it in the app you're building, and gets the
verification code or link back, without the rest of the email.

The plugin adds:

- **The Proxy Mail QA MCP server** at `https://api.proxymail.qa/mcp`. It signs
  in through your browser: you choose one project and allow it, with no API key
  to copy. No account yet? Create a free one on that same page; it makes your
  first project and brings you straight back.
- **Eight skills**, which the agent picks up when a task needs one:
  - `proxymail-qa`: test a sign-up end to end.
  - `auth-regression-pack`: check sign-up, password reset and invitations the
    same way every time, including reused and replaced links.
  - `account-email-audit`: trigger every account email the app sends and list
    what to fix.
  - `signup-form-email-validation`: check the sign-up form accepts valid but
    unusual addresses and turns away invalid ones.
  - `age-and-region-testing`: test age gates, parental consent and country
    rules with accounts of an exact age or country.
  - `email-delivery-troubleshooting`: find out why a sign-up or reset email
    isn't arriving, and fix the cause.
  - `mobile-sign-up-testing`: sign-up, codes and links in iOS and Android
    apps, in a simulator or emulator.
  - `marketing-email-testing`: welcome coupons and checkout, one offer per
    person, unsubscribing, consent rules by country and spam risk.

It works on the Free plan.

## Install

In Qoder, open **Extensions → Plugins**, search for **Proxy Mail QA** and
choose **Install**.

The first time the agent uses a tool, Qoder opens your browser to sign in to
Proxy Mail QA and choose a project. If the agent can't see Proxy Mail QA's
tools, sign in to the plugin's server from Qoder's MCP settings.

If you added the Proxy Mail QA server to Qoder by hand before installing the
plugin, remove that entry: otherwise Qoder lists two servers at the same
address, and the plugin's stays signed out.

## What the agent can do

| Tool | What it does |
| --- | --- |
| `get_project` | The project it works in: default mail domain and the others, email prefix, limits |
| `create_address` | A new test address, with a fictional name and username, a date of birth for an `age` (such as `under13`), a `country` (such as `GB`), and a password if asked; `site` and `environment` record where it's used |
| `form_values` | For a form with more than an email field: what to type or pick in each field, from a new address made for it (a username and password that fit the rules, the date of birth in the field's format, a country the drop-down offers). The agent fills in the form |
| `wait_for_code` | Waits up to 30 seconds for a verification or login code, or with `kind: coupon` an offer's coupon with its discount and valid-until date |
| `wait_for_link` | The same for a verify, magic sign-in, invite or password-reset link, or with `kind: unsubscribe` (or `list_unsubscribe`) the email's unsubscribe link. `app: true` asks for the link that opens a mobile app (`myapp://…`) |
| `get_address_variants` | Unusual versions of an address for testing sign-up forms: ones whose mail still arrives (capitals, plus tags with special characters), valid ones mail servers refuse, and invalid ones |
| `check_delivery` | Explains an address's mail without waiting: what reached it, anything refused, and the likely cause when nothing did |
| `list_addresses` | The project's addresses, each with its newest code or link. Filters find a test account made earlier: tags, country, age, saved password, text, site or environment |
| `update_address` | Its first name, last name, username, date of birth or country if the app changed them, and notes, tags or a label |
| `set_password` | Saves the password the test account uses now, after the app changed or reset it |
| `delete_address` | Deletes an address and its mail |
| `mark_dev_host` | Marks a host such as `localhost:3000` as a dev environment, so `check_email` passes links to it |
| `update_project` | Changes the project's name, website, environments, email prefix or default mail domain, for its lead or an organisation owner or admin; logged in the project's activity |
| `check_email` | Checks an email that arrived: SPF, DKIM and DMARC, links to localhost or plain http, where its link goes, a stated expiry or coupon end date, its size, whether it fits a phone, and the text, language and attachments you expect; attachments inboxes block (`harmful_attachment`) and an estimate of whether it lands in spam (`spam_risk`). Verdicts only, never the email |
| `count_emails`, `expect_no_email` | How many emails arrived (to catch duplicates), and a check that nothing arrives (`until` for up to an hour); `category: marketing` looks at marketing email only |
| `check_sequence` | Whether a welcome series or drip campaign came in order and on time after sign-up: pass, early, late, missing or waiting for each email |
| `record_consent` | What an account agreed to at sign-up, so `check_email` judges its marketing by the rules where the persona lives (EU, UK, US, Canada, Australia) |
| `record_coupon_result` | What checkout did with a coupon the agent applied on staging: accepted, rejected or an error, with the app's message and a verdict |
| `check_offers` | Each sender's coupons and which version of the address (plain, capitals, `+tag`) each went to: whether one person got an offer twice |
| `mark_unsubscribed`, `mark_resubscribed`, `check_unsubscribe` | Record that the address unsubscribed from a sender (after the agent did it in its browser), and list any marketing email that came after |
| `check_out_account`, `extend_checkout`, `return_account` | Borrow a test account in a known state that no other test has, hold it longer if needed, and give it back |
| `start_run`, `add_run_note`, `finish_run` | Record a session as a run, each call naming its step (`test`); `finish_run` returns the report in Markdown for a pull request, compared with the last runs of the same name |

The skills above are the ready-made checklists: `proxymail-qa` covers sign-up,
codes and links, password resets and a borrowed account;
`auth-regression-pack` the same checks every time, compared with the last runs;
`account-email-audit` each account email the app sends; and
`marketing-email-testing` offers, unsubscribing and consent rules. (The server
also offers them as MCP prompts, for clients that show prompts.)

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

MIT.
