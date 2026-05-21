#!/usr/bin/env bash
# Lab 6 – instalare unică Gemini CLI (prima dată pe mașină)
# Rulează o singură dată; la rerulare sare peste dacă CLI există deja.

set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$LAB_DIR"

echo "=== Setup unic Lab 6 – Gemini CLI ==="

# Verificare Node 20+
NODE_BIN=""
if [[ -x /usr/bin/node ]]; then
  NODE_BIN=/usr/bin/node
elif command -v node >/dev/null 2>&1; then
  NODE_BIN="$(command -v node)"
fi

if [[ -z "$NODE_BIN" ]]; then
  echo "EROARE: Node.js lipsește. Instalează Node 20 LTS înainte (vezi CONFIG.md)."
  exit 1
fi

ver="$("$NODE_BIN" --version)"
major="${ver#v}"
major="${major%%.*}"
echo "Node.js: $ver"

if [[ ! "$major" =~ ^[0-9]+$ ]] || (( major < 20 )); then
  echo "EROARE: Node 20+ obligatoriu pentru @google/gemini-cli."
  echo "        Pe Ubuntu 24.04 apt instalează Node 18 — urmează CONFIG.md (NodeSource 20.x)."
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "EROARE: npm lipsește. Instalează npm sau reinstalează Node 20 LTS cu npm inclus."
  exit 1
fi
echo "npm: $(npm --version)"

if command -v gemini >/dev/null 2>&1; then
  echo "Gemini CLI este deja instalat: $(gemini --version 2>/dev/null || true)"
  echo "Sar peste npm install -g (nimic de făcut)."
  echo ""
  echo "Pași următori:"
  echo "  cp .env.example .env   # editează cheia API"
  echo "  ./start-gemini.sh check"
  echo "  ./start-gemini.sh test"
  echo "  ./start-gemini.sh      # sesiune interactivă"
  exit 0
fi

echo "Instalez @google/gemini-cli global (poate cere sudo) ..."
if npm install -g @google/gemini-cli; then
  echo "Instalare reușită: $(gemini --version 2>/dev/null || true)"
else
  echo "EROARE: instalarea a eșuat. Încearcă manual:"
  echo "  sudo npm install -g @google/gemini-cli"
  exit 1
fi

echo ""
echo "=== Setup terminat ==="
echo "Configurează cheia: cp .env.example .env → editează .env"
echo "Apoi: ./start-gemini.sh check && ./start-gemini.sh test"
