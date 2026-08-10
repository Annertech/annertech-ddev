Make sure ddev is running the latest version of NPM and renovate!

ddev ssh
npm install --global renovate
renovate -v # should be the same as gitlab!

## Testing
LOG_LEVEL=debug GITHUB_COM_TOKEN=ghp_ npx renovate --platform=local --dry-run=full

## Validating
npx --package=renovate renovate-config-validator

