# Dependency updates with Renovate

Opinionated renovate-bot config for automatic dependency updates.
Anything that needs human judgement is deliberately left out.

## What Renovate does automatically

| Update | Behaviour |
| --- | --- |
| Drupal core **patch** (10.4.1 → 10.4.2) | Own PR, group `core-patch` |
| Contrib **minor + patch** | One combined PR, group `contrib-minor-patch`, after a 3-day grace period for every release |
| **Security** fixes (OSV alerts) | Own PR, highest priority, no soak delay |

## What is left to a human

- **All major updates**, for every package.
- **Drupal core minors** (10.3 → 10.4) — these need a real upgrade check.
- **Core security advisories** that require a minor or major bump. Renovate will
  not open a PR for these; watch the Drupal security advisories directly.
- Non-Drupal (sub)dependencies

## Key principles

### Lock file first
`rangeStrategy: update-lockfile` means Renovate edits
`composer.lock` and leaves the constraints in `composer.json` alone.

### Build artifacts stay consistent.
`vendor/` and the built `web/` root are committed, so every branch runs `composer
install` once (`postUpgradeTasks`, `executionMode: branch`) and commits the result
alongside the lock file.

@todo: Consider marking these paths as`linguist-generated` so PR diffs stay reviewable.

### Security
Vulnerability PRs use the *lowest* version that closes the advisory, skip the 3-day
soak, and carry `prPriority: 100`. The rule sits last in `packageRules` on purpose,
as later rules win, so nothing downstream can dilute its priority.

### Throughput is capped
Up to 3 open PRs at a time, created only between 00:00 and 06:00 UTC. The cap is 3
rather than 1 so a routine PR left open cannot block a security PR from being created.

## Operational requirements

- **Self-hosted Renovate only.** `postUpgradeTasks` requires `composer install`
  to be allow-listed in the runner's `allowedCommands`. On the Mend-hosted
  GitHub App the hook is silently skipped and PRs land with a stale `vendor/`.
- **The runner must fire inside the schedule window.** If cron runs Renovate
  outside 00:00–06:00 UTC, it wakes, sees it is out of schedule, and does
  nothing.
- **Only the `composer` manager is enabled.** npm dependencies are _currently_ not tracked.

## Known gap

`drupal/core-dev` is not listed alongside the three core metapackages
(`core-recommended`, `core-composer-scaffold`, `core-project-message`). If the
project requires it, it currently falls into the contrib group and can be bumped
to a minor while core stays pinned. Add it to all three core rules if present.
