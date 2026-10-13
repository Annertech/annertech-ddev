#ddev-generated
#annertech-ddev
# session.sid_bits_per_character is deprecated as of PHP 8.4 and was dropped
# from Drupal's default.services.yml, so it must not be set in services.yml.
# See https://www.drupal.org/node/3469305
DRUPAL_SERVICES="$APPROOT/web/sites/default/services.yml"
if [[ -f "$DRUPAL_SERVICES" ]]; then
  if strip_yaml "$DRUPAL_SERVICES" | grep -q "^    sid_bits_per_character: 6"; then
    fail "web/sites/default/services.yml sets sid_bits_per_character: 6, remove it, see https://www.drupal.org/node/3469305"
  else
    pass "services.yml does not set sid_bits_per_character"
  fi
fi
