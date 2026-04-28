#ddev-generated
#annertech-ddev
upsun_dashboard() {
    local project_id="$1"
    local url="https://console.upsun.com/projects/${project_id}"
    case $OSTYPE in
        linux-gnu) xdg-open "$url" ;;
        darwin*) open "$url" ;;
        win*|msys*) start "$url" ;;
    esac
    echo "$url"
}
