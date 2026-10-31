#!/usr/bin/env bash
# check-shared-env.sh — Verify no profile .env redundantly duplicates a key from shared.env
# An "override" (different value) is fine and expected; a "duplicate" (identical value) is waste.
# Usage: bash ~/.hermes/scripts/check-shared-env.sh
# Exit 0 if clean; exit 1 if redundant duplicates found.

SHARED_ENV="${HERMES_HOME:-$HOME/.hermes}/shared.env"
PROFILES_DIR="${HERMES_HOME:-$HOME/.hermes}/profiles"

if [[ ! -f "$SHARED_ENV" ]]; then
  echo "ERROR: shared.env not found at $SHARED_ENV" >&2
  exit 1
fi

# Collect keys defined in shared.env (non-comment assignment lines)
mapfile -t shared_keys < <(
  grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$SHARED_ENV" | cut -d= -f1
)

if [[ ${#shared_keys[@]} -eq 0 ]]; then
  echo "ERROR: no keys found in $SHARED_ENV" >&2
  exit 1
fi

warnings=0

for profile_env in "$PROFILES_DIR"/*/.env; do
  [[ -f "$profile_env" ]] || continue
  profile_name="$(basename "$(dirname "$profile_env")")"

  for key in "${shared_keys[@]}"; do
    if grep -qE "^${key}=" "$profile_env" 2>/dev/null; then
      # Key present in both — check if values are identical (redundant) or different (override)
      shared_val=$(grep -E "^${key}=" "$SHARED_ENV" | tail -1 | cut -d= -f2- | tr -d '"'"'")
      profile_val=$(grep -E "^${key}=" "$profile_env" | tail -1 | cut -d= -f2- | tr -d '"'"'")
      if [[ "$shared_val" == "$profile_val" ]]; then
        echo "WARN: $profile_name/.env redundantly duplicates shared key: $key (identical value — remove from profile)"
        warnings=$(( warnings + 1 ))
      fi
      # Different value = intentional override; no warning
    fi
  done
done

if [[ $warnings -eq 0 ]]; then
  echo "OK: no profile .env files redundantly duplicate keys from shared.env"
  exit 0
else
  echo "Total warnings: $warnings"
  exit 1
fi
