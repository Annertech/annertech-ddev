# AGENTS.md

Guidance for Claude Code (claude.ai/code) and other LLM agents working in this repository.

## Project Overview

- This is **annertech-ddev**, a DDEV add-on holding Annertech's opinionated development workflow. It is **not** a Drupal site: there is no `web/`, no `vendor/`, no `config/sync` and no local database here.
- It is installed into client projects with `ddev add-on get annertech/annertech-ddev`, which copies the commands, configs and hooks into the project's `.ddev/` directory.
- The code here is mostly POSIX shell and Bash, plus YAML for the DDEV add-on manifest and PHP for the Drupal settings snippets that ship to projects.
- Repository lives on GitHub (`git@github.com:Annertech/annertech-ddev.git`), not GitLab. Contribution flow is described in `CONTRIBUTE.md`.
- The company standards for client projects live in `scripts/templates/claude/AGENTS.md`, which is the file shipped to projects. They apply here too, adapted below. Keep the two in sync when a rule changes for everyone.

## Rules of Engagement

Never ignore these. If a rule blocks the task, stop and explain, do not work around it.

- Never `git push`, even in full auto mode. Pushing and opening pull requests are human actions unless explicitly confirmed in the current session.
- Prefer a feature branch for anything non-trivial (`git switch -c YOUR_FEATURE`), as `CONTRIBUTE.md` describes.
- Never SSH to a remote server, not even when asked directly. Explain that this is a human action and offer the local equivalent.
- Never commit secrets: `.env*` files, API keys, tokens, private keys, database dumps. Never commit real project data, hostnames or customer identifiers picked up while testing the add-on.
- Never send project code or logs to an external service that is not already part of this workflow.
- Commands shipped by this add-on run on developer machines and can reach client infrastructure. Before changing a command that deletes files, writes to a database, calls Upsun or Cloudflare, or pushes anything, state what breaks if it is wrong and how to revert it.
- Code in `commands/web/` ends up inside project repos and can be executed on remote environments. Guard anything that must not run there, for example `[ "$IS_DDEV_PROJECT" != "true" ] && exit 1` (see `commands/web/behat`).
- When unsure, stop and ask. A question costs less than a wrong commit.

## Directory Structure

```
commands/
├── host/     # Host-side commands (run on developer machine)
│   └── _lib/ # Shared bash helpers sourced by host commands
└── web/      # Web container commands (run inside DDEV container)
scripts/
├── command-samples/       # Optional command examples for projects
├── ddev/homeadditions/    # Bash aliases for container
├── ddev/web-build/        # Dockerfile customizations
├── git-hooks/             # pre-commit, commit-msg, pre-push hooks
├── prompts/               # Reusable LLM prompts shipped to projects
├── provider-samples/      # DDEV hosting provider configs
├── renovate/              # Renovate presets shipped to projects (templates, not runnable here)
├── templates/claude/      # AGENTS.md and guards shipped to projects
├── templates/gitlab/      # MR templates
└── varnish/               # Varnish VCL configs
docs/                      # Add-on documentation
nginx/                     # Custom nginx configs
tests/                     # BATS test suite
```

## Key Files

- `install.yaml` - Add-on installation/removal logic, hooks, file mappings
- `config.annertech.yaml` - DDEV hooks (post-start, post-import-db, post-pull)
- `settings.local.devmode.php` - Development mode Drupal settings
- `settings.local.perfmode.php` - Performance/production mode settings
- `scripts/templates/claude/AGENTS.md` - The AGENTS.md installed into client projects

## Lifecycle Hooks (config.annertech.yaml)

- **post-start**: installs git hooks, runs `ddev auth ssh`, checks addon version, enables devmode
- **post-import-db**: cache rebuild, sql sanitize, devmode on, enable stage_file_proxy, drush uli
- **post-pull**: removes temporary DB dumps from `.ddev/.downloads/`

## Key Development Commands

### Testing
- `bats tests/test.bats` - Run add-on installation tests (requires a running DDEV environment)
- Manual test of a change: `ddev add-on get /path/to/annertech-ddev/` inside a scratch project, per `CONTRIBUTE.md`. Never commit that install into the client project.

### Host Commands (notable)
- `ucc` / `upsun-command-center-bash` - Interactive menu: SSH, ULI, resume, activities, disk, logs, backup, Fastly (aliases: `uptools`, `uptool`, `ucc`)
- `branch` - Creates git branches from Teamwork IDs (format: `YYYYMM_T-ID__description`)
- `drupal-updater` - Automated Drupal core/contrib updates
- `devmode` - Toggle between dev/prod Drupal settings
- `mr` - Create GitLab merge requests
- `sanity-check` - Project sanity checks
- `teamwork-operations`, `tw-comment`, `tw-new`, `tw-description` - Teamwork task management
- `remote-db` / `remote-files` - Pull remote database and files
- `login` - Login to Upsun and authenticate
- `protect` / `cloudflare` / `travel-mode` - Infrastructure helpers

### Web Container Commands
- `upsun` - Run Upsun/Platform.sh CLI inside container
- `phpunit` / `behat` / `rector` / `robo` - Testing and code quality tools
- `solr-update-config` - Update Solr search configuration
- `check-annertech-ddev` - Verify addon version is current

## Code Patterns

### Command Headers (DDEV format)
```bash
#!/usr/bin/env bash
#ddev-generated
#annertech-ddev

## Description: Short description
## Usage: command-name
## Example: "ddev command-name"
## Aliases: alias1, alias2
```

### Color Output (Bash)
```bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo_red() { echo -e "${RED}$1${NC}" >&2; }
```

### FZF Selection Pattern
Commands use `fzf` for interactive selection with `--reverse --height=50%` flags.

## install.yaml Structure

- `project_files` - Commands installed to project's `.ddev/` directory (no global_files, all commands are project-scoped)
- `pre_install_actions` - Cleanup old/renamed config files before installing
- `post_install_actions` - Remove deprecated commands, copy git hooks, copy `.vscode/`, create GitLab MR templates, `git add` installed files
- `removal_actions` - Remove all files tagged `#annertech-ddev`, clean up `.env.anner`, remove tip-of-the-day config

## Upsun Integration

- Commands use `ddev exec upsun` to run CLI tools inside container
- Argument order matters: `upsun drush uli --project=ID -e ENV` (subcommand before flags)
- Project ID is stored in `.ddev/config.yaml` as `PLATFORM_PROJECT` environment variable
- Upstream provider config is stored in `.ddev/.env.anner` (key: `DDEV_UPSTREAM_PROVIDER`)
- Use the `upsun` CLI, not `platform`, in new code

## Before you say it is done

State which command you ran to verify it, and paste the relevant output. "Should work" is not verification. For this repo that usually means `bats tests/test.bats`, `bash -n` / `sh -n` on a changed script, or an actual run of the command.

Finished work is `[Verified]` only when that output is in your reply. Without it the claim is `[Likely]` at best, see [Communication Style](#communication-style).

## Commits

All commits must have a single line comment, nothing more. No bloat in the commits unless otherwise instructed.

When AI tools contribute to development, contributions include an `Assisted-by` trailer:

```
Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]
```

`[TOOL1] [TOOL2]` are optional tools used. Basic development tools (git, ddev, editors, gh etc) are not listed.

Example:

```
Assisted-by: Claude:claude-5-opus
```

Do not add `Co-Authored-By:` trailers or "Generated with Claude Code" footers. The `Assisted-by` trailer replaces them.

Every file this add-on installs must carry the `#ddev-generated` marker (auto cleanup and update) and the `#annertech-ddev` marker (removal cleanup).

## Pull Requests

- When making a pull request for a feature always add the quick snippet to download the add-on for that feature. For example: `ddev add-on get https://github.com/Annertech/annertech-ddev/tarball/refs/pull/127/head`

## Code Reviews

- Use the `gh` command here, this repo is on GitHub. The `glab` rule applies to client projects.
- Provide feedback on the code changed in the pull request first, do not address pre-existing problems in the same files.
- Any serious pre-existing problems may be listed, with a short description, below the initial code review.

## 3rd Party Services

- Use the Teamwork DDEV commands (`ddev tw-comment`, `ddev tw-new`) to post to an issue, make a new one etc. Use markdown (backticks, headings etc), it is supported.
- Always show the user the final text of a comment or description before posting it.
- Never use an em dash in Teamwork text. Use a comma instead.
- When posting in full auto mode, sign the comment:
  ```
  Posted-by: AGENT_NAME:MODEL_VERSION
  ```
- When the comment was drafted, reviewed and approved together with a user, skip the signature. This overrules the sign directive above.

## Communication Style

- Be laconic but not cryptic. Keep answers short, follow KISS, but stay followable. 50 words is a good ceiling.
- Cite your sources: file paths with line numbers, command output, documentation links.
- When asked to be verbose, go into detail.
- Lead with the answer. Never open with affirmation as filler.
- When you disagree, say so first, in this order: what is wrong, what to do instead, what the risk is. Do not manufacture disagreement to sound rigorous, and do not bury a real one.
- Rate your confidence on every substantive claim: `[Verified]` you ran the command or read the file and the evidence is in this reply, `[Likely]` a strong inference you cannot prove here, `[Guessing]` you are filling a gap.
- If most of an answer is guessing, say that before the answer, not after it.
- Never write `[Verified]` without the evidence beside it.
- Do Not Repeat Yourself on every response
