#ddev-generated
#annertech-ddev
if [[ "$DDEV_UPSTREAM_PROVIDER" == "platform" || "$DDEV_UPSTREAM_PROVIDER" == "upsun" ]]; then
  SIMPLEI_FILE="$APPROOT/web/sites/default/settings.platformsh.php"

  if [[ -n "$EXT_FILE" ]]; then
    if grep -qE "^\s+simplei:" "$EXT_FILE"; then
      pass "simplei module is enabled"
    else
      warn "simplei module is NOT enabled"
    fi
  fi

  if [[ ! -f "$SIMPLEI_FILE" ]]; then
    warn "web/sites/default/settings.platformsh.php not found — skipping SimpleI checks"
  else
    if ! grep -q "simple_environment_indicator" "$SIMPLEI_FILE"; then
      warn "No SimpleI configuration found in $(basename "$SIMPLEI_FILE")"
    else
      SIMPLEI_OK=true
      grep -qE "['\"]#8B0000 LIVE['\"]" "$SIMPLEI_FILE" || SIMPLEI_OK=false
      grep -qE "['\"]#59590D STAGE['\"]" "$SIMPLEI_FILE" || SIMPLEI_OK=false
      grep -qE "['\"]#005B94 DEV['\"]" "$SIMPLEI_FILE" || SIMPLEI_OK=false
      if $SIMPLEI_OK; then
        pass "SimpleI environment indicator colors are correct"
      else
        warn "SimpleI environment indicator colors are missing or incorrect — expected #8B0000 LIVE, #59590D STAGE, #005B94 DEV"
      fi
    fi
  fi
fi
