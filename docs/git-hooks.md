# Git Hooks

Hooks live in `scripts/git-hooks/` and are installed into `.git/hooks` by the `githooks` host command (also run automatically by the `post-start` lifecycle hook). They can always be bypassed at the git level with `--no-verify`.

## commit-msg

Enforces that every commit message references a Teamwork ticket.

- Defines `COMMIT_PATTERN="^T-[0-9]*"` and `BRANCH_PATTERN="[0-9]{6}_(T-[0-9]{8})"` (the `YYYYMM_T-XXXXXXXX` branch naming convention).
- Merge commits (detected via `MERGE_HEAD`) are always allowed through.
- If the commit message already starts with `T-<digits>`, it passes unchanged.
- Otherwise, it checks the current branch name against the `YYYYMM_T-XXXXXXXX` pattern; if it matches, the hook **auto-prepends** the extracted ticket ID (`T-XXXXXXXX`) to the commit message and allows the commit.
- If neither the message nor the branch name carries a valid ticket ID, it prints an error and **exits 1, blocking the commit**.

## pre-commit

A multi-check guard over staged files. Any failing check blocks the commit (exit 1) unless noted:

1. Rejects staged `system.performance.yml` containing `preprocess: false` (CSS/JS aggregation disabled).
2. Rejects staged `system.performance.yml` (excluding paths under `tests/`) containing `max_age: 0` (browser caching disabled).
3. Rejects staged `system.performance.yml` (excluding `tests/`) containing `gzip: true` (AdvAgg GZIP enabled).
4. Rejects staged `core.extension.yml` (excluding paths under `tests/`) enabling forbidden modules: `devel: 0`, `devel_php: 0`, `drush_endpoint: 0` (Drupal's YAML convention where `: 0` means "enabled"). If `.ddev/.env.anner` exists and `DDEV_UPSTREAM_PROVIDER` is `platform` or `upsun`, it additionally forbids enabling ` page_cache: 0` (the leading space is intentional, to avoid matching `dynamic_page_cache`).
5. Checks for a CDN module (Fastly or Cloudflare) enabled in `config/sync/core.extension.yml` while `.platform/routes.yaml` exists; if a CDN is enabled but the routes file doesn't disable Upsun's route cache (`enabled: false` under cache), it blocks with a warning that route cache must be disabled behind a CDN.
6. Rejects commits with staged files under a `devel_php/` folder.
7. If `.ddev/addon-metadata/annertech-ddev/manifest.yaml` is staged with no/empty `version:` field, blocks — this implies a dev/unpublished version of the addon is in use.
8. If `.ddev/addon-metadata/solr/manifest.yaml` is staged, validates that `repository` is exactly `ddev/ddev-drupal-solr` and `version` is exactly `v1.2.3`; otherwise blocks with instructions to install the correct pinned version.

Exits 0 if no check trips.

## pre-push

A layered gate that runs before pushing:

1. Skips all checks if `.ddev/.env.anner`'s `LIVE` is `"0"` (non-live project). If `LIVE` is unset, it warns but treats the project as live (does not skip).
2. Skips all checks when pushing tags (detected via stdin refs containing `refs/tags/` or a `--tags` argument to the parent process).
3. Runs `ddev composer validate --no-check-all --no-check-publish`; a non-zero exit blocks the push.
4. Runs `ddev sanity-check -s`, scoping the diff to the pushed commits via `GIT_PUSH_RANGE_BASE`/`GIT_PUSH_RANGE_TIP` (derived from the pre-push ref line or a merge-base against `origin/HEAD`/`main`/`master`). If the output contains `CRITICAL:`, the push is unconditionally blocked. If sanity-check exits non-zero without a `CRITICAL:` marker: on branch `dev` it just warns and continues; on any other branch it interactively prompts to continue (default No), blocking unless the user confirms.
5. If the project is live, `tests/backstop/backstop.json` exists, and the branch isn't `dev`, it warns (non-blocking) when no Backstop snapshot folder dated today exists under `tests/backstop/backstop_data/bitmaps_test`.
6. If pushing directly to `main` or `master`, requires the user to type the literal word `yes` to confirm (anything else aborts). If confirmed and the upstream provider is `platform` or `upsun`, it optionally offers (default Yes) to run an Upsun environment backup; if that backup fails, it prompts again (default No) whether to continue, blocking on "no".
