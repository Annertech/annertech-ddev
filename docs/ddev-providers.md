# DDEV Upstream Providers

A DDEV "upstream provider" config is a YAML file describing how `ddev pull` fetches a database and/or files from a remote (or local) source for the project.

`scripts/provider-samples/` contains sample provider configs that can be copied into a project's `.ddev/providers/` directory and customized; they are templates, not files DDEV uses automatically.

## local.yaml (Griffith local file provider)

Pulls a database dump that has already been placed in the project root by an external tool ("Griffith"), rather than fetching anything remotely.

- Defines only `db_import_command` (`service: host`).
- Expects dump files named `griffith-DD-MM-YYYY-TIME.mysql.bz2` in the project root.
- Globs all matching files, sorts them by the day/month/year embedded in the filename to find the most recent, and runs `ddev import-db --file=$latest_dump`.

## tibus.yaml (rsync provider with SSH tunnel)

An rsync-based provider for pulling a DB dump from a host called "Tibus", run inside the web container (since rsync is guaranteed to be available there).

- `environment_variables.dburl` points at a remote path, e.g. `project.live:/path/to/db/dump/live.gz`.
- `auth_command` checks `ssh-add -l` succeeds, erroring with instructions to run `ddev auth ssh` first if not.
- `db_pull_command` (`service: web`) runs `rsync -az -e "ssh -J ${AEGIR_USERNAME}@anrt.vpn" "${dburl}" /var/www/html/.ddev/.downloads/db.sql.gz`, tunneling through an Aegir jump host.

## gitlab.yaml (GitLab CI artifact provider)

Pulls a database dump published as a GitLab CI job artifact, using the `glab` CLI.

- Defines only `db_pull_command` (`service: host`).
- Runs `glab ci artifact dev db:artifact --path=".ddev/.downloads"` to download the artifact, then `ddev import-db --file=.ddev/.downloads/db.sql.gz` to import it.
- Used via `ddev pull gitlab --skip-files` (the file header also notes `ddev remote-db` as an entry point).

## Selecting the active provider

The active provider name is stored as `DDEV_UPSTREAM_PROVIDER` in `.ddev/.env.anner` (read via `ddev dotenv`):

- `install.yaml` migrates a legacy `.env` file's `DDEV_UPSTREAM_PROVIDER` value into `.ddev/.env.anner` during install, then removes the old `.env`.
- `install.yaml` also renames a legacy value: if `.env.anner` has `DDEV_UPSTREAM_PROVIDER=platform`, it's rewritten to `upsun`.
- On addon removal, `.ddev/.env.anner` is deleted entirely.
- Commands such as `remote-db` and `remote-files` read `DDEV_UPSTREAM_PROVIDER` from `.env.anner` and pass it to `ddev pull <provider> --skip-files|--skip-db -y`.
- Several scripts (`sanity-check` and helpers under `commands/host/_lib/`, plus the `pre-commit`/`pre-push` git hooks) branch their logic specifically on whether the provider is `platform` or `upsun`.
