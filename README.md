# DDEV Annertech Tools

Highly opinionated set of configs and commands used by Annertech in our DDEV workflow.

## What it does:

- Provides commands:
- - `branch`: Creates an opinionated git branch name from a Teamwork ticket ID
- - `behat`: Runs behat inside the web container
- - `devmode [on|off]`: Adds custom settings.local.php file and allows easy toggle between production and development mode
- - `login`: Opens a browser and logs you in to Drupal (works on local environments only)
- - `robo`: Runs robo inside the web container
- Uses DDEV Hooks to properly instatiate project for development (see `config.hooks.yaml`)
- Adds git hook to enforce proper commit messages
- Sets to development mode on project start

## Install

First clean-up previous variations of these files from before they were grouped in an addon.
```
rm -rf .ddev/settings.ddev.annertech.php
rm -rf .ddev/config.hooks.yaml
rm -rf .ddev/commands/host/branch
rm -rf .ddev/commands/host/login
rm -rf .ddev/commands/web/robo
rm -rf .ddev/commands/web/behat
```

Then get the addon:
```
ddev get annertech/annertech-ddev
```

Ideally, add addon files to git:
```
git add .ddev/commands/branch
git add .ddev/commands/host/
git add .ddev/commands/host/branch -f
git add .ddev/commands/host/login -f
git add .ddev/commands/host/devmode -f
git add .ddev/commands/host/githooks -f
git add .ddev/commands/web/behat -f
git add .ddev/commands/web/robo -f

git add .ddev/scripts/ -f

git add .ddev/config.hooks.yaml -f
git add .ddev/settings.local.devmodeO* -f

git add .vscode
```

## Automated Testing commands provided

### Behat

`ddev behat` command is provided and expects behat to be under `PROJECT_ROOT/tests/behat`.

### BackstopJS

We rely on https://github.com/mmunz/ddev-backstopjs to get BackstopJS commands in DDEV. Go look there.
