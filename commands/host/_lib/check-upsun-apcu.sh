#ddev-generated
#annertech-ddev
if [[ -n "$APP_YAML" && -f "$APP_YAML" ]]; then
  if strip_yaml "$APP_YAML" | grep -qE "^\s+-\s+apcu\b"; then
    pass "APCu extension is enabled in .platform.app.yaml"
  else
    warn "APCu extension is not enabled in .platform.app.yaml — add 'apcu' under runtime.extensions for better performance"
  fi
fi
