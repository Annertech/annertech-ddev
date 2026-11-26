#ddev-generated
#annertech-ddev
# core/install.php must be absent, or blocked in .platform.app.yaml (issue #196).
# A local absence only counts if a composer script removes it, otherwise the
# Upsun build puts it back.
INSTALL_PHP_REL="web/core/install.php"
INSTALL_PHP_FIX="run:
      composer config scripts.post-install-cmd \"rm -f web/core/install.php\"
      composer config scripts.post-update-cmd \"rm -f web/core/install.php\"
    or set '/core/install.php': allow: false under web.locations in .platform.app.yaml"
INSTALL_PHP_COMPOSER=false
INSTALL_PHP_BLOCKED=false

if [[ -f "$APPROOT/composer.json" ]] && grep -qE '"[^"]*rm [^"]*core/install\.php[^"]*"' "$APPROOT/composer.json"; then
  INSTALL_PHP_COMPOSER=true
fi

if [[ -n "$APP_YAML" && -f "$APP_YAML" ]] && strip_yaml "$APP_YAML" | awk '
  /^[[:space:]]*["\x27]?\/core\/install\.php["\x27]?[[:space:]]*:/ { match($0, /^[[:space:]]*/); ind = RLENGTH; inblock = 1; next }
  inblock && NF { match($0, /^[[:space:]]*/); if (RLENGTH <= ind) inblock = 0; else if ($0 ~ /allow[[:space:]]*:[[:space:]]*false/) found = 1 }
  END { exit !found }'; then
  INSTALL_PHP_BLOCKED=true
fi

if $INSTALL_PHP_BLOCKED; then
  pass "/core/install.php access is denied in .platform.app.yaml"
elif [[ -f "$APPROOT/$INSTALL_PHP_REL" ]] && $INSTALL_PHP_COMPOSER; then
  critical_fail "$INSTALL_PHP_REL is present despite the composer script — set '/core/install.php': allow: false under web.locations in .platform.app.yaml"
elif [[ -f "$APPROOT/$INSTALL_PHP_REL" ]]; then
  critical_fail "$INSTALL_PHP_REL is present and not blocked — $INSTALL_PHP_FIX"
elif $INSTALL_PHP_COMPOSER; then
  pass "$INSTALL_PHP_REL is not present and is removed by a composer script"
else
  critical_fail "$INSTALL_PHP_REL is missing locally but no composer script removes it, so Upsun builds will restore it — $INSTALL_PHP_FIX"
fi
