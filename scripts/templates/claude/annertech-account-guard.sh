#!/usr/bin/env bash
#ddev-generated
#annertech-ddev
#
## Description: Refuses Claude Code work when the signed-in Claude account is not on the Annertech organisation.
## Usage: annertech-account-guard.sh session|tool
##
## Lives in .ddev/scripts/templates/claude/ so add-on updates keep it current.
## Wired up from the project's .claude/settings.json as a SessionStart hook
## (warns) and a PreToolUse hook (denies every tool call). Reads the account
## Claude Code itself is authenticated with, not the git identity.

set -uo pipefail

# Annertech organisation UUID, as reported by Claude Code in ~/.claude.json.
EXPECTED_ORG="${ANNERTECH_EXPECTED_ORG:-83c9d8b1-c0be-404b-8350-1d2b34f94638}"

# 1 = allow work when the account genuinely cannot be determined (no jq and no
#     python3, or an unreadable config). 0 = refuse in that case too.
FAIL_OPEN_ON_UNKNOWN="${ANNERTECH_GUARD_FAIL_OPEN:-1}"

CONFIG="${ANNERTECH_GUARD_CONFIG:-$HOME/.claude.json}"
MODE="${1:-tool}"

read_org() {
  [ -r "$CONFIG" ] || return 1
  if command -v jq >/dev/null 2>&1; then
    jq -r '.oauthAccount.organizationUuid // empty' "$CONFIG" 2>/dev/null || return 1
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("oauthAccount",{}).get("organizationUuid") or "")' "$CONFIG" 2>/dev/null || return 1
  else
    return 1
  fi
}

# Reason text is interpolated into JSON: keep it plain ASCII, no quotes.
refuse() {
  local reason="$1"
  case "$MODE" in
    session)
      printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$reason" "$reason"
      ;;
    *)
      printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$reason" "$reason"
      ;;
  esac
  exit 0
}

if ORG="$(read_org)"; then
  if [ -z "$ORG" ]; then
    STATUS="no-account"
  elif [ "$ORG" = "$EXPECTED_ORG" ]; then
    STATUS="ok"
  else
    STATUS="foreign"
  fi
else
  STATUS="unknown"
fi

case "$STATUS" in
  ok)
    exit 0
    ;;
  no-account)
    refuse "Annertech guard: no Claude account is signed in, or this session uses an API key instead of an Annertech seat. Client work must run on an Annertech account. Run /login and sign in with your annertech.com account."
    ;;
  foreign)
    refuse "Annertech guard: this Claude Code session is signed in to a personal or non-Annertech organisation. Client work must run on an Annertech account. Run /login and switch to your annertech.com account."
    ;;
  unknown)
    if [ "$FAIL_OPEN_ON_UNKNOWN" = "1" ]; then
      exit 0
    fi
    refuse "Annertech guard: could not determine which Claude account is signed in, and the guard is set to fail closed. Install jq or python3, or check that ~/.claude.json is readable."
    ;;
esac
