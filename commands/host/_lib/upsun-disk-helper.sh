#ddev-generated
#annertech-ddev

# GNU numfmt is not on macOS. Print an IEC size (1024) with two decimals.
format_iec() {
    local value="$1"
    local from_unit="${2:-1}"
    python3 - "$value" "$from_unit" << 'PY'
import sys
n = int(sys.argv[1]) * int(sys.argv[2])
units = ["", "K", "M", "G", "T", "P"]
i = 0
v = float(n)
while abs(v) >= 1024 and i < len(units) - 1:
    v /= 1024.0
    i += 1
if i == 0:
    print(str(int(v)))
else:
    print(f"{v:.2f}{units[i]}")
PY
}

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
    format_iec "$total_assigned"

    echo ""
    echo "Total storage available in project:"
    format_iec "$total_available" 1048576

    echo_yellow ""
    echo_yellow "WARNING: command uses hardcoded values for service totals. Verify numbers with table above!"
    echo ""
}
