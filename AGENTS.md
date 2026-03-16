# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **annertech-ddev**, a DDEV add-on providing Annertech's opinionated development workflow for Drupal projects. It's installed into client projects via `ddev add-on get annertech/annertech-ddev` and provides commands, configurations, and automation for Drupal development.

## Directory Structure

```
commands/
├── host/     # Host-side commands (run on developer machine)
└── web/      # Web container commands (run inside DDEV container)
scripts/
├── ddev/homeadditions/    # Bash aliases for container
├── ddev/web-build/        # Dockerfile customizations
├── git-hooks/             # pre-commit, commit-msg hooks
├── templates/gitlab/      # MR templates
└── varnish/               # Varnish VCL configs
nginx/                     # Custom nginx configs
tests/                     # BATS test suite
```

## Key Files

- `install.yaml` - Add-on installation/removal logic, hooks, file mappings
- `config.annertech.yaml` - DDEV hooks (post-start, post-import-db, post-pull)
- `settings.local.devmode.php` - Development mode Drupal settings
- `settings.local.perfmode.php` - Performance/production mode settings

## Lifecycle Hooks (config.annertech.yaml)

- **post-start**: installs git hooks, runs `ddev auth ssh`, checks addon version, enables devmode
- **post-import-db**: cache rebuild, sql sanitize, devmode on, enable stage_file_proxy, drush uli
- **post-pull**: removes temporary DB dumps from `.ddev/.downloads/`

## Key Development Commands

### Testing
- `bats tests/test.bats` - Run add-on installation tests (requires a running DDEV environment)

### Host Commands (notable)
- `ucc` / `upsun-command-center-bash` - Interactive menu: SSH, ULI, resume, activities, disk, logs, backup, Fastly (aliases: `uptools`, `uptool`, `ucc`)
- `branch` - Creates git branches from Teamwork IDs (format: `YYYYMM_T-ID__description`)
- `drupal-updater` - Automated Drupal core/contrib updates
- `devmode` - Toggle between dev/prod Drupal settings
- `mr` - Create GitLab merge requests
- `sanity-check` - Project sanity checks
- `teamwork-operations` - Teamwork task management
- `remote-db` - Pull remote database
- `login` - Login to Upsun and authenticate
- `protect` / `cloudflare` / `travel-mode` - Infrastructure helpers

### Web Container Commands
- `upsun` / `platform` - Run Upsun/Platform.sh CLI inside container
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

- `project_files` - Commands installed to project's `.ddev/` directory (no global_files — all commands are project-scoped)
- `pre_install_actions` - Cleanup old/renamed config files before installing
- `post_install_actions` - Remove deprecated commands, copy git hooks, copy `.vscode/`, create GitLab MR templates, `git add` installed files
- `removal_actions` - Remove all files tagged `#annertech-ddev`, clean up `.env.anner`, remove tip-of-the-day config

## Platform.sh/Upsun Integration

- Commands use `ddev exec upsun` or `ddev exec platform` to run CLI tools inside container
- Argument order matters: `upsun drush uli --project=ID -e ENV` (subcommand before flags)
- Project ID is stored in `.ddev/config.yaml` as `PLATFORM_PROJECT` environment variable
- Upstream provider config is stored in `.ddev/.env.anner` (key: `DDEV_UPSTREAM_PROVIDER`)

## Claude Code Configuration

- Reply using 300 words max
- Use `upsun` CLI (not `platform`) for new code
- Test changes with `bats tests/test.bats`
- Commands must have `#ddev-generated` marker for auto-cleanup and update
- Commands must have `#annertech-ddev` marker for removal cleanup
