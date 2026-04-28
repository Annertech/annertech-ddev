#ddev-generated
#annertech-ddev
set_teamwork_board() {
    TW_API_KEY="${TEAMWORK_API_KEY:-}"
    if [[ -z "$TW_API_KEY" ]]; then
        echo_red "Error: TEAMWORK_API_KEY environment variable not set"
        echo_yellow "See README.md for setup instructions."
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
    PROJECTS_RESPONSE=$(curl -s \
        -u "${TW_API_KEY}:v" \
        "https://projects.annertech.com/projects.json?status=active")

    if [[ -z "$PROJECTS_RESPONSE" ]]; then
        echo_red "Error: Failed to fetch projects from API"
        exit 1
    fi

    STATUS=$(echo "$PROJECTS_RESPONSE" | jq -r '.STATUS')
    if [[ "$STATUS" != "OK" ]]; then
        echo_red "Error fetching projects: $(echo "$PROJECTS_RESPONSE" | jq -r '.MESSAGE // "Unknown error"')"
        exit 1
    fi

    PROJECT_SELECTION=$(echo "$PROJECTS_RESPONSE" | \
        jq -r '.projects[] | "\(.id)\t\(.name) (\(.id))"' | \
        fzf --reverse --height=50% --header="Select Teamwork Project" --delimiter=$'\t' --with-nth=2 -1)

    if [[ -z "$PROJECT_SELECTION" ]]; then
        echo_red "No project selected. Aborting."
        exit 0
    fi

    PROJECT_ID=$(echo "$PROJECT_SELECTION" | cut -f1)
    PROJECT_NAME=$(echo "$PROJECT_SELECTION" | cut -f2-)

    ddev dotenv set .ddev/.env.anner --teamwork-project-id="$PROJECT_ID"
    echo_green "✓ Saved TEAMWORK_PROJECT_ID=$PROJECT_ID ($PROJECT_NAME) to .ddev/.env.anner"
}
