#ddev-generated
#annertech-ddev
if [[ -n "$EXT_FILE" ]]; then
  CDN_NAME=""
  for cdn_mod in fastly cloudflare; do
    if grep -qE "^\s+${cdn_mod}:" "$EXT_FILE"; then
      CDN_NAME="$cdn_mod"
      BEHIND_CDN=true
    fi
  done
  if $BEHIND_CDN; then
    pass "CDN detected: $CDN_NAME — Upsun route cache must be disabled"
  fi
fi

if [[ ! -f "$ROUTES_FILE" ]]; then
  warn "Upsun: .platform/routes.yaml not found — skipping cache check"
else
  if grep -qE "cache:" "$ROUTES_FILE"; then
    if $BEHIND_CDN; then
      if grep -qE "enabled:\s*false" "$ROUTES_FILE"; then
        pass "Upsun route cache is disabled (correct — project is behind a CDN)"
      else
        fail "Upsun route cache must be DISABLED when behind a CDN (fastly/cloudflare detected)"
      fi
    else
      if grep -qE "enabled:\s*true" "$ROUTES_FILE"; then
        pass "Upsun route cache is enabled"
      elif grep -qE "enabled:\s*false" "$ROUTES_FILE"; then
        fail "Upsun route cache is DISABLED but no CDN module detected — should be enabled"
      else
        pass "Upsun route cache key found in routes.yaml"
      fi
    fi
  else
    warn "Upsun: no 'cache:' key found in .platform/routes.yaml — route caching may not be configured"
  fi
fi

if [[ "$DDEV_UPSTREAM_PROVIDER" == "platform" && -n "$EXT_FILE" ]]; then
  if grep -qE "^\s+page_cache:" "$EXT_FILE"; then
    fail "page_cache module is ENABLED — Upsun handles page caching; disable it"
  else
    pass "Drupal page_cache module is disabled (Upsun handles anonymous caches)"
  fi
fi
