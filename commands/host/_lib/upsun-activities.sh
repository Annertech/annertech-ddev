#ddev-generated
#annertech-ddev
upsun_activities() {
    local project_id="$1"
    local project_name="$2"
    echo_green "${project_name} Selected"
    echo_yellow "Fetching activities..."
    ddev exec upsun act --project="${project_id}"
}
