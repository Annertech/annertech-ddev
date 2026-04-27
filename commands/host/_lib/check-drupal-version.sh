#ddev-generated
#annertech-ddev
if [[ ! -f "$LOCK_FILE" ]]; then
  warn "composer.lock not found — skipping Drupal version check"
else
  DRUPAL_VERSION=$(grep -A3 '"name": "drupal/core"' "$LOCK_FILE" | grep '"version"' | sed 's/.*"version": "\(.*\)".*/\1/' | tr -d 'v')

  if [[ -z "$DRUPAL_VERSION" ]]; then
    warn "drupal/core not found in composer.lock — skipping version check"
  else
    DRUPAL_BRANCH=$(echo "$DRUPAL_VERSION" | grep -oE '^[0-9]+\.[0-9]+\.')
    UPDATE_XML=$(curl -sf --max-time 10 "https://updates.drupal.org/release-history/drupal/current" 2>/dev/null)

    if [[ -z "$UPDATE_XML" ]]; then
      warn "Could not reach updates.drupal.org — skipping support check (installed: $DRUPAL_VERSION)"
    else
      SUPPORTED_BRANCHES=$(echo "$UPDATE_XML" | sed -n 's/.*<supported_branches>\(.*\)<\/supported_branches>.*/\1/p')

      if [[ -z "$SUPPORTED_BRANCHES" ]]; then
        warn "Could not parse supported branches from updates.drupal.org"
      elif echo "$SUPPORTED_BRANCHES" | grep -qF "$DRUPAL_BRANCH"; then
        pass "Drupal $DRUPAL_VERSION is on a supported branch ($DRUPAL_BRANCH)"
      else
        warn "Drupal $DRUPAL_VERSION is NOT supported — supported branches: $SUPPORTED_BRANCHES"
      fi
    fi
  fi
fi
