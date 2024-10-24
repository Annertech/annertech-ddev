# DDEV Annertech Tools

Highly opinionated set of configs and commands used by Annertech in our DDEV workflow.

## Features

- Provides commands:
- - `branch`: Creates an opinionated git branch name from a Teamwork ticket ID
- - `behat`: Runs behat inside the web container
- - `cloudflare`: Shares the project with the outside world over a Cloudflare tunnel
- - `devmode [on|off]`: Adds custom settings.local.php file and allows easy toggle between production and development mode
- - `login`: Opens a browser and logs you in to Drupal (works on local environments only)
- - `protect [on|off|reset]`: Enable or disable basic auth on a nixsal hosted dev project
- - `solr:update-config`: Updates SOLR config.zip - [see file](commands/web/solr-update-config)
- Uses DDEV Hooks to properly instantiate project for development (see `config.hooks.yaml`)
- Adds git hook to enforce proper commit messages
- Sets to development mode on project start
- Customizes NGINX configuration
- Fixes search_api_solr to communicate with local [SOLR](ddev/ddev-drupal-solr) by default (overrides might be needed for Pantheon sites)
- Automatically ignores configuration for development modules
- [Disables IP blocking modules](settings.local.devmode.php#L16)

### Automatically disabled

- TFA
- Fastly

are automatically disabled in local environment to facilitate development.

## Install

### 1. Cleanup First

First clean-up previous variations of these files from before they were grouped in an addon.

It is a good idea to update `anrt-tools/docksal-configuration` first:
```
composer update anrt-tools/docksal-configuration
```
This way composer will not overwrite DDEV files that used to live alongside Docksal files (long story).

and then:

```
rm -rf .ddev/settings.ddev.annertech.php
rm -rf .ddev/config.hooks.yaml
rm -rf .ddev/commands/host/branch
rm -rf .ddev/commands/host/login
rm -rf .ddev/commands/web/robo
rm -rf .ddev/commands/web/behat
```

### 2. Get the new addon

Then get the addon:
```
ddev get annertech/annertech-ddev
```

### 3. Commit to project repo

Ideally, add addon files to git:
```
git add .ddev/settings.ddev.annertech.php
git add .ddev/commands/host/branch -f
git add .ddev/commands/host/cex -f
git add .ddev/commands/host/cim -f
git add .ddev/commands/host/cr -f
git add .ddev/commands/host/cloudflare -f
git add .ddev/commands/host/devmode -f
git add .ddev/commands/host/githooks -f
git add .ddev/commands/host/login -f
git add .ddev/commands/host/protect -f
git add .ddev/commands/host/remote-db -f
git add .ddev/commands/web/behat -f
git add .ddev/commands/web/robo -f
git add .ddev/commands/web/solr-update-config -f

git add .ddev/nginx/ -f
git add .ddev/scripts/ -f

git add .ddev/config.hooks.yaml -f
git add .ddev/settings.local.*mode.php -f

git add .ddev/addon-metadata/ -f

git add .vscode -f
```

```
git commit -m 'Add annertech/annertech-ddev addon' --no-verify'
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

## Common Problems and How-To Fix Them

### commit-msg hook is ignored

Check `git config -l` for the value of `core.hooksPath` and can change it to the local path with

```
git config --local core.hooksPath .git/hooks
```
