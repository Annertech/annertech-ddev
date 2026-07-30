#ddev-generated
#annertech-ddev
AUDIT_OUTPUT=$(ddev exec composer audit 2>&1)
AUDIT_EXIT=$?

# composer audit exit codes: 0=clean, 1=vulnerabilities found
if [[ $AUDIT_EXIT -eq 0 ]]; then
  pass "No security vulnerabilities found"
else
  VULN_LINE=$(echo "$AUDIT_OUTPUT" | grep -oE "Found [0-9]+ security vulnerability advisor(y|ies) affecting [0-9]+ package")
  if [[ -n "$VULN_LINE" ]]; then
    VULN_COUNT=$(echo "$VULN_LINE" | grep -oE "^Found [0-9]+" | grep -oE "[0-9]+")
    warn "$VULN_COUNT security vulnerability advisories found — run 'ddev composer audit' for details"
  fi
fi
