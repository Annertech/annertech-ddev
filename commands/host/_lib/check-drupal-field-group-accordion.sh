#ddev-generated
#annertech-ddev
FIELD_GROUP_CONFIGS=$(find "$APPROOT" -path "*/config/sync/core.entity_*_display.*.yml" ! -path "*/.git/*" 2>/dev/null)

if [[ -z "$FIELD_GROUP_CONFIGS" ]]; then
  pass "No entity display config found — skipping field_group accordion check"
else
  ACCORDION_FOUND=()
  while IFS= read -r config_file; do
    if strip_yaml "$config_file" | grep -q "format_type: accordion"; then
      ACCORDION_FOUND+=("$(basename "$config_file")")
    fi
  done <<< "$FIELD_GROUP_CONFIGS"

  if [[ ${#ACCORDION_FOUND[@]} -eq 0 ]]; then
    pass "No field_group accordion format in use"
  else
    for f in "${ACCORDION_FOUND[@]}"; do
      warn "field_group accordion format is deprecated — found in $f"
    done
  fi
fi
