#ddev-generated
#annertech-ddev
FILES_VIEW="$APPROOT/config/sync/views.view.files.yml"

if [[ ! -f "$FILES_VIEW" ]]; then
  warn "config/sync/views.view.files.yml not found — skipping files view check"
else
  if grep -q "operations:" "$FILES_VIEW"; then
    pass "views.view.files.yml contains operations"
  else
    fail "views.view.files.yml is missing 'operations' — fix: cp web/core/modules/file/config/optional/views.view.files.yml config/sync/views.view.files.yml && ddev exec drush cim"
  fi
fi
