# Web Container Commands

These commands run inside the DDEV web container (via `ddev <command>`), from `commands/web/`.

Note: `install-varnish` exists in this directory but is intentionally not documented here.

## Commands

- `behat` — Runs Behat tests. Errors if `tests/behat` doesn't exist; `cd`s into it, runs `composer install`, then touches `web/.behat_testing` (a flag file read by `settings.local.devmode.php`/`settings.local.perfmode.php` to disable captcha/antibot and force-enable CSS/JS aggregation during test runs) before invoking `bin/behat "$@"`. The flag file is removed via a `trap` on EXIT/INT/TERM. Includes a comment noting `big_pipe` should be disabled/re-enabled in `FeatureContext.php`'s suite hooks since it conflicts with Behat.
- `check-annertech-ddev` — Checks whether the installed annertech-ddev addon is current: reads the local version from `.ddev/addon-metadata/annertech-ddev/manifest.yaml`, fetches the latest GitHub release tag (cached for 24 hours in `/tmp`), compares with `sort -V`, and prints an "Up to date" or "Update required!" message with upgrade instructions.
- `install-bruno` — Sets up Bruno API-test configuration: determines the main branch, fetches Dev/Live environment URLs via `platform url`, copies a Bruno template into `tests/bruno`, strips `#ddev-generated` markers from `.bru` files, and substitutes the `DEV_URL`/`LIVE_URL` placeholders in the environment files.
- `phpunit` — Runs PHPUnit. Verifies `vendor/bin/phpunit` exists (errors if `drupal/core-dev` isn't required), then runs it from `$DOCROOT` with `--config ../.ddev`, forwarding all arguments.
- `platform` — Thin wrapper that runs `upsun "$@"` inside the container — a back-compat alias pointing at the `upsun` binary.
- `rector` — Runs Rector (Drupal-Rector). If `rector.php` exists, installs `palantirnet/drupal-rector` on demand if missing and runs `vendor/bin/rector process web/modules/custom/ "$@"`. If no config is found, prints setup instructions and exits 1.
- `robo` — Thin wrapper that runs `robo "$@"` inside the container to invoke project Robo tasks.
- `solr-update-config` — Updates Solr config. If the project's own Robo file defines `solr:update-conf`, delegates to it; otherwise generates `config.zip` via `drush search-api-solr:get-server-config`, unzips it into `.ddev/solr/conf/` and `.platform/solr-conf/8.x/`, then removes the zip. Restricted to drupal10/drupal11 project types.
- `upsun` — Thin wrapper that runs `upsun "$@"` inside the container — the canonical way to invoke the Upsun (formerly Platform.sh) CLI, e.g. `ddev upsun drush uli`.
