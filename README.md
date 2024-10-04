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
git add .ddev/commands/host/branch -f
git add .ddev/commands/host/login -f
git add .ddev/commands/host/devmode -f
git add .ddev/commands/host/githooks -f
git add .ddev/commands/web/behat -f
git add .ddev/commands/web/robo -f

git add .ddev/scripts/ -f

git add .ddev/config.hooks.yaml -f
git add .ddev/settings.local.*mode.php -f

git add .ddev/addon-metadata/

git add .vscode
```

## Automated Testing commands provided

### Behat

`ddev behat` command is provided and expects behat to be under `PROJECT_ROOT/tests/behat`.

### BackstopJS

We rely on https://github.com/mmunz/ddev-backstopjs to get BackstopJS commands in DDEV. Go look there.

## Tricks

Handy shell aliases to add to your **host** machine:
```
# DDEV
alias composer='ddev composer'
alias drush='ddev drush'
alias robo='ddev robo'
alias behat='ddev behat'

alias xe='ddev xdebug enable'
alias xd='ddev xdebug disable'
alias xt='status=$(ddev xdebug status) &&  if [ "$status" == "xdebug enabled" ]; then ddev xdebug off; else ddev xdebug on; fi' 

# If you don't want to have platform cli installed on your host you can rely to the one in DDEV
alias platform='ddev exec platform'
```

## Common problem fixes

### commit-msg hook not working

If the `.git/hooks/commit-msg` is the same file as `.ddev/scripts/git-hooks/commit-msg` than it might be that `core.hooksPath` is being set to another path other than `$GIT_DIR/hooks`, making your hooks in that folder ignored.  

Check `git config -l` for the value of `core.hooksPath` and can change it to the local path with

```
git config --local core.hooksPath .git/hooks
```