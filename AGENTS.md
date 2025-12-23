# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **annertech-ddev**, a DDEV add-on providing Annertech's opinionated development workflow for Drupal projects. It's installed into client projects via `ddev add-on get annertech/annertech-ddev` and provides commands, configurations, and automation for Drupal development.

## Directory Structure

```
commands/
├── host/     # 19 host-side commands (run on developer machine)
└── web/      # 13 web container commands (run inside DDEV container)
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
- `config.annertech.yaml` - DDEV hooks (pre-start, post-start, post-import-db)
- `settings.local.devmode.php` - Development mode Drupal settings
- `settings.local.perfmode.php` - Performance/production mode settings

## Key Development Commands

### Testing
- `bats tests/test.bats` - Run add-on installation tests

### Important Host Commands
- `uptools` / `upbash` - Multi-tool menu for Platform.sh/Upsun (Python/Bash versions)
- `branch` - Creates git branches from Teamwork IDs (format: `YYYYMM_T-ID__description`)
- `drupal-updater` - Automated Drupal core/contrib updates
- `devmode` - Toggle between dev/prod Drupal settings

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

- `global_files` - Commands installed to `~/.ddev/commands/` (available globally)
- `project_files` - Commands installed to project's `.ddev/` directory
- `post_install_actions` - Run after installation (cleanup old files, git add)
- `removal_actions` - Cleanup when add-on is removed

## Platform.sh/Upsun Integration

Commands use `ddev exec upsun` or `ddev exec platform` to run CLI tools inside container. Argument order matters: `upsun drush uli --project=ID -e ENV` (subcommand before flags).

## Claude Code Configuration

- Reply using 300 words max
- Use `upsun` CLI (not `platform`) for new code
- Test changes with `bats tests/test.bats`
- Commands should have `#ddev-generated` marker for auto-cleanup and update
- Commands should have `#annertech-ddev` marker for auto-cleanup
