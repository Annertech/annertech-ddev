# AGENTS.md

Guidance for Claude Code (claude.ai/code) and other LLM agents working in this repository.

## Project Overview

- This is a Drupal project, managed by Annertech.
- It contains both contrib and custom code.
- It runs locally inside DDEV. Run application commands, including PHP, Composer, Drush, tests and frontend builds, through DDEV. Local file inspection, editing and Git operations may use host tools. Never target remote Drupal environments, including through Drush aliases or wrapper commands. GitLab and Teamwork access follows the third-party services rules.
- Local databases are sanitized with drush **default** sanitization only. That rewrites user emails and passwords. It does **not** clear webform submissions, comment bodies, custom field data, log tables or files. Treat the local database as containing real personal data.

## Rules of Engagement

Never ignore these. If a rule blocks the task, stop and explain, do not work around it.

- The Claude account this session is signed in to must be on the Annertech organisation. This is enforced by .ddev/scripts/templates/claude/annertech-account-guard.sh, wired up in .claude/settings.json, which denies every tool call otherwise. Do not disable, edit or work around that hook. If it refuses, tell the user to run /login.
- Never `git push`, even in full auto mode. `ddev mr` is pushing, you are not allowed to run it without confirmation.
- Never commit to `main` or `master`. Create a branch with `ddev branch` first. Never `ddev mr` while on those branches.
- Never SSH to a remote server, not even when asked directly. Explain that this is a human action and offer the local equivalent. SSH inside DDEV is fine.
- Never commit secrets: `.env*` files, API keys, tokens, private keys, database dumps.
- .ddev/.env.anner may be committed only with non-secret configuration. Never commit credentials or personal data, regardless of filename.
- Never send project code, database contents or logs to an external service that is not already part of this workflow.
- Never run `composer update`, `drush sql-drop`, `drush sql-cli` writes or destructive drush commands without explicit approval.
- Before any change that touches the database, `config/sync` or contrib code, state what breaks if it is wrong and how to revert it.
- All changes to contrib code (modules, themes, core) ship as composer patches. You may edit contrib files to prove a point, but those edits must never be committed.
- Use Drupal coding standards.
- When unsure, stop and ask. A question costs less than a wrong commit.

### Personal data

- Do not export, copy or summarize user records, email addresses, IP addresses or form submissions out of the project.
- Never paste real personal data into commit messages, merge requests, Teamwork comments or chat output. Redact it.
- If a task needs data you cannot handle safely under GDPR, stop and say so.
- Access logs: see https://github.com/bserem/access-log-forensics-skill. In short, never join logs to identities, never retain raw IPs outside the project, and aggregate before reporting.

## How We Work Here

### Issue tracking

Get the issue ID from the git branch name, format `YYYYMM_T-[teamwork-issue-id]__description`.
Example: `202409_T-17360561__description`, issue ID is `17360561`.

### Where things live

- Custom code: `web/modules/custom`, `web/themes/custom`
- Contrib and core: `web/modules/contrib`, `web/themes/contrib`, `web/core`, `vendor` (read only, patches only)
- Exported config: `config/sync` (never hand edit unless specifically instructed, always export)
- Local settings: `settings.local.php` (never edit `settings.php`)

### Common commands

| Task | Command |
| --- | --- |
| Drush | `ddev drush <command>` |
| Create branch from Teamwork ID | `ddev branch` |
| Create a merge request | `ddev mr` |
| Comment on a Teamwork task | `ddev tw-comment "<comment>"` |

### Config workflow

1. Inspect existing configuration differences before making changes.
2. Make the requested change locally.
3. Export with ddev drush cex.
4. Review the complete diff and include only changes belonging to the task. Preserve unrelated work.
5. Add update or deploy hooks only for migration work that configuration import does not handle. Follow the project’s deployment order.
6. Verify using the project’s local deployment and testing workflow.

### Before you say it is done

State which command you ran to verify it, and paste the relevant output. "Should work" is not verification.

Finished work is `[Verified]` only when that output is in your reply. Without it the claim is `[Likely]` at best, see [Communication Style](#communication-style).

## Commits

All commits must have a single line comment, nothing more. No bloat in the commits unless otherwise instructed.

When AI tools contribute to development, proper attribution helps track the evolving role of AI in the development process.
Contributions include an `Assisted-by` trailer:

```
Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]
```

`[TOOL1] [TOOL2]` are optional tools used. Basic development tools (git, ddev, drush, editors) are not listed.

Example:

```
Assisted-by: Claude:claude-5-opus xhprof
```

Do not add `Co-Authored-By:` trailers or "Generated with Claude Code" footers. The `Assisted-by` trailer replaces them.

## 3rd Party Services

- Use the `glab` command for code reviews.
- Use the Teamwork DDEV commands (`ddev tw-comment`, `ddev tw-new`) to post to an issue, make a new one etc.
- Always show the user the final text of a comment or description before posting it.
- Never use an em dash in Teamwork text. Use a comma instead.
- When posting in full auto mode, sign the comment:
  ```
  Posted-by: AGENT_NAME:MODEL_VERSION
  ```
- When the comment was drafted, reviewed and approved together with a user, skip the signature.

## Communication Style

- Be laconic but not cryptic. Keep answers short, follow KISS, but stay followable.
- Cite your sources: file paths with line numbers, command output, documentation links.
- When asked to be verbose, go into detail.
- Lead with the answer. Never open with affirmation as filler.
- When you disagree, say so first, in this order: what is wrong, what to do instead, what the risk is. Do not manufacture disagreement to sound rigorous, and do not bury a real one.
- Rate your confidence on every substantive claim: `[Verified]` you ran the command or read the file and the evidence is in this reply, `[Likely]` a strong inference you cannot prove here, `[Guessing]` you are filling a gap. This is about how sure you are, not about whether a tool was available, so it applies to bug triage, log analysis, support answers and rubber ducking just as much as to code changes.
- If most of an answer is guessing, say that before the answer, not after it.
- Never write `[Verified]` without the evidence beside it.

## Project Specifics

<!--
#ddev-generated
Add per project facts below: production and staging environment names, theme build
steps, search backend, deployment quirks, modules with unusual behaviour.

Everything above this section ships with annertech-ddev and is refreshed on every
add-on update, which overwrites whatever you put here. To take ownership of this
file and stop receiving updates, delete the #ddev-generated comment above.
-->
