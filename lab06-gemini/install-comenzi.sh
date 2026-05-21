#!/usr/bin/env bash
# Lab 6 – comenzi pregătite (rulează manual, pas cu pas)
# Nu modifică lab02–lab05

set -euo pipefail

echo "=== Verificare mediu ==="
node --version || { echo "Node.js lipsește. Instalează Node 20 LTS (vezi CONFIG.md)."; exit 1; }
if ! command -v npm >/dev/null 2>&1; then
  echo "npm lipsește. Pe Ubuntu/Debian:"
  echo "  sudo apt install -y npm"
  exit 1
fi
npm --version

echo ""
echo "=== Instalare Gemini CLI (global) ==="
echo "Rulează:"
echo "  sudo npm install -g @google/gemini-cli"
echo "  gemini --version"
echo ""
echo "Alternativă fără instalare globală:"
echo "  npx @google/gemini-cli --version"
echo "  npx @google/gemini-cli -p \"Salut\""
echo ""
echo "=== Cheie API (local, lab06-gemini) ==="
echo "  cd \"$(dirname "$0")\""
echo "  cp .env.example .env"
echo "  # Editează .env – NU comite, NU trimite în chat"
echo "  set -a && source .env && set +a"
echo "  Vezi CONFIG.md"
echo ""
echo "=== Autentificare (alternativă) ==="
echo "  gemini"
echo "  # Alege Login with Google"
echo ""
echo "=== Test rapid ==="
echo "  gemini -p \"Salut, confirmă că CLI funcționează.\""
