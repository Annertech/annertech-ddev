# DDEV Annertech Tools

Highly opinionated set of configs and commands used by Annertech in our DDEV workflow.

## Install

### 1. Get the new addon

Then get the addon:
```
ddev add-on get annertech/annertech-ddev
```

### 2. Commit to project repo

<details>
    <summary>
      Add add-on files to git (happens automatically)
    </summary>

```
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
git add .ddev/commands/host/timeslip -f
git add .ddev/commands/web/behat -f
git add .ddev/commands/web/robo -f
git add .ddev/commands/web/platform -f
git add .ddev/commands/web/solr-update-config -f

git add .ddev/nginx/ -f
git add .ddev/scripts/ -f

git add .ddev/config.annertech.yaml -f
git add .ddev/settings.local.*mode.php -f

git add .ddev/.env -f

git add .ddev/addon-metadata/ -f

git add .vscode -f
```
</details>

```
git commit -m 'Add annertech/annertech-ddev addon' --no-verify
```

## Features

- Provides **global** commands (available in all projects, project level commands below take priority):
- - [`branch`](commands/host/branch): Creates an opinionated git branch name from a Teamwork ticket ID
- - [`cloudflare`](commands/host/cloudflare): Shares the project with the outside world over a Cloudflare tunnel
- - [`drupal-updater`](commands/host/drupal-updater): Automatically updates Core and Contrib
- - [`login`](commands/host/login): Opens a browser and logs you in to Drupal (works on local environments only)
- - [`open-issue`](commands/host/open-issue): Opens teamwork issue for current branch
- - [`timeslip`](commands/host/timeslip): Generates a timeslip message for FreeAgent. If `timewarrior` is installed it will also show the sum of time spent today
- - [`timew`](commands/host/timew): Tags current timewarrior tracking with Teamwork link and project name
- - [`travel-mode`](commands/host/travel-mode): Removes all DB dumps 
    downloaded via `ddev pull`, also provides info on how to remove all DDEV 
    projects and their databases
- Provides **host** commands:
- - [`branch`](commands/host/branch): Creates an opinionated git branch name from a Teamwork ticket ID
- - [`cloudflare`](commands/host/cloudflare): Shares the project with the outside world over a Cloudflare tunnel
- - [`devmode [on|off]`](commands/host/devmode): Adds custom settings.local.php file and allows easy toggle between production and development mode
- - [`drupal-updater`](commands/host/drupal-updater): Automatically updates Core and Contrib
- - [`githooks`](commands/host/githooks): Installs git-hooks (also happens on project start)
- - [`login`](commands/host/login): Opens a browser and logs you in to Drupal (works on local environments only)
- - [`protect [on|off|reset]`](commands/host/protect): Enable or disable basic auth on a nixsal hosted dev project - [see file](commands/host/protect)
- - [`timeslip`](commands/host/timeslip): Generates a timeslip message for FreeAgent. If `timewarrior` is installed it will also show the sum of time spent today
- Provides **web container** commands:
- - [`behat`](commands/web/behat): Runs behat
- - [`install-varnish`](commands/web/install-varnish): Installs and configures Varnish on platform.sh project. See [Varnish command README](scripts/varnish/README.md)
- - [`platform`](commands/web/platform): Runs `platform cli`
- - [`robo`](commands/web/robo): Runs robo
- - [`solr:update-config`](commands/web/solr-update-config): Updates SOLR config.zip
- Uses DDEV Hooks to [properly instantiate project for development](config.hooks.yaml)
- [Adds git hook to enforce proper commit messages](scripts/git-hooks/commit-msg)
- [Sets to development mode on project start](config.annertech.yaml#L3)
- [Customizes NGINX configuration](nginx)
- Fixes search_api_solr to communicate with local [SOLR](ddev/ddev-drupal-solr) by [default](settings.local.devmode.php#L21) (special overrides might be needed for Pantheon sites)
- [Automatically ignores configuration for development modules](settings.local.devmode.php#L170)

### Automatically disabled

- [Fastly](settings.local.devmode.php#L4$)
- [IP blocking modules](settings.local.devmode.php#L41)
- [Shield](settings.local.devmode.php#L35)
- [TFA](settings.local.devmode.php#L38)

are automatically disabled in local environment to facilitate development.

## Automated Testing commands provided

### Behat

`ddev behat` command is provided and expects behat to be under `PROJECT_ROOT/tests/behat`.

> [!NOTE]
>
> Antibot will block Behat! Remember to uninstall it if needed.

### BackstopJS

We rely on https://github.com/mmunz/ddev-backstopjs to get BackstopJS commands in DDEV. Go look there.

### Cypress

We rely on https://github.com/tyler36/ddev-cypress and, if needed, 
https://www.drupal.org/project/drush_endpoint for Cypress tests.

### ReCaptcha bypass

See https://github.com/Annertech/annertech-ddev/pull/29/files on how to bypass recaptcha when running automated tests.

## Environment Indicators

Environment indicators in the Drupal Toolbar are tricky because we need to ensure that colors don't conflict with each other and also work with white text.

The following colors should be used:

| Color                                                              | HEX       | Contrast | Environment |
|--------------------------------------------------------------------|-----------|----------|-------------|
| ![local](https://placehold.co/120x40/4A0080/white?text=local-ddev) | `#4A0080` | 13:1     | local, ddev |
| ![dev](https://placehold.co/120x40/005B94/white?text=development)  | `#005B94` | 7:1      | dev         |
| ![stage](https://placehold.co/120x40/59590D/white?text=staging)    | `#59590D` | 7:1      | stage       |
| ![live](https://placehold.co/120x40/8b0000/white?text=production)  | `#8B0000` | 10:1     | production  |

This is what people with color vision deficiency see when using the above colors:

![Environment Indicator color palette](assets/color_palette.png)

> [!NOTE]
>
> Please note that the add-on only controls the local environment color.
> You must fix the rest yourself!

<details>
    <summary>
        Platform.sh config for SimpleI environment indicator
    </summary>
    <pre><code>
// Per environment settings:
// Configure environment indicator (simplei)
if (isset($platformsh->branch)) {
  // Production type environment.
  if ($platformsh->branch == 'main' || $platformsh->onDedicated()) {
    $settings['simple_environment_indicator'] = '#8B0000 LIVE';
  }
  // Staging type environment
  else if ($platformsh->branch == 'stage') {
    $settings['simple_environment_indicator'] = '#59590D STAGE';
  }
  // Development type environment.
  else {
    $settings['simple_environment_indicator'] = '#005B94 DEV';
  }
}
    </code></pre>
</details>

## Tricks

Handy shell aliases to add to your **host** machine:
```
# DDEV
alias composer='ddev composer'
alias behat='ddev behat'
alias drush='ddev drush'
alias platform='ddev platform'
alias robo='ddev robo'

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
