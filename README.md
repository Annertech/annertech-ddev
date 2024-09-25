# DDEV Annertech Tools

Highly opinionated set of configs and commands used by Annertech in our DDEV workflow.

## What it does:

- Provides commands:
- - robo
- - behat
- - login
- Adds actions on DDEV hooks
- Adds custom settings.local.php file on project start

## Install

First clean-up previous variations of these files from before they were grouped in an addon.
```
rm -rf .ddev/settings.ddev.annertech.yaml
rm -rf .ddev/config.hooks.yaml
rm -rf .ddev/commands/host/branch
rm -rf .ddev/commands/host/login
rm -rf .ddev/commnads/web/robo
rm -rf .ddev/commnads/web/behat
```

Then get the addon:
```
ddev get bserem/annertech-ddev
```

## Automated Testing commands provided

### Behat

`ddev behat` command is provided and expects behat to be under `PROJECT_ROOT/tests/behat`.

### BackstopJS

We rely on https://github.com/mmunz/ddev-backstopjs to get BackstopJS commands in DDEV. Go look there.