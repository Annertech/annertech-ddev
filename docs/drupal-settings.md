# Drupal Local Settings (devmode / perfmode)

The repo root contains two DDEV-generated `settings.local.*.php` files. The `devmode` host command copies whichever one is active into the project's `settings.local.php`. No other `settings*.php` files exist at the repo root (checked with `find . -maxdepth 1 -iname "settings*.php"`).

## Common to both files

Both files share most of their baseline overrides:

- Enables `drush_endpoint` (`drush_endpoint_enabled`, `drush_endpoint_allow_uli`).
- Sets a `simple_environment_indicator` banner (purple `#4A0080`) — `'LOCAL DEVMODE'` vs `'LOCAL PERFORMANCE MODE'` text distinguishes the two modes visually in the admin toolbar.
- Points Stage File Proxy's `origin` at `getenv('STAGE_FILE_PROXY_URL')`.
- Overrides the Search API Solr connector to use the local `solr` service (`http://solr:8983/`, core `dev`).
- Overrides SMTP settings to point at `localhost:1025` (a local mail-capture tool such as Mailhog), with blank credentials.
- Defaults `file_private_path` to `../private` if not already set.
- Disables Shield, TFA, IP restriction (`restrict_ip`), OpenTelemetry (`opentelemetry.settings.disable`), and clears the Fastly API key/site ID — security/CDN/observability modules that shouldn't be active locally.
- Sets `rebuild_access = TRUE` and `skip_permissions_hardening = TRUE`.
- Excludes `devel`, `devel_a11y`, `devel_php`, `stage_file_proxy`, `twig_vardumper`, `upgrade_status`, and `drush_endpoint` from configuration sync (`config_exclude_modules`), so these dev-only modules never leak into exported config.
- Includes an optional `settings.project.php` (in the same directory) if present, for project-specific overrides.
- **Behat test detection**: both files end with an `if (file_exists(DRUPAL_ROOT . '/.behat_testing'))` block. This flag file is created by the `behat` web command for the duration of a test run (and removed on exit via a trap) because environment variables aren't shared between the CLI process and PHP-FPM. When present, both modes:
  - Disable CAPTCHA on the user login form (`captcha.captcha_point.user_login_form.status = FALSE`).
  - Disable Antibot (`antibot.settings.form_ids = NULL`).
  - Force-enable CSS/JS preprocessing (aggregation).
  - Force-enable AdvAgg.
  - This ensures Behat always runs against a production-like asset pipeline and without bot/spam protections interfering, regardless of which mode is active.

## settings.local.devmode.php — development mode

Tuned for active local development, with caching and debugging maximized for visibility:

- Loads `sites/development.services.yml` via `container_yamls`, enabling Drupal's development service overrides.
- Maxes out error visibility: `system.logging.error_level = 'verbose'`, `error_reporting(E_ALL)`, `display_errors`/`display_startup_errors` on.
- **Disables CSS/JS aggregation** (`system.performance.css/js.preprocess = FALSE`).
- Disables the render cache bin and the dynamic_page_cache bin (both set to `cache.backend.null`). Disabling the discovery_migration cache bin and the page cache bin are present in the file but commented out (left as opt-in).
- Explicitly disables AdvAgg (`advagg.settings.enabled = FALSE`) — the opposite of perfmode, which leaves AdvAgg at its configured default.

## settings.local.perfmode.php — performance mode

A leaner override set meant to simulate production-like performance locally:

- Does not load `development.services.yml` and does not touch error reporting/display settings (uses Drupal's normal/production-like behavior).
- **Enables CSS/JS aggregation** (`system.performance.css/js.preprocess = TRUE`) — the opposite of devmode.
- Does not null out the render or dynamic_page_cache bins — caching stays at whatever the site config defines.
- Does not explicitly disable AdvAgg (so it stays at its configured value, unlike devmode which force-disables it).
- Otherwise shares the same drush_endpoint, environment indicator, stage_file_proxy, Solr, SMTP, file_private_path, Shield/TFA/restrict_ip/Fastly, `rebuild_access`/`skip_permissions_hardening`, `config_exclude_modules`, `settings.project.php` include, and Behat-flag-file block described above.
