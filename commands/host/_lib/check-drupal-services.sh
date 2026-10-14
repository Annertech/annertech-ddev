#ddev-generated
#annertech-ddev
# session.sid_bits_per_character is deprecated as of PHP 8.4 and was dropped
# from Drupal's default.services.yml, so it must not be set in services.yml.
# See https://www.drupal.org/node/3469305
# Only relevant when Upsun runs PHP 8.4 or later.
DRUPAL_SERVICES="$APPROOT/web/sites/default/services.yml"
SERVICES_PHP=""
[[ -f "$APP_YAML" ]] && SERVICES_PHP=$(strip_yaml "$APP_YAML" | grep -E '^[[:space:]]*type:' | grep 'php:' | sed 's/.*php:\([0-9.]*\).*/\1/' | xargs)
if [[ -f "$DRUPAL_SERVICES" && -n "$SERVICES_PHP" && "$(printf '%s\n' 8.4 "$SERVICES_PHP" | sort -V | head -1)" == "8.4" ]]; then
  if strip_yaml "$DRUPAL_SERVICES" | grep -q "^    sid_bits_per_character: 6"; then
    fail "web/sites/default/services.yml sets sid_bits_per_character: 6, remove it, see https://www.drupal.org/node/3469305"
  else
    pass "services.yml does not set sid_bits_per_character"
  fi
fi
