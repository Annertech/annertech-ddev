#ddev-generated
#annertech-ddev
upsun_disk_helper() {
    local project_id="$1"
    local project_name="$2"
    echo_green "${project_name} Selected"

    echo ""
    echo "Currently used and assigned disk space:"
    ddev exec upsun disk -1 --columns Service,Used,Limit --project="${project_id}"

    local web db solr total_assigned total_available
    web=$(ddev exec upsun disk -1 --columns Limit -s app --bytes --no-header --format=plain --project="${project_id}" 2>/dev/null | tr -d '[:space:]')
    db=$(ddev exec upsun disk -1 --columns Limit -s mysqldb --bytes --no-header --format=plain --project="${project_id}" 2>/dev/null | tr -d '[:space:]')
    solr=$(ddev exec upsun disk -1 --columns Limit -s solrsearch --bytes --no-header --format=plain --project="${project_id}" 2>/dev/null | tr -d '[:space:]')

    web=${web:-0}
    db=${db:-0}
    solr=${solr:-0}
    total_assigned=$((web + db + solr))

    total_available=$(ddev exec upsun project:info subscription.storage --project="${project_id}" 2>/dev/null | tr -d '[:space:]')
    total_available=${total_available:-0}

    echo ""
    echo "Total assigned (app+mysqldb+solrsearch):"
    numfmt --to iec --format "%3.2f" "$total_assigned"

    echo ""
    echo "Total storage available in project:"
    numfmt --from-unit=1048576 --to iec --format="%3.2f" "$total_available"

    echo_yellow ""
    echo_yellow "WARNING: command uses hardcoded values for service totals. Verify numbers with table above!"
    echo ""
}
