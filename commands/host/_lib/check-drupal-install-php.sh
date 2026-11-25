#ddev-generated
#annertech-ddev
# core/install.php must be removed by composer or blocked in .platform.app.yaml (issue #196).
INSTALL_PHP_PROTECTED=false

if [[ -f "$APPROOT/composer.json" ]] && grep -qE '"[^"]*rm [^"]*core/install\.php[^"]*"' "$APPROOT/composer.json"; then
  INSTALL_PHP_PROTECTED=true
  pass "core/install.php is removed by a composer script"
fi

if [[ -n "$APP_YAML" && -f "$APP_YAML" ]] && strip_yaml "$APP_YAML" | awk '
  /^[[:space:]]*["\x27]?\/core\/install\.php["\x27]?[[:space:]]*:/ { match($0, /^[[:space:]]*/); ind = RLENGTH; inblock = 1; next }
  inblock && NF { match($0, /^[[:space:]]*/); if (RLENGTH <= ind) inblock = 0; else if ($0 ~ /allow[[:space:]]*:[[:space:]]*false/) found = 1 }
  END { exit !found }'; then
  INSTALL_PHP_PROTECTED=true
  pass "/core/install.php access is denied in .platform.app.yaml"
fi

$INSTALL_PHP_PROTECTED || critical_fail "core/install.php is not protected — add \"rm -f web/core/install.php\" to composer post-install-cmd/post-update-cmd, or set '/core/install.php': allow: false under web.locations in .platform.app.yaml"
