#ddev-generated
#annertech-ddev
# Google Consent Mode v2 defaults are added by anrt-tools/anrt_gdpr 2.11.1+.
# Hardcoded copies in custom themes send the defaults twice, so flag them.
GCM_MIN="2.11.1"
GCM_THEMES_DIR="$APPROOT/web/themes/custom"
GCM_PATTERN="gtag\(\s*['\"]consent['\"]\s*,\s*['\"]default['\"]"

if [[ -f "$LOCK_FILE" ]] && grep -q '"name": "anrt-tools/anrt_gdpr"' "$LOCK_FILE"; then
  GDPR_VERSION=$(grep -A3 '"name": "anrt-tools/anrt_gdpr"' "$LOCK_FILE" | grep '"version"' | sed 's/.*"version": "\(.*\)".*/\1/')
  GDPR_CLEAN=$(echo "$GDPR_VERSION" | sed 's/^v//')
  if [[ "$(printf '%s\n' "$GCM_MIN" "$GDPR_CLEAN" | sort -V | head -1)" != "$GCM_MIN" ]]; then
    warn "anrt-tools/anrt_gdpr is version $GDPR_VERSION — upgrade to $GCM_MIN or higher for Google Consent Mode v2 defaults (composer update anrt-tools/anrt_gdpr)"
  else
    pass "anrt-tools/anrt_gdpr $GDPR_VERSION sets Google Consent Mode v2 defaults"
  fi
fi

if [[ -d "$GCM_THEMES_DIR" ]]; then
  GCM_HITS=$(grep -rnE --exclude-dir=node_modules "$GCM_PATTERN" "$GCM_THEMES_DIR" 2>/dev/null)
  if [[ -n "$GCM_HITS" ]]; then
    warn "Hardcoded Google Consent Mode defaults found in custom themes — remove them, anrt-tools/anrt_gdpr $GCM_MIN+ adds them:"
    while IFS= read -r hit; do
      echo -e "${YELLOW}      ${hit#"$APPROOT"/}${NC}"
    done <<< "$GCM_HITS"
  else
    pass "No hardcoded Google Consent Mode defaults in custom themes"
  fi
fi
