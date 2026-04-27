#ddev-generated
#annertech-ddev
upsun_activity_in_progress() {
    local project_id="$1"
    local project_name="$2"
    local environment_id="$3"
    echo_green "${project_name} / ${environment_id} Selected"
    echo_yellow "Fetching running activity log..."
    ddev exec upsun act:log --state=in_progress --project="${project_id}" -e "${environment_id}"
}
