#ddev-generated
#annertech-ddev
IMAGE_STYLES=$(find "$APPROOT" -path "*/config/sync/image.style.*.yml" ! -path "*/.git/*" 2>/dev/null)

if [[ -z "$IMAGE_STYLES" ]]; then
  warn "No image style config files found — skipping AVIF check"
else
  AVIF_MISSING=()
  WEBP_MISSING=()
  while IFS= read -r style_file; do
    style_name=$(basename "$style_file" .yml | sed 's/^image\.style\.//')
    if ! grep -q "id: image_convert_avif" "$style_file"; then
      AVIF_MISSING+=("$style_name")
    elif ! grep -q "extension: webp" "$style_file"; then
      WEBP_MISSING+=("$style_name")
    fi
  done <<< "$IMAGE_STYLES"

  if [[ ${#AVIF_MISSING[@]} -eq 0 && ${#WEBP_MISSING[@]} -eq 0 ]]; then
    pass "All image styles use AVIF with WebP fallback"
  else
    for s in "${AVIF_MISSING[@]}"; do
      warn "Image style '$s' is missing the image_convert_avif effect"
    done
    for s in "${WEBP_MISSING[@]}"; do
      warn "Image style '$s' has image_convert_avif but is missing 'extension: webp' fallback"
    done
  fi
fi
