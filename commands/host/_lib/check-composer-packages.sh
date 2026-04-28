#ddev-generated
#annertech-ddev
if [[ ! -f "$LOCK_FILE" ]]; then
  warn "composer.lock not found — skipping composer/installers check"
else
  INSTALLERS_VERSION=$(grep -A3 '"name": "composer/installers"' "$LOCK_FILE" | grep '"version"' | sed 's/.*"version": "\(.*\)".*/\1/')
  if [[ -n "$INSTALLERS_VERSION" ]]; then
    INSTALLERS_MAJOR=$(echo "$INSTALLERS_VERSION" | sed 's/^v//' | cut -d. -f1)
    if [[ "$INSTALLERS_MAJOR" == "1" ]]; then
      warn "composer/installers is version $INSTALLERS_VERSION — must be version 2.x"
    fi
  fi

  if grep -q '"name": "zaporylie/composer-drupal-optimizations"' "$LOCK_FILE"; then
    warn "zaporylie/composer-drupal-optimizations is present — this package must not be used"
  fi

  if grep -q '"name": "anrt-tools/docksal-configuration"' "$LOCK_FILE"; then
    warn "anrt-tools/docksal-configuration is present — this package must not be used"
  fi

  if [[ "$DDEV_UPSTREAM_PROVIDER" == "platform" || "$DDEV_UPSTREAM_PROVIDER" == "upsun" ]]; then
    CONFIG_READER_VERSION=$(grep -A3 '"name": "platformsh/config-reader"' "$LOCK_FILE" | grep '"version"' | sed 's/.*"version": "\(.*\)".*/\1/')
    if [[ -n "$CONFIG_READER_VERSION" ]]; then
      CONFIG_READER_MAJOR=$(echo "$CONFIG_READER_VERSION" | sed 's/^v//' | cut -d. -f1)
      if [[ "$CONFIG_READER_MAJOR" -lt "$CONFIG_READER_MIN" ]]; then
        warn "platformsh/config-reader is version $CONFIG_READER_VERSION — upgrade to ${CONFIG_READER_MIN}.x required"
      else
        pass "platformsh/config-reader $CONFIG_READER_VERSION is up to date"
      fi
    fi
  fi
fi
