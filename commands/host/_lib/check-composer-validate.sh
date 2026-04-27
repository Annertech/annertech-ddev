#ddev-generated
#annertech-ddev
COMPOSER_OUTPUT=$(ddev composer validate --no-check-all --no-check-publish 2>&1)
COMPOSER_EXIT=$?

LOCK_ERRORS=$(echo "$COMPOSER_OUTPUT" | awk '/^# Lock file errors/{found=1; next} /^#/{found=0} found && /^- /{sub(/^- /, ""); print}')
GEN_WARNINGS=$(echo "$COMPOSER_OUTPUT" | awk '/^# General warnings/{found=1; next} /^#/{found=0} found && /^- /{sub(/^- /, ""); print}')

if [[ -n "$LOCK_ERRORS" ]]; then
  while IFS= read -r line; do
    fail "Lock file: $line"
  done <<< "$LOCK_ERRORS"
elif [[ $COMPOSER_EXIT -eq 0 || $COMPOSER_EXIT -eq 1 ]]; then
  pass "composer.json is valid"
else
  fail "composer validate failed"
fi

if [[ -n "$GEN_WARNINGS" ]]; then
  while IFS= read -r line; do
    [[ -n "$line" ]] && warn "$line"
  done <<< "$GEN_WARNINGS"
fi
