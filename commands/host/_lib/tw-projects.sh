#ddev-generated
#annertech-ddev

. "$(dirname "${BASH_SOURCE[0]}")/tw-curl.sh"

# Fetches active Teamwork projects and prompts the user to select one via fzf.
# Sets PROJECT_ID and PROJECT_NAME on success; exits on error or no selection.
# Requires: TEAMWORK_API_KEY, jq, fzf, echo_red/echo_yellow helpers.
tw_select_project() {
    TW_API_KEY="${TEAMWORK_API_KEY:-}"
    if [[ -z "$TW_API_KEY" ]]; then
        echo_red "Error: TEAMWORK_API_KEY environment variable not set"
        exit 1
    fi

    MISSING_DEPS=()
    command -v jq  &> /dev/null || MISSING_DEPS+=("jq")
    command -v fzf &> /dev/null || MISSING_DEPS+=("fzf")
    if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
        echo_red "Error: missing dependencies: ${MISSING_DEPS[*]}"
        exit 1
    fi

    echo_yellow "Fetching active Teamwork projects..."
    local response
    response=$(tw_curl -s "https://${TEAMWORK_DOMAIN}/projects.json?status=active")

    if [[ -z "$response" ]]; then
        echo_red "Error: Failed to fetch projects from API"
        exit 1
    fi

    local status
    status=$(echo "$response" | jq -r '.STATUS')
    if [[ "$status" != "OK" ]]; then
        echo_red "Error fetching projects: $(echo "$response" | jq -r '.MESSAGE // "Unknown error"')"
        exit 1
    fi

    local selection
    selection=$(echo "$response" | \
        jq -r '.projects[] | "\(.id)\t\(.name) (\(.id))"' | \
        fzf --reverse --height=50% --header="Select Teamwork Project" --delimiter=$'\t' --with-nth=2 -1)

    if [[ -z "$selection" ]]; then
        echo_red "No project selected. Aborting."
        exit 0
    fi

    PROJECT_ID=$(echo "$selection" | cut -f1)
    PROJECT_NAME=$(echo "$selection" | cut -f2-)
}
