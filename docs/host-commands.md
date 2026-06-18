# Host Commands

These commands run on the developer's host machine (via `ddev <command>`), from `commands/host/`. They are exposed as DDEV host-side commands.

`commands/host/_lib/` contains internal helper scripts (e.g. `check-*.sh`, `upsun-*.sh`, `tw-*.sh`, `mask_ips.py`) that are sourced/invoked by the commands below — they are not standalone commands and are not documented individually here.

`commands/host/known_ips.json` is a data file (not a command): it maps known crawler/service names (Googlebot, Bingbot, etc.) to published IP/CIDR ranges, used by `loghound` to tag known bot traffic.

## Commands

- `ai-prompts` — Interactive fzf menu ("AI Prompts Operations Centre") offering BackstopJS-init prompt generation (extracts test/reference domains, feeds a templated prompt to a chosen AI agent) and access-log forensics (GDPR-safe IP masking via `mask_ips.py` before sending log excerpts to an LLM). Aliases: `ai`.
- `annertech-tip-of-the-day` — Installs (or removes with `-u`/`--uninstall`) a custom DDEV "tip of the day" remote-config entry in `~/.ddev/global_config.yaml` pointing at Annertech's tips repo, clearing DDEV state so the change takes effect. Note: header `## Usage` says `install-tips`, which is stale/inconsistent with the actual filename.
- `backstop-public` — Copies the BackstopJS HTML report into the web root so it's reachable over HTTP, prints the URL, and deletes the copy automatically after 5 minutes.
- `branch` — Creates a git branch named `YYYYMM_T-<taskid>__<description>` from a Teamwork card URL/ID and description. Blocks branching from forbidden base branches (dev/develop/development/stage/staging) and warns to pull first when branching from main/master. Aliases: `branch`, `br`.
- `cex` — Wrapper for `ddev drush cex -y` (export Drupal config).
- `check-ip` — Looks up an IP's abuse/reputation report via the AbuseIPDB API (requires `ABUSEIPDB_API_KEY`).
- `cim` — Wrapper for `ddev drush cim -y` (import Drupal config).
- `cloudflare` — Shares the local DDEV site publicly via a Cloudflare Tunnel pointed at the local HTTPS port.
- `cr` — Wrapper for `ddev drush cr` (rebuild Drupal caches).
- `devmode` — Toggles Drupal between development settings (`settings.local.devmode.php`) and performance/production settings (`settings.local.perfmode.php`) by copying the relevant file to `settings.local.php`, updating the `development_settings` key-value store, and rebuilding cache. Usage: `devmode [off|on]`.
- `drupal-operations-center` — Interactive fzf menu offering to download the js-cookie library into `web/libraries/js-cookie`, or to clear the `update_fetch_task` key-value store to fix the Drupal updates report page. Aliases: `drupal-operations`.
- `drupal-updater` — Automates Drupal core/contrib updates: snapshots the DB, updates contrib modules individually via Composer (with optional per-module git commits), and handles core/core-recommended updates together. Supports flags for dry-run, security-only updates, omitting snapshots, running DB updates, and interactive per-item confirmation.
- `env-setup` — Interactive fzf menu to set the Teamwork board (`TEAMWORK_PROJECT_ID`) or toggle the project's LIVE/BUILD mode, persisting both to `.ddev/.env.anner` via `ddev dotenv set`.
- `githooks` — Copies all files from `.ddev/scripts/git-hooks/` into `.git/hooks` to install the project's git hooks.
- `glab-mr-link` — Opens the current branch's GitLab merge request in a browser (`-o`) or copies its URL to the clipboard. Aliases: `mr-link`.
- `holdmybeer` — One-shot start-of-work automation: stashes local changes, pulls the default branch, fetches the Teamwork card title, creates a branch, starts DDEV, pulls the remote DB, and exports config. Requires `TEAMWORK_API_KEY`/`TEAMWORK_DOMAIN`. Aliases: `holdmybeer`, `hmb`.
- `lints` — Checks for installed lint tooling and prints the command to run it; currently only checks for `vendor/bin/twig-cs-fixer` (Twig linting), despite the more generic description.
- `loghound` — Stdlib-only Python tool for offline forensic analysis of Apache access logs: status-code breakdowns, 5xx/404 deep dives, IP subnet clustering, request-flood detection, crawler detection (using `known_ips.json`), traffic spike detection, and a severity-scored list of CIDR ranges worth blocking. Supports `--since/--until`, `--focus`, `--ip`, and `--json` flags; auto-discovers `logs/*access.log*` if no file is given.
- `login` — Opens a `drush uli` one-time-login link in a browser (or prints the URL if `ANNERTECH_LOCAL_DEV` is set).
- `mr` — Pushes the current branch and creates a draft GitLab MR via `glab mr create`, prefilling the title from the branch's `T-<id>` and description suffix.
- `open-board` — Opens the Teamwork board for the project, building the URL from `TEAMWORK_PROJECT_ID`/`TEAMWORK_DOMAIN` in `.ddev/.env.anner`. Aliases: `tw-board`.
- `open-issue` — Opens (and copies to clipboard) the Teamwork task URL for the `T-<id>` in the current branch name, falling back to the previous branch if needed. Aliases: `tw-open`.
- `package-checker` — Scans every project in a GitLab group for usage (and version) of a given Composer package by reading each project's `composer-manifest.yaml`, optionally flagging insecure versions. Aliases: `wtfiow`.
- `protect` — Enables/disables/resets HTTP basic-auth protection on a nixOS-hosted dev project via nginx config and htpasswd; no-ops unless `ANNERTECH_LOCAL_DEV` is set.
- `remote-db` — Pulls the latest database (skipping files) from the configured upstream provider (`DDEV_UPSTREAM_PROVIDER` in `.ddev/.env.anner`) via `ddev pull <provider> --skip-files -y`.
- `remote-files` — Pulls the latest files (skipping the DB) from the upstream provider via `ddev pull <provider> --skip-db -y`.
- `sanity-check` — Runs a suite of Drupal/Composer/DDEV/Upsun health checks (version constraints, performance settings, extensions, safe-uninstall, composer audit, Solr, Upsun project config, APCu, CDN, botbuster) by sourcing scripts from `commands/host/_lib/`. Supports `-s` (silent), `-b`/`--best-practices`, `-o`/`--offline`; exits 2 on critical errors (used to block pushes), 1 on regular errors.
- `teamwork-operations` — Interactive fzf "Teamwork Operations Centre" dispatching to `open-issue`, `tw-comment`, `tw-timelog`, `tw-description`, `tw-new`, `tw-batch-card-maker`, plus branch creation/switching helpers. Aliases: `tw`.
- `tests` — Detects which test suites (Backstop, Behat, Bruno, Cypress, PHPUnit) are configured in the project and prints the commands to run each.
- `timew` — Tags the current Timewarrior interval with the branch's `T-<id>` task and the project directory name.
- `timewarrior-timelog` — Pulls the Timewarrior summary for the current task and pipes it into `tw-timelog` to log time to Teamwork. Aliases: `twl`.
- `travel-mode` — Finds and deletes (after confirmation) all unsanitized DB dump files under `.ddev/.downloads/` across every project in a chosen folder, then suggests a `ddev delete --all` cleanup.
- `tw-batch-card-maker` — Interactively creates the same new Teamwork card across multiple selected "support" Teamwork projects, posting to each project's Cards tasklist.
- `tw-comment` — Posts a comment to a Teamwork task, resolving the task ID from `-t`, the branch name, the previous branch, or an interactive prompt. Aliases: `comment`.
- `tw-description` — Appends a structured "Deployment notes" section (date, MR link, branch, checklist) to a Teamwork task's description, optionally including the Upsun Dev environment URL.
- `tw-new` — Interactively creates a new Teamwork task (project, tasklist, title, markdown description) and tags it via `tw-tag-issue`.
- `tw-tag-issue` — Adds tags to a Teamwork task by fetching existing tags and presenting all available tags via fzf multi-select. Aliases: `tw-tag`.
- `tw-timelog` — Logs time to a Teamwork task, parsing flexible time formats (`1h15m`, `75m`, decimal hours, `H:MM:SS`) and rounding up to the nearest 15 minutes. Aliases: `timelog`, `timeslip`.
- `upsun-command-center-bash` — Interactive (or argument-driven) "Upsun Command Centre" menu: Drush ULI, Drupal config status, activities, running-activity view, SSH, resume environment, disk allocation helper, log checkers (plain and goaccess), access-log download, environment backup, Fastly API token, dashboard — each delegating to a corresponding `_lib/upsun-*.sh` helper. Aliases: `uptools`, `uptool`, `platform-ulitool`, `ulitool`, `platform-resume`, `ucc` (the header lists `ucc` twice — likely a stale duplicate).
- `upsun-dashboard` — Opens the Upsun project dashboard in the browser for the project ID resolved from `PLATFORM_PROJECT` or `.ddev/config.yaml`.
