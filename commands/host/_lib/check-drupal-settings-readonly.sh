#ddev-generated
#annertech-ddev
# settings.php must be read-only.
SETTINGS_REL="web/sites/default/settings.php"
SETTINGS_FILE="$APPROOT/$SETTINGS_REL"

if [[ -f "$SETTINGS_FILE" ]]; then
  SETTINGS_PERMS=$(ls -l "$SETTINGS_FILE" | cut -c2-10)
  if [[ "$SETTINGS_PERMS" == *w* ]]; then
    fail "$SETTINGS_REL is writable ($SETTINGS_PERMS) — make it read-only (chmod 444 $SETTINGS_REL)"
  else
    pass "$SETTINGS_REL is read-only ($SETTINGS_PERMS)"
  fi
fi
