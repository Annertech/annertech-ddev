#ddev-generated
#annertech-ddev
if [[ -n "$EXT_FILE" ]]; then
  CDN_NAME=""
  for cdn_mod in fastly cloudflare; do
    if strip_yaml "$EXT_FILE" | grep -qE "^\s+${cdn_mod}:"; then
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
  ROUTES_CONTENT=$(strip_yaml "$ROUTES_FILE")
  if echo "$ROUTES_CONTENT" | grep -qE "cache:"; then
    if $BEHIND_CDN; then
      if echo "$ROUTES_CONTENT" | grep -qE "enabled:\s*false"; then
        pass "Upsun route cache is disabled (correct — project is behind a CDN)"
      else
        fail "Upsun route cache must be DISABLED when behind a CDN (fastly/cloudflare detected)"
      fi
    else
      if echo "$ROUTES_CONTENT" | grep -qE "enabled:\s*true"; then
        pass "Upsun route cache is enabled"
      elif echo "$ROUTES_CONTENT" | grep -qE "enabled:\s*false"; then
        fail "Upsun route cache is DISABLED but no CDN module detected — should be enabled"
      else
        pass "Upsun route cache key found in routes.yaml"
      fi
    fi
  else
    warn "Upsun: no 'cache:' key found in .platform/routes.yaml — route caching may not be configured"
  fi
fi

if [[ ( "$DDEV_UPSTREAM_PROVIDER" == "platform" || "$DDEV_UPSTREAM_PROVIDER" == "upsun" ) && -n "$EXT_FILE" ]]; then
  PAGE_CACHE_ENABLED=false
  strip_yaml "$EXT_FILE" | grep -qE "^\s+page_cache:" && PAGE_CACHE_ENABLED=true

  if $BEHIND_CDN; then
    if $PAGE_CACHE_ENABLED; then
      fail "page_cache module is ENABLED — $CDN_NAME already provides invalidatable caching; disable page_cache"
    else
      pass "Drupal page_cache module is disabled ($CDN_NAME handles anonymous caches)"
    fi
  else
    # Decision reversed in https://github.com/Annertech/annertech-ddev/issues/132:
    # without a CDN we can invalidate, the Upsun cache can't be tag-invalidated,
    # so page_cache is now a useful extra layer rather than something to avoid.
    if $PAGE_CACHE_ENABLED; then
      pass "Drupal page_cache module is enabled — useful extra layer since there is no CDN to invalidate (see issue #132)"
    else
      warn "Drupal page_cache module is disabled — consider enabling it: without a CDN, Upsun's cache can't be tag-invalidated (decision changed, see issue #132)"
    fi
  fi
fi
