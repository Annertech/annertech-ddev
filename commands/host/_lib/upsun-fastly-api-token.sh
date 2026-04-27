#ddev-generated
#annertech-ddev
upsun_fastly_api_token() {
    local project_id="$1"
    local project_name="$2"
    local environment_id="$3"
    echo_green "${project_name} / ${environment_id} Selected"
    echo_yellow "Fetching Fastly credentials..."
    ddev exec upsun ssh --project="${project_id}" -e "${environment_id}" -- "env | grep -i fastly"
}
