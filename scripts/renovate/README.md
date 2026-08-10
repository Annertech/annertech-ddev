# Dependency updates with Renovate

Opinionated Renovate config template for Drupal projects. Copy it to the project
root as `renovate.json`. Anything needing human judgement is deliberately left out.

## What Renovate does

| Update | Behaviour |
| --- | --- |
| Drupal core **patch** (11.4.4 → 11.4.5) | Own PR, group `patch-core` |
| Contrib **minor + patch** | One combined PR, group `minor-patch-contrib` |

MRs use the `deps/` branch prefix, get the `dependencies` label, are assigned to `bserem`,
and are never automerged.

## What is left to a human

- **All major updates**, for every package (`major.enabled: false`).
- **Drupal core minors** (11.3 → 11.4) — these need a real upgrade check.
- **`php` itself** — the package is disabled.
- **Security advisories.** There is no `vulnerabilityAlerts` block and no
  vulnerability handling at all. Watch the Drupal security advisories directly.
- Anything outside composer — only the `composer` manager is enabled.

## Key principles

**Lock file first.** `rangeStrategy: update-lockfile` edits `composer.lock` and
leaves the constraints in `composer.json` alone.

**Build artifacts stay consistent.** `vendor/` and the built `web/` root are
committed, so each branch runs `composer install` once (`postUpgradeTasks`,
`executionMode: branch`) and commits the result alongside the lock file.

**Rule order matters.** Later `packageRules` win. The broad contrib rule comes
first, the narrow core rules last, so core cannot be pulled into the contrib
group. Do not append a broad rule to the end — it overwrites `groupName` on
everything above it and collapses both groups into one PR.

**Throughput is capped.** Max 3 open PRs, max 2 created per hour.

## Operational requirements

- **Self-hosted Renovate only.** `postUpgradeTasks` needs `composer install`
  allow-listed in the runner's `allowedCommands`
  (`RENOVATE_ALLOWED_COMMANDS='["^composer install"]'` or `config.js`) — an
  admin-side option that **cannot** be set here. On the Mend-hosted app the hook
  is silently skipped and PRs land with a stale `vendor/`.
- **The runner needs PHP and composer.** With `update-lockfile` the only change is
  a regenerated `composer.lock`; if composer cannot run you get an MR with a
  description and no commits. Use the full `renovate/renovate` image or
  `RENOVATE_BINARY_SOURCE=install`, and check the MR body for an
  "Artifact update problem" block.
- **Validate before shipping** changes:
  `npx --package renovate renovate-config-validator renovate.json`
