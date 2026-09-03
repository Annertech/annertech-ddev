#ddev-generated
#annertech-ddev
PERF_FILE=$(find "$APPROOT" -path "*/config/sync/system.performance.yml" ! -path "*/.git/*" 2>/dev/null | head -1)

if [[ -z "$PERF_FILE" ]]; then
  warn "system.performance.yml not found — skipping"
else
  if strip_yaml "$PERF_FILE" | grep -q "preprocess: false"; then
    fail "CSS/JS aggregation is DISABLED (preprocess: false)"
  else
    pass "CSS/JS aggregation is enabled"
  fi

  if strip_yaml "$PERF_FILE" | grep -q "max_age: 0"; then
    fail "Browser caching is DISABLED (max_age: 0)"
  else
    pass "Browser caching is enabled"
  fi
fi
