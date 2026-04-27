#ddev-generated
#annertech-ddev
SOLR_MANIFEST="$APPROOT/.ddev/addon-metadata/solr/manifest.yaml"

if [[ ! -f "$SOLR_MANIFEST" ]]; then
  pass "ddev-drupal-solr not installed — project does not use Solr"
else
  SOLR_VERSION=$(grep -E '^version:' "$SOLR_MANIFEST" | awk -F': ' '{print $2}' | tr -d '"' | xargs)
  SOLR_REPO=$(grep -E '^repository:' "$SOLR_MANIFEST" | awk -F': ' '{print $2}' | tr -d '"' | xargs)

  if [[ "$SOLR_REPO" == "ddev/ddev-drupal-solr" || "$SOLR_REPO" == "ddev/ddev-drupal9-solr" ]]; then
    pass "ddev-drupal-solr repository is correct ($SOLR_REPO)"
  else
    fail "ddev-drupal-solr repository is '$SOLR_REPO' — expected 'ddev/ddev-drupal-solr' or 'ddev/ddev-drupal9-solr'"
    warn "Install the correct addon with: 'ddev add-on get ddev/ddev-drupal-solr --version $SOLR_REQUIRED_VERSION'"
  fi

  if [[ "$SOLR_VERSION" == "$SOLR_REQUIRED_VERSION" ]]; then
    pass "ddev-drupal-solr version is $SOLR_REQUIRED_VERSION"
  else
    fail "ddev-drupal-solr version '$SOLR_VERSION' is not supported — only $SOLR_REQUIRED_VERSION is compatible"
    warn "Install the correct version with: 'ddev add-on get ddev/ddev-drupal-solr --version $SOLR_REQUIRED_VERSION'"
  fi
fi
