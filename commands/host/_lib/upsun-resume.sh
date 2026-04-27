#ddev-generated
#annertech-ddev
upsun_resume() {
    local project_id="$1"
    local project_name="$2"
    local environment_id="$3"
    echo_green "${project_name} / ${environment_id} Selected"
    echo_yellow "Starting resume process..."
    ddev exec upsun environment:resume --project="${project_id}" -e "${environment_id}"
}
