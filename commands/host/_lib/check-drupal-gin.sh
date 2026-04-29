#ddev-generated
#annertech-ddev
GIN_SETTINGS="${APPROOT:-${DDEV_APPROOT:-.}}/config/sync/gin.settings.yml"
if [[ -f "$GIN_SETTINGS" ]]; then
  if grep -A3 "^logo:" "$GIN_SETTINGS" | grep -q "use_default: false"; then
    warn "Gin theme logo is set to use site logo. Set logo.use_default: true for simplei module to work"
  else
    pass "Gin theme is using its own logo in toolbar"
  fi
fi
