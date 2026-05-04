#ddev-generated
#annertech-ddev
LOCAL_PROJECT_YAML="$APPROOT/.platform/local/project.yaml"
if [[ ! -f "$LOCAL_PROJECT_YAML" ]]; then
  warn "Upsun: .platform/local/project.yaml not found — skipping project ID check"
else
  UPSUN_PROJECT_ID=$(grep -E '^id:' "$LOCAL_PROJECT_YAML" | sed 's/id:[[:space:]]*//' | tr -d '"' | xargs)
  DDEV_PROJECT_ID=$(grep -E 'PLATFORM_PROJECT=' "$DDEV_CONFIG" | sed 's/.*PLATFORM_PROJECT=//' | tr -d '"' | xargs)

  if [[ -z "$UPSUN_PROJECT_ID" ]]; then
    warn "Upsun: could not read project ID from .platform/local/project.yaml"
  elif [[ -z "$DDEV_PROJECT_ID" ]]; then
    warn "Upsun: PLATFORM_PROJECT not set in .ddev/config.yaml"
  elif [[ "$DDEV_PROJECT_ID" == "$UPSUN_PROJECT_ID" ]]; then
    pass "Project ID matches between DDEV and Upsun ($UPSUN_PROJECT_ID)"
  else
    fail "Project ID mismatch — DDEV: $DDEV_PROJECT_ID, Upsun: $UPSUN_PROJECT_ID"
  fi
fi
