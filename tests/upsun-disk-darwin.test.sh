#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
helper="$root/commands/host/_lib/upsun-disk-helper.sh"

set +e
numfmt --to iec --format "%3.2f" 1048576 >/tmp/numfmt.out 2>/tmp/numfmt.err
red=$?
set -e
if [ "$red" -eq 0 ]; then
  echo "numfmt unexpectedly succeeded" >&2
  exit 1
fi
grep -q "command not found" /tmp/numfmt.err

funcs=$(awk '
  /^format_iec\(\) \{/ {p=1}
  p {print}
  /^}$/ && p {exit}
' "$helper")
eval "$funcs"
one=$(format_iec 1048576)
five=$(format_iec 5 1048576)
small=$(format_iec 1536)
[ "$one" = "1.00M" ]
[ "$five" = "5.00M" ]
[ "$small" = "1.50K" ]
if grep -q 'numfmt ' "$helper"; then
  echo "helper still calls numfmt" >&2
  exit 1
fi
echo "upsun disk darwin ok (numfmt exit $red, 1MiB $one, 5 units $five)"
