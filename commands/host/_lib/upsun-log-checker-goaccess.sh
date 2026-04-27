#ddev-generated
#annertech-ddev
upsun_log_checker_goaccess() {
    local project_id="$1"
    local project_name="$2"
    local environment_id="$3"
    echo_green "${project_name} / ${environment_id} Selected"
    echo_yellow "Fetching logs and loading in goaccess..."
    ddev exec upsun ssh --project="${project_id}" -e "${environment_id}" -- "cat /var/log/access.log" | \
        goaccess --log-format=COMBINED -
}
