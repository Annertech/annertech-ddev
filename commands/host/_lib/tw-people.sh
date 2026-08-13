#ddev-generated
#annertech-ddev

. "$(dirname "${BASH_SOURCE[0]}")/tw-curl.sh"

# Fetches Teamwork people (optionally scoped to a project) and prompts the
# user to select one via fzf.
# Args: $1 (optional) - projectId to scope the people list to.
# Sets PERSON_ID and PERSON_NAME on success; exits on error or no selection.
# Requires: TEAMWORK_API_KEY, TEAMWORK_DOMAIN, jq, fzf, echo_red/echo_yellow helpers.
tw_select_person() {
    local project_id="${1:-}"

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

    local url="https://${TEAMWORK_DOMAIN}/projects/api/v3/people.json?pageSize=500&orderBy=namecaseinsensitive"
    if [[ -n "$project_id" ]]; then
        url="${url}&projectIds=${project_id}"
    fi

    echo_yellow "Fetching Teamwork people..."
    local response
    response=$(tw_curl -s "$url")

    if [[ -z "$response" ]]; then
        echo_red "Error: Failed to fetch people from API"
        exit 1
    fi

    local error
    error=$(echo "$response" | jq -r '.error // empty')
    if [[ -n "$error" ]]; then
        echo_red "Error fetching people: $error"
        exit 1
    fi

    local selection
    selection=$(echo "$response" | \
        jq -r '.people[] | "\(.id)\t\(.firstName) \(.lastName) (\(.email))"' | \
        fzf --reverse --height=50% --header="Select Person" --delimiter=$'\t' --with-nth=2 -1)

    if [[ -z "$selection" ]]; then
        echo_red "No person selected. Aborting."
        exit 0
    fi

    PERSON_ID=$(echo "$selection" | cut -f1)
    PERSON_NAME=$(echo "$selection" | cut -f2-)
}
