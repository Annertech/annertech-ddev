#ddev-generated
#annertech-ddev
upsun_download_access_log() {
    local project_id="$1"
    local project_name="$2"
    local environment_id="$3"
    echo_green "${project_name} / ${environment_id} Selected"
    local date_str
    date_str=$(date +%Y%m%d)
    local filename="${date_str}_${project_name}_${environment_id}_access.log.gz"
    filename="${filename// /_}"
    filename="${filename//[\[\]()]/}"
    mkdir -p logs
    filename="logs/${filename}"
    echo_yellow "Resolving SSH endpoint..."
    local ssh_host
    ssh_host=$(ddev exec upsun ssh --project="${project_id}" -e "${environment_id}" --pipe 2>/dev/null)
    if [[ -z "$ssh_host" ]]; then
        echo_red "Failed to get SSH endpoint"
        return 1
    fi
    echo_yellow "Downloading access.log (gzipped) to ${filename}..."
    if command -v pv &>/dev/null; then
        ssh "${ssh_host}" "gzip -c /var/log/access.log" | pv > "${filename}"
    else
        ssh "${ssh_host}" "gzip -c /var/log/access.log" > "${filename}"
    fi
    echo_green "Saved to ${filename}"
    echo_yellow "Analyse with: ddev loghound ${filename}"
}
