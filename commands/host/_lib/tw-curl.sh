#ddev-generated
#annertech-ddev
# Wrapper that keeps the Teamwork API key out of process argv (not visible via `ps`).
tw_curl() {
    curl --config <(printf 'user = "%s:v"\n' "$TW_API_KEY") "$@"
}
