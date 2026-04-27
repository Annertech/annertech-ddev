#ddev-generated
#annertech-ddev
if [[ ! -f "$DDEV_CONFIG" ]]; then
  warn ".ddev/config.yaml not found — skipping DDEV version checks"
else
  DDEV_DB_TYPE=$(grep -A2 '^database:' "$DDEV_CONFIG" | grep 'type:' | sed 's/.*type:[[:space:]]*//' | tr -d '"' | xargs)
  DDEV_DB_VERSION=$(grep -A2 '^database:' "$DDEV_CONFIG" | grep 'version:' | sed 's/.*version:[[:space:]]*//' | tr -d '"' | xargs)

  if [[ -z "$DDEV_DB_VERSION" ]]; then
    warn "database.version not set in .ddev/config.yaml — skipping database version check"
  elif [[ "$DDEV_DB_TYPE" == "mariadb" ]]; then
    if [[ "$(printf '%s\n' "$DB_MIN_MARIADB" "$DDEV_DB_VERSION" | sort -V | head -1)" != "$DB_MIN_MARIADB" ]]; then
      warn "Database version $DDEV_DB_TYPE:$DDEV_DB_VERSION is below required minimum $DB_MIN_MARIADB"
    else
      pass "Database version $DDEV_DB_TYPE:$DDEV_DB_VERSION meets minimum ($DB_MIN_MARIADB)"
    fi
  else
    pass "Database $DDEV_DB_TYPE:$DDEV_DB_VERSION"
  fi
fi
