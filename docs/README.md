# annertech-ddev Documentation

Internal documentation for the `annertech-ddev` DDEV add-on, generated from the actual source files in this repo.

- [host-commands.md](host-commands.md) — every host-side command in `commands/host/` (run on the developer's machine via `ddev <command>`).
- [web-commands.md](web-commands.md) — every command in `commands/web/` (run inside the DDEV web container).
- [git-hooks.md](git-hooks.md) — the `commit-msg`, `pre-commit`, and `pre-push` git hooks in `scripts/git-hooks/` and what they enforce.
- [ddev-providers.md](ddev-providers.md) — the sample DDEV upstream provider configs in `scripts/provider-samples/` and how the active provider is selected.
- [lifecycle-hooks.md](lifecycle-hooks.md) — the DDEV lifecycle hooks (`post-start`, `post-import-db`, `post-pull`) defined in `config.annertech.yaml`.
- [drupal-settings.md](drupal-settings.md) — the `settings.local.devmode.php` and `settings.local.perfmode.php` Drupal settings overrides and how dev/perf mode differ.
