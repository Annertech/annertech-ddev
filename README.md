# DDEV Annertech Tools

Highly opinionated.

## What it does:

- Provides commands:
- - robo
- - behat
- - login
- Adds actions on DDEV hooks
- Adds custom settings.local.php file on project start

## Install

```
rm -rf .ddev/settings.ddev.annertech.yaml
rm -rf .ddev/config.hooks.yaml
rm -rf .ddev/commands/host/branch
rm -rf .ddev/commands/host/login
rm -rf .ddev/commnads/web/robo
rm -rf .ddev/commnads/web/behat

ddev get bserem/annertech-ddev
```