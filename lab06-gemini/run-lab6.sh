#!/usr/bin/env bash
# O singură comandă: instalare exerciții + verificare mediu

set -euo pipefail
LAB06="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$LAB06"

echo "=== Lab 6 — run complet ==="
./install-exercitii.sh
echo ""
./start-gemini.sh check
echo ""

MODE="${1:-}"

case "$MODE" in
  test-exercitii)
    echo "=== Teste pe care le rulezi TU în gemini (din lab06-gemini: ./start-gemini.sh) ==="
    echo "  /traductor The quick brown fox"
    echo "  /traductor Aceasta este o propoziție de test."
    echo "  /doc:functie salut_utilizator     # exemple/demo_funcs.py"
    echo "  /doc:functie calculeaza_total"
    echo "  /brainstorming-gemini Vreau un buton de export în aplicația de sarcini"
    echo ""
    echo "Raport git:"
    ./exercitii/raport-zilnic.sh
    ;;
  *)
    echo "=== Gata. Următorul pas ==="
    echo "  ./start-gemini.sh          # sesiune interactivă"
    echo "  ./run-lab6.sh test-exercitii  # raport + listă teste în gemini"
    echo ""
    echo "Exerciții: vezi GEMINI.md și COMPARATIE-brainstorming.md"
    ;;
esac
