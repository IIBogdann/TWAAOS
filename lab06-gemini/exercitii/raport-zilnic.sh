#!/usr/bin/env bash
# Lab 6 - Exercițiul 3: raport zilnic din git diff + Gemini headless

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAB06_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_DIR="$(cd "$LAB06_DIR/.." && pwd)"
RAPOARTE_DIR="${LAB06_DIR}/rapoarte"
DATA="$(date +%Y-%m-%d)"
RAPORT="${RAPOARTE_DIR}/${DATA}.md"
TMP_JSON="/tmp/gemini-raport-${DATA}.json"

cd "$REPO_DIR"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Eroare: $REPO_DIR nu e repository git."
  exit 1
fi

if [ -f "${LAB06_DIR}/.env" ]; then
  set -a
  # shellcheck source=/dev/null
  source "${LAB06_DIR}/.env"
  set +a
fi

export GEMINI_CLI_TRUST_WORKSPACE=true

if ! command -v gemini >/dev/null 2>&1; then
  echo "Eroare: gemini nu e în PATH. Rulează ./setup-once.sh"
  exit 1
fi

mkdir -p "$RAPOARTE_DIR"

if git rev-list --count HEAD 2>/dev/null | grep -q '^1$'; then
  MODIFICATE="$(git show --name-only --pretty=format: HEAD 2>/dev/null || true)"
  DIFF_STAT="$(git show --stat HEAD 2>/dev/null || true)"
else
  MODIFICATE="$(git diff --name-only HEAD~1 HEAD 2>/dev/null || true)"
  DIFF_STAT="$(git diff --stat HEAD~1 HEAD 2>/dev/null || true)"
fi

if [ -z "$(echo "$MODIFICATE" | tr -d '[:space:]')" ]; then
  echo "Nu există modificări de raportat."
  exit 0
fi

PROMPT="Generează un raport scurt în Markdown (română) despre modificările git de mai jos.
Include: Rezumat, Fișiere modificate, Observații tehnice, Riscuri/opțional.
Nu inventa fișiere care nu apar în listă.

Fișiere:
${MODIFICATE}

Statistici diff:
${DIFF_STAT}"

echo "Generez raportul cu Gemini..."
gemini -p "$PROMPT" -y --output-format json > "$TMP_JSON" 2>/dev/null || {
  echo "JSON indisponibil, rulez mod text..."
  gemini -p "$PROMPT" -y > "$RAPORT"
  echo "Raport salvat: $RAPORT"
  exit 0
}

if command -v jq >/dev/null 2>&1; then
  jq -r '.response // .text // .' "$TMP_JSON" 2>/dev/null > "$RAPORT" || \
    gemini -p "$PROMPT" -y > "$RAPORT"
  echo "---" >> "$RAPORT"
  echo "" >> "$RAPORT"
  echo "## Statistici tokeni (dacă disponibile)" >> "$RAPORT"
  jq '.stats // .usage // empty' "$TMP_JSON" 2>/dev/null >> "$RAPORT" || true
  TOKENS="$(jq '[.stats.total_tokens? // .usage.total_tokens? // 0] | add' "$TMP_JSON" 2>/dev/null || echo "N/A")"
  echo ""
  echo "Tokeni (estimare din JSON): $TOKENS"
else
  grep -v '^{' "$TMP_JSON" > "$RAPORT" 2>/dev/null || cp "$TMP_JSON" "$RAPORT"
fi

echo "Raport salvat: $RAPORT"
