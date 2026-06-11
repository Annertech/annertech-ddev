#ddev-generated
#annertech-ddev
SOLR_MANIFEST="$APPROOT/.ddev/addon-metadata/ddev-solr/manifest.yaml"

if [[ ! -f "$SOLR_MANIFEST" ]]; then
  pass "ddev-solr not installed — project does not use Solr"
else
  SOLR_VERSION=$(grep -E '^version:' "$SOLR_MANIFEST" | awk -F': ' '{print $2}' | tr -d '"' | xargs)
  SOLR_REPO=$(grep -E '^repository:' "$SOLR_MANIFEST" | awk -F': ' '{print $2}' | tr -d '"' | xargs)

  if [[ "$SOLR_REPO" == "ddev/ddev-solr" ]]; then
    pass "ddev-solr repository is correct ($SOLR_REPO)"
  else
    fail "ddev-solr repository is '$SOLR_REPO' — expected 'ddev/ddev-solr'"
    warn "Install the correct addon with: 'ddev add-on get ddev/ddev-solr --version $DDEV_SOLR_VERSION'"
  fi

  if [[ "$SOLR_VERSION" == "$DDEV_SOLR_VERSION" ]]; then
    pass "ddev-solr version is $DDEV_SOLR_VERSION"
  else
    fail "ddev-solr version '$SOLR_VERSION' is not supported — only $DDEV_SOLR_VERSION is compatible"
    warn "Install the correct version with: 'ddev add-on get ddev/ddev-solr --version $DDEV_SOLR_VERSION'"
  fi
fi

