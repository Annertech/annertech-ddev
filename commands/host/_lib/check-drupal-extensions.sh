#ddev-generated
#annertech-ddev
EXT_FILE=$(find "$APPROOT" -path "*/config/sync/core.extension.yml" ! -path "*/.git/*" 2>/dev/null | head -1)

if [[ -z "$EXT_FILE" ]]; then
  warn "core.extension.yml not found — skipping"
else
  for mod in devel devel_php drush_endpoint; do
    if grep -qE "^\s+${mod}:" "$EXT_FILE"; then
      fail "Dev module '$mod' is ENABLED"
    else
      pass "Dev module '$mod' is not enabled"
    fi
  done

  for mod in anner_sso health_check_url; do
    if grep -qE "^\s+${mod}:" "$EXT_FILE"; then
      pass "Required module '$mod' is enabled"
    else
      fail "Required module '$mod' is NOT enabled"
    fi
  done
fi
