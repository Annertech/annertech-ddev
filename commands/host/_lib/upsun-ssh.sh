#ddev-generated
#annertech-ddev
upsun_ssh() {
    local project_id="$1"
    local project_name="$2"
    echo_green "${project_name} Selected"
    echo_yellow "Connecting via SSH..."
    ddev exec upsun ssh --project="${project_id}"
}
