#ddev-generated
#annertech-ddev
if [[ ! -f "$DDEV_CONFIG" ]]; then
  warn "Upsun: .ddev/config.yaml not found — skipping version checks"
else
  DDEV_PHP=$(grep -E '^php_version:' "$DDEV_CONFIG" | sed 's/php_version:[[:space:]]*//' | tr -d '"' | xargs)
  UPSUN_PHP=$(grep -E '^[[:space:]]*type:' "$APP_YAML" | grep 'php:' | sed 's/.*php:\([0-9.]*\).*/\1/' | xargs)

  if [[ -z "$DDEV_PHP" ]]; then
    warn "Upsun: php_version not set in .ddev/config.yaml — skipping PHP version check"
  elif [[ -n "$UPSUN_PHP" ]]; then
    if [[ "$DDEV_PHP" == "$UPSUN_PHP" ]]; then
      pass "PHP $DDEV_PHP matches between DDEV and Upsun"
    else
      fail "PHP version mismatch — DDEV: $DDEV_PHP, Upsun: $UPSUN_PHP"
    fi

    if [[ "$(printf '%s\n' "$PHP_MIN" "$UPSUN_PHP" | sort -V | head -1)" != "$PHP_MIN" ]]; then
      warn "PHP $UPSUN_PHP in .platform.app.yaml is below minimum supported version ($PHP_MIN)"
    fi
  fi

  if [[ -f "$SERVICES_FILE" && -n "$DDEV_DB_VERSION" && -n "$DDEV_DB_TYPE" ]]; then
    UPSUN_DB_VERSION=$(grep -E "type:.*${DDEV_DB_TYPE}:" "$SERVICES_FILE" | head -1 | sed 's/.*:\([0-9.]*\).*/\1/' | xargs)
    if [[ -n "$UPSUN_DB_VERSION" ]]; then
      if [[ "$DDEV_DB_VERSION" == "$UPSUN_DB_VERSION" ]]; then
        pass "Database $DDEV_DB_TYPE:$DDEV_DB_VERSION matches between DDEV and Upsun"
      else
        fail "Database version mismatch — DDEV: $DDEV_DB_TYPE:$DDEV_DB_VERSION, Upsun: $DDEV_DB_TYPE:$UPSUN_DB_VERSION"
      fi
    fi
  fi

  if [[ -f "$SERVICES_FILE" ]]; then
    UPSUN_REDIS_VERSION=$(grep -E "type:.*redis:" "$SERVICES_FILE" | head -1 | sed 's/.*redis:\([0-9.]*\).*/\1/' | xargs)
    if [[ -n "$UPSUN_REDIS_VERSION" ]]; then
      if [[ "$(printf '%s\n' "$REDIS_REQUIRED_VERSION" "$UPSUN_REDIS_VERSION" | sort -V | head -1)" != "$REDIS_REQUIRED_VERSION" ]]; then
        fail "Redis version $UPSUN_REDIS_VERSION in services.yaml is below required version ($REDIS_REQUIRED_VERSION)"
      else
        pass "Redis $UPSUN_REDIS_VERSION meets required version ($REDIS_REQUIRED_VERSION)"
      fi
    fi
  fi
fi
