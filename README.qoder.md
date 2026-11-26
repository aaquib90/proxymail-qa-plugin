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
- **Nine skills**, which the agent picks up when a task needs one:
  - **Email flow testing** (`proxymail-qa`): test a sign-up end to end.
  - **Auth regression pack** (`auth-regression-pack`): check sign-up, password reset and invitations the
    same way every time, including reused and replaced links.
  - **Account email audit** (`account-email-audit`): trigger every account email the app sends and list
    what to fix.
  - **Sign-up form email validation** (`signup-form-email-validation`): check the sign-up form accepts valid but
    unusual addresses, names and passwords, turns away invalid ones, and stores HTML or SQL in a name as text.
  - **Sign-up form setup** (`sign-up-form-setup`): go through each screen of the sign-up form, list the fields that
    would be guessed or left empty, such as company size, and save the custom fields you agree to.
  - **Age and region testing** (`age-and-region-testing`): test age gates, parental consent and country
    rules with accounts of an exact age or country.
  - **Email delivery troubleshooting** (`email-delivery-troubleshooting`): find out why a sign-up or reset email
    isn't arriving, and fix the cause.
  - **Mobile app sign-up testing** (`mobile-sign-up-testing`): sign-up, codes and links in iOS and Android
    apps, in a simulator or emulator.
  - **Marketing and offer email testing** (`marketing-email-testing`): welcome coupons and checkout, one offer per
    person, unsubscribing, consent rules by country and spam risk.

It works on the Free plan.

## What to ask

- "Sign up on localhost:3000 with a new test account and confirm the email."
- "Why isn't my app's verification email arriving?"
- "Check the password-reset email my app sent to my test address."
- "Give me a test email for my staging sign-up and tell me the code when it arrives." (When the agent can't open the app, it gives you the address to sign up with and tells you the code.)

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
| `get_project` | The project it works in: default mail domain and the others, email prefix, limits, its guesses setting, how many custom fields it has, and its sites with their sign-up screens |
| `create_address` | A new test address, with a fictional name and username, a date of birth for an `age` (such as `under13`), a `country` (such as `GB`), and a password if asked; `site` and `environment` record where it's used |
| `form_values` | For a form with more than an email field: what to type or pick in each field, from a new address made for it (a username and password that fit the rules, the date of birth in the field's format, a country the drop-down offers). The form's own fields, such as company size, come from the project's custom fields, and fields nobody taught get a guess marked as one. Phone, ID and tax number fields are never guessed: the project's ready-made custom fields fill them, or they're left empty with a note. Once per screen for a sign-up over several. The agent fills in the form |
| `mark_submitted` | Records the moment the agent sends a sign-up, sign-in, password reset or magic link form with a test address, by Proxy Mail QA's own clock. The wait that finds the code or link then says how long the email took (`time_to_email`): the part taken by the app and its email provider, the part taken by Proxy Mail QA, and whether it's much slower than the site's usual. Of the page, only its host and path are kept, with any part that holds an email address, an ID, a long number or a token hidden; never the form's contents |
| `wait_for_code` | Waits up to 30 seconds for a verification or login code, or with `kind: coupon` an offer's coupon with its discount and valid-until date |
| `wait_for_link` | The same for a verify, magic sign-in, invite or password-reset link, or with `kind: unsubscribe` (or `list_unsubscribe`) the email's unsubscribe link. `app: true` asks for the link that opens a mobile app (`myapp://…`) |
| `get_address_variants` | Unusual versions of an address for testing sign-up forms: ones whose mail still arrives (capitals, plus tags with special characters), valid ones mail servers refuse, and invalid ones |
| `get_name_variants` | Awkward names for a form's name field (`field`, `max_length`): ones to accept (apostrophes, accents, other scripts, one letter, exactly the maximum), ones to reject, HTML or SQL to store as text, and ones apps differ on |
| `get_password_variants` | Awkward passwords within the field's rules (`min_length`, `max_length`, `symbols`): the minimum and maximum, each symbol class, spaces, non-ASCII, and ones apps differ on; fresh each call |
| `check_delivery` | Explains an address's mail without waiting: what reached it, anything refused, and the likely cause when nothing did |
| `search_docs` | Searches Proxy Mail QA's docs and guides for how to do something (`query`): setting up a test framework, CI or a mobile app, why an email didn't arrive, plans and limits. Returns passages with their page addresses |
| `list_addresses` | The project's addresses, each with its newest code or link. Filters find a test account made earlier: tags, country, age, saved password, text, site or environment |
| `update_address` | Its first name, last name, username, date of birth or country if the app changed them, and notes, tags or a label |
| `set_password` | Saves the password the test account uses now, after the app changed or reset it |
| `delete_address` | Deletes an address and its mail |
| `get_cleanup_list` | Every test address the project used in a time range (the last 30 days unless you say, up to 90 days back), live, expired or deleted, with the site it was used on and whether email reached it, and the mail domains they end in, so the agent can delete those test users through your app's own admin or user list afterwards. Proxy Mail QA never touches your app |
| `mark_dev_host` | Marks a host such as `localhost:3000` as a dev environment, so `check_email` passes links to it |
| `update_project` | Changes the project's name, website, environments, email prefix, default mail domain, what it tests (`areas`) or its spam checks (`spam_checks`), for its lead or an organisation owner or admin, and which fields get a guess (`fill_unknown_fields`); logged in the project's activity |
| `list_custom_fields`, `save_custom_field`, `delete_custom_field`, `set_custom_field_enabled`, `set_standard_field` | The project's custom fields: what goes in a sign-up form's own fields, for everyone on the project. A custom field, or the standard Company, First name, Last name or Full name field, can be turned off, and a box whose field is off stays empty. The agent saves, removes or switches one only when you ask or agree; where only the project's leads change them, it asks a lead instead |
| `add_site`, `save_signup_screen`, `remove_signup_screen`, `set_multi_step` | Adds a staging, dev or local site to the project (never one that looks live, which you add in the app), a site's list of sign-up screens (pages, or a native app's screens), and whether Proxy Mail QA for Chrome 0.9.0 and later fills each new screen of a sign-up there by itself. Adding a site never gives Chrome access: you allow that once, from Proxy Mail QA for Chrome on the site. The agent changes them only when you ask or agree; where only the project's leads change sites, it asks a lead instead |
| `list_form_sections`, `get_form_section` | The field sections a sign-up form may ask for (person, account, business and documents), with labels in nine languages and where each value comes from. For an ID or tax number in a given country: its format and, where it's safe, a made-up value that follows it and never matches a real person, with values the form should accept or refuse. A passport defaults to Utopia, ICAO's fictional state, with its machine-readable lines. `kyc_sandbox` adds a KYC vendor's own published sandbox values, for that vendor's test mode |
| `list_signup_starters`, `list_signup_forms`, `get_signup_form`, `save_signup_form`, `delete_signup_form` | The project's sign-up forms (up to 20): each screen's fields with their labels and test ids, built with you from what you describe, from a starter (a consumer app, B2B SaaS, education, a marketplace, travel, fintech, Japan or China) or from a screenshot of your own form. Saving one makes the ready-made custom fields it needs where nothing fills the field yet (for a phone, a choice or the terms box, and on a lead's save an ID or tax number), and never overwrites one of yours: where one of yours also fills a field, the agent asks you which should, and it asks before tidying away custom fields the form no longer uses. It saves or removes a form only when you ask or agree; where only the project's leads change custom fields, a member's form goes to the leads as one request |
| `get_signup_form_code`, `get_signup_form_test` | A saved form as code for your app (React with react-hook-form and zod, plain React, or one HTML page), each field checking what the form asks for and carrying the `data-testid` its custom fields find it by; and Playwright or Cypress tests that try, one field at a time, values the form should take and values it should refuse, with every other field filled in from a new test address |
| `get_flow_checks` | The checks to run on a sign-up, password reset or magic-link flow beyond the email arriving: a wrong code refused, a code or link working only once, only the newest one working, an expired one refused, the link in another browser, surviving a mail scanner, no second account for the same address, and a second person unable to see the first one's data. Each has steps and what to expect; the agent runs them through your app as a person would, never its database |
| `get_journey` | A site's journey, as the Journeys page draws it: the emails the project's test accounts got from it, in order, with how many got each one, the wait before it, who is still due it and who didn't get it, its warnings, and where accounts took different paths, each with the `filter` that shows it alone, to pass back as it is. Filters by `country`, `age`, `any_tags`, one `address`, and the steps an account got or didn't (`got_step`, `not_got_step`); `phase` keeps one phase's steps. Steps are named by kind, sender and key, never by subject, and the answer links to the page on the same view |
| `check_email` | Checks an email that arrived: SPF, DKIM and DMARC, links to localhost or plain http, where its link goes, a stated expiry or coupon end date, its size, whether it fits a phone, and the text, language and attachments you expect; attachments inboxes block (`harmful_attachment`) and an estimate of whether it lands in spam (`spam_risk`, with an inbox score out of 10, where 10 is good). Verdicts only, never the email |
| `count_emails`, `expect_no_email` | How many emails arrived (to catch duplicates), and a check that nothing arrives (`until` for up to an hour); `category: marketing` looks at marketing email only |
| `find_emails` | Finds the emails that reached any of the project's addresses, newest first, for "did any marketing email arrive in the last 10 minutes?" or "which addresses got the welcome email?": `within` (such as `10m`) or `since` and `until`, `category`, `service`, `type`, `subtype` and `subject`, a phrase the subject contains. Proxy Mail QA matches the subject itself and never returns it: each email comes with its address, when it arrived, its sender, its category and the kind of its code or link, and `count` says how many match. With no `since` or `within` it looks at the last 30 days, and `before` (the last email's `email_id`) gives the next page. It doesn't wait |
| `check_sequence` | Whether a welcome series or drip campaign came in order and on time after sign-up: pass, early, late, missing or waiting for each email |
| `record_consent` | What an account agreed to at sign-up, so `check_email` judges its marketing by the rules where the persona lives (EU and EEA, UK, US, Canada, Australia, New Zealand, Switzerland, Japan, South Korea, Singapore and Hong Kong) |
| `record_coupon_result` | What checkout did with a coupon the agent applied on staging: accepted, rejected or an error, with the app's message and a verdict |
| `check_offers` | Each sender's coupons and which version of the address (plain, capitals, `+tag`) each went to: whether one person got an offer twice |
| `mark_unsubscribed`, `mark_resubscribed`, `check_unsubscribe` | Record that the address unsubscribed from a sender (after the agent did it in its browser), and list any marketing email that came after |
| `check_out_account`, `extend_checkout`, `return_account` | Borrow a test account in a known state that no other test has, hold it longer if needed, and give it back |
| `start_run`, `add_run_note`, `finish_run` | Record a session as a run, each call naming its step (`test`); `finish_run` returns the report in Markdown for a pull request, compared with the last runs of the same name |

The coupon tools (`record_coupon_result`, `check_offers`) are listed when the
project tests **Offers**, and the unsubscribe, consent and sequence tools
(`mark_unsubscribed`, `mark_resubscribed`, `check_unsubscribe`,
`record_consent`, `check_sequence`) when it tests **Marketing**;
`check_email`'s coupon and marketing checks come with either. The spam checks
(`spam_risk`, with its inbox score, and `harmful_attachment`) follow the
project's **Spam checks** switch. Choose both in the Proxy Mail QA app under
Project settings → What you test, or ask the agent: `update_project` takes
`areas` and `spam_checks` and needs the project's lead. The agent sees a change
the next time it connects. A project made without choosing tests Sign-up and
Receipts, with its spam checks on.

`get_journey` is part of Journeys, still in Labs: the person who connected the
agent switches it on in the app under Account settings → Labs. Until then it
isn't listed.

The skills above are the ready-made checklists: Email flow testing covers
sign-up, codes and links, password resets and a borrowed account; Auth
regression pack the same checks every time, compared with the last runs;
Account email audit each account email the app sends; and Marketing and offer
email testing offers, unsubscribing and consent rules. (The server
also offers them as MCP prompts, for clients that show prompts.)

To build a sign-up form from screenshots of your own, share them in the chat
and ask the agent to build the form: it reads them itself, shows you each
screen's fields to correct and saves the form once you agree. Only the form is
saved; the screenshots never reach Proxy Mail QA. (The server also offers this
as the `build_signup_form_from_screenshot` prompt, for clients that show
prompts.)

Then ask in plain words: "Sign up on localhost:3000 with a new Proxy Mail QA
address and confirm the email."

## Safety

- Email results contain only the code or link, the service that sent it and when
  it expires, never the email's text, so an email can't pass instructions to the
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
