# Dependency updates with Renovate

Opinionated Renovate config template for Drupal projects. `ddev add-on get` copies
`renovate.json` to the project root, as long as the file there is missing or still
carries `#ddev-generated`. Once a project edits it and drops the marker, the add-on
leaves it alone. Anything needing human judgement is deliberately left out.

Two templates live here:

| File | Use                                                                                 |
| --- |-------------------------------------------------------------------------------------|
| `renovate.json` | The default. Rebuilds `vendor/` and the built `web/` root in the branch.            |
| `renovate.lockfile-only.json` | WIP! For projects that do not commit build artifacts. Touches only `composer.lock`. |

## What Renovate does

| Update | Behaviour |
| --- | --- |
| Composer **minor + patch**, core and contrib | One combined MR, group `drupal-deps` |

MRs use the `deps/` branch prefix, get the `dependencies` label, and are never
automerged. `ddev renovate-dashboard` (alias `ddev renovate`) opens the project's
dependency dashboard issue, once `RENOVATE_DASHBOARD_ID` is set via `ddev env-setup`.

## What is left to a human

- **All major updates**, for every package (`major.enabled: false`).
- **`php` itself** — the package is disabled.
- **Security advisories.** There is no separate `vulnerabilityAlerts` block and 
  no dedicated vulnerability handling. Security Advisories updates come in the 
  same MR as everything else.
- Anything outside composer — only the `composer` manager is enabled.

There is no `minimumReleaseAge` grace period either. A delay would hold back
security releases too, and until security updates are handled separately, fresh
releases are better than delayed ones.

## Key principles

**Lock file first.** `rangeStrategy: update-lockfile` edits `composer.lock` and
leaves the constraints in `composer.json` alone.

**Build artifacts stay consistent.** `vendor/` and the built `web/` root are
committed, so each branch runs `composer install` once (`postUpgradeTasks`,
`executionMode: branch`) and commits the result alongside the lock file. Those same
paths are in `ignorePaths`, so Renovate does not scan the vendored copies for
updates, it only commits what composer wrote.

**Noise is downgraded, not hidden.** `logLevelRemap` drops "requirements cannot be
resolved" and "Detected empty commit" to `info`. They are expected on Drupal
projects and should not read as failures.

**Throughput is capped.** Max 3 open PRs, max 2 created per hour.

## Operational requirements

- **Self-hosted Renovate only** for the default template. `postUpgradeTasks` needs
  `composer install` allow-listed in the runner's `allowedCommands`
  (`RENOVATE_ALLOWED_COMMANDS='["^composer install"]'` or `config.js`) — an
  admin-side option that **cannot** be set here. On the Mend-hosted app the hook
  is silently skipped and PRs land with a stale `vendor/`. Use the lockfile-only
  template there.
- **The runner needs PHP and composer.** With `update-lockfile` the only change is
  a regenerated `composer.lock`; if composer cannot run you get an MR with a
  description and no commits. Use the full `renovate/renovate` image or
  `RENOVATE_BINARY_SOURCE=install`, and check the MR body for an
  "Artifact update problem" block.
- **Validate before shipping** changes, see `TESTING.md` for the dry run too:
  `npx --package renovate renovate-config-validator renovate.json`

<!-- #ddev-generated -->
