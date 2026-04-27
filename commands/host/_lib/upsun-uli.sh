#ddev-generated
#annertech-ddev
upsun_uli() {
    local project_id="$1"
    local project_name="$2"
    local environment_id="$3"
    echo_green "${project_name} / ${environment_id} Selected"
    echo_yellow "Getting URL..."
    ddev exec upsun drush uli --project="${project_id}" -e "${environment_id}"
}
