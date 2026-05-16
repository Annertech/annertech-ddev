#ddev-generated
#annertech-ddev
# Catch modules removed from core.extension.yml and composer.lock in the same push.
if [[ -n "$EXT_FILE" ]] && git -C "$APPROOT" rev-parse --git-dir >/dev/null 2>&1; then
  if [[ -n "$GIT_PUSH_RANGE_BASE" ]]; then
    DIFF_FROM="$GIT_PUSH_RANGE_BASE"
    DIFF_TO="${GIT_PUSH_RANGE_TIP:-HEAD}"
  else
    DIFF_FROM="HEAD"
    DIFF_TO=""
  fi

  EXT_DIFF=$(git -C "$APPROOT" diff "$DIFF_FROM" $DIFF_TO -- "$EXT_FILE" 2>/dev/null)
  REMOVED_MODULES=$(echo "$EXT_DIFF" | grep -E "^-[[:space:]]+[a-z_0-9]+:[[:space:]]*[0-9]+" | sed -E 's/^-[[:space:]]+([a-z_0-9]+):.*/\1/')

  if [[ -n "$REMOVED_MODULES" ]]; then
    LOCK_DIFF=""
    [[ -f "$LOCK_FILE" ]] && LOCK_DIFF=$(git -C "$APPROOT" diff "$DIFF_FROM" $DIFF_TO -- "$LOCK_FILE" 2>/dev/null)

    SEARCH_DIRS=()
    for d in "$APPROOT/web/modules" "$APPROOT/web/profiles" "$APPROOT/modules"; do
      [[ -d "$d" ]] && SEARCH_DIRS+=("$d")
    done

    UNSAFE=()
    while IFS= read -r mod; do
      [[ -z "$mod" ]] && continue

      MOD_PATH=""
      if [[ ${#SEARCH_DIRS[@]} -gt 0 ]]; then
        MOD_PATH=$(find "${SEARCH_DIRS[@]}" -maxdepth 5 -type d -name "$mod" ! -path "*/.git/*" 2>/dev/null | head -1)
      fi

      COMPOSER_REMOVED=false
      if [[ -n "$LOCK_DIFF" ]] && echo "$LOCK_DIFF" | grep -qE "^-[[:space:]]+\"name\":[[:space:]]+\"drupal/${mod}\""; then
        COMPOSER_REMOVED=true
      fi

      if [[ -z "$MOD_PATH" ]] || $COMPOSER_REMOVED; then
        UNSAFE+=("$mod")
      fi
    done <<< "$REMOVED_MODULES"

    if [[ ${#UNSAFE[@]} -gt 0 ]]; then
      for m in "${UNSAFE[@]}"; do
        critical_fail "Module '$m' is being uninstalled AND its code/package removed in the same change — uninstall first (deploy), then remove code in a later change"
      done
    else
      pass "Module uninstallations keep code/package in place (safe)"
    fi
  fi
fi
bail_if_critical
