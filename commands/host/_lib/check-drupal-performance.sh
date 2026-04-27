#ddev-generated
#annertech-ddev
PERF_FILE=$(find "$APPROOT" -path "*/config/sync/system.performance.yml" ! -path "*/.git/*" 2>/dev/null | head -1)

if [[ -z "$PERF_FILE" ]]; then
  warn "system.performance.yml not found — skipping"
else
  if grep -q "preprocess: false" "$PERF_FILE"; then
    fail "CSS/JS aggregation is DISABLED (preprocess: false)"
  else
    pass "CSS/JS aggregation is enabled"
  fi

  if grep -q "max_age: 0" "$PERF_FILE"; then
    fail "Browser caching is DISABLED (max_age: 0)"
  else
    pass "Browser caching is enabled"
  fi
fi
