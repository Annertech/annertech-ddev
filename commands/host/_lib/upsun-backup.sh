#ddev-generated
#annertech-ddev
upsun_backup() {
    local project_id="$1"
    local project_name="$2"
    local environment_id="$3"
    echo_green "${project_name} / ${environment_id} Selected"
    echo_yellow "Creating backup..."
    ddev exec upsun backup:create --project="${project_id}" -e "${environment_id}"
}
