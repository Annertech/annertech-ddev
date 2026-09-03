#ddev-generated
#annertech-ddev
if [[ -n "$EXT_FILE" && -f "$ROUTES_FILE" ]]; then
  if strip_yaml "$EXT_FILE" | grep -qE "^\s+botbuster:"; then
    if strip_yaml "$ROUTES_FILE" | grep -q "botbuster_token"; then
      pass "botbuster_token cookie is present in routes.yaml cache cookies"
    else
      fail "botbuster module is enabled but 'botbuster_token' is missing from routes.yaml cache cookies"
    fi

    if $BEHIND_CDN && [[ "$CDN_NAME" == "fastly" ]]; then
      FASTLY_SETTINGS=$(find "$APPROOT" -path "*/config/sync/fastly.settings.yml" ! -path "*/.git/*" 2>/dev/null | head -1)
      if [[ -z "$FASTLY_SETTINGS" ]]; then
        warn "fastly.settings.yml not found — cannot verify botbuster_token cookie_cache_bypass"
      elif strip_yaml "$FASTLY_SETTINGS" | grep -q "cookie_cache_bypass: botbuster_token"; then
        pass "botbuster_token is set as cookie_cache_bypass in fastly.settings.yml"
      else
        fail "botbuster module is enabled but 'cookie_cache_bypass: botbuster_token' is missing from fastly.settings.yml"
      fi
    fi
  fi
fi
