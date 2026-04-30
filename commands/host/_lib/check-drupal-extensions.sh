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

  for mod in health_check_url; do
    if grep -qE "^\s+${mod}:" "$EXT_FILE"; then
      pass "Required module '$mod' is enabled"
    else
      fail "Required module '$mod' is NOT enabled"
    fi
  done

  if grep -qE "^\s+anner_sso:" "$EXT_FILE"; then
    pass "Required module 'anner_sso' is enabled"
  else
    warn "Required module 'anner_sso' is NOT enabled"
  fi

  CONFIG_SYNC_DIR=$(dirname "$EXT_FILE")
  OIDC_BLOCK=$(grep -rl "plugin: openid_connect_login" "$CONFIG_SYNC_DIR"/block.block.*.yml 2>/dev/null | head -1)
  if [[ -n "$OIDC_BLOCK" ]]; then
    pass "OpenID Connect login block is configured"
    if grep -q "pages: /anner-sso" "$OIDC_BLOCK"; then
      pass "OpenID Connect block is restricted to /anner-sso"
    else
      fail "OpenID Connect block does not have 'pages: /anner-sso'"
    fi
  else
    warn "No OpenID block found!"
  fi
fi
