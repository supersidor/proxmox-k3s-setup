#!/bin/zsh
set -euo pipefail

# Generates the SealedSecrets master keypair and stores it (base64-encoded)
# in ../.env as SEALED_SECRETS_TLS_CRT_B64 / SEALED_SECRETS_TLS_KEY_B64.
#
# Usage: ./scripts/generate-sealed-secrets-key.sh [--force]
# IMPORTANT: keep a backup of .env somewhere offline after running.

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$REPO_ROOT/.env"
FORCE="${1:-}"

if [[ -f "$ENV_FILE" ]] && grep -q '^SEALED_SECRETS_TLS_CRT_B64=' "$ENV_FILE" && [[ "$FORCE" != "--force" ]]; then
  echo "SEALED_SECRETS_TLS_CRT_B64 already set in $ENV_FILE. Re-run with --force to rotate (this will invalidate all existing SealedSecrets)." >&2
  exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

openssl req -x509 -newkey rsa:4096 -nodes -days 3650 \
  -keyout "$TMP/tls.key" -out "$TMP/tls.crt" \
  -subj '/CN=sealed-secret/O=sealed-secret' 2>/dev/null

CRT_B64="$(base64 < "$TMP/tls.crt" | tr -d '\n')"
KEY_B64="$(base64 < "$TMP/tls.key" | tr -d '\n')"

touch "$ENV_FILE"
grep -v '^SEALED_SECRETS_TLS_\(CRT\|KEY\)_B64=' "$ENV_FILE" > "$TMP/env.new" || true
{
  cat "$TMP/env.new"
  echo "SEALED_SECRETS_TLS_CRT_B64=$CRT_B64"
  echo "SEALED_SECRETS_TLS_KEY_B64=$KEY_B64"
} > "$ENV_FILE"
chmod 600 "$ENV_FILE"

echo "Wrote SEALED_SECRETS_TLS_{CRT,KEY}_B64 to $ENV_FILE (mode 600)."
echo "Back up $ENV_FILE offline — losing it makes every committed SealedSecret unrecoverable."
