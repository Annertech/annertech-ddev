#ddev-generated
#annertech-ddev
upsun_log_checker() {
    local project_id="$1"
    local project_name="$2"
    local environment_id="$3"
    echo_green "${project_name} / ${environment_id} Selected"
    echo_yellow "Analyzing access logs (top 10 requests)..."
    ddev exec upsun ssh --project="${project_id}" -e "${environment_id}" -- \
        "tail -n 5000 /var/log/access.log | cut -d' ' -f 12- | sort | uniq -c | sort -nr | head -n 10"
}
