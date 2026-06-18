# DDEV Lifecycle Hooks

Defined in `config.annertech.yaml` (marked `#ddev-generated` / `#annertech-ddev`), these hooks run automatically at various points in the DDEV project lifecycle.

## post-start

Runs after `ddev start`:

1. `ddev githooks` (host) — installs the project's git hooks into `.git/hooks`.
2. `if [ ! $ANNERTECH_LOCAL_DEV ]; then ddev auth ssh; fi` (host) — sets up SSH auth for the container unless local-dev mode is set.
3. `ddev check-annertech-ddev` (host) — checks whether the installed addon version is current.
4. `ddev devmode on` (host) — switches Drupal into development settings.

## post-import-db

Runs after a database import:

1. `drush cache:rebuild` — rebuilds Drupal caches.
2. `drush sql:sanitize -y` — sanitizes sensitive data (user emails/passwords, etc.) in the imported database.
3. `ddev devmode on` (host) — re-enables devmode settings after import.
4. `if [[ $(grep 'stage_file_proxy' composer.json) ]]; then drush en stage_file_proxy -y; fi` — conditionally enables the `stage_file_proxy` module if it's present in `composer.json`, so missing files are proxied from the remote environment.
5. `drush user:login` — generates a one-time login link (drush uli) for convenience.

## post-pull

Runs after `ddev pull`:

1. `rm .ddev/.downloads/*.sql.gz` — removes the temporary database dump downloaded during the pull.
2. `echo 'Temporary dumps removed'`.
3. Two additional lines are present but commented out: suggestions to take a fresh DDEV snapshot (`ddev snapshot --name fresh --cleanup --yes` or `ddev snapshot --name fresh`) so future tests don't need to re-download the DB dump, since the dump itself is deleted after each pull.
