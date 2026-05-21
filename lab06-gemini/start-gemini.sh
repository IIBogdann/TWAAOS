#!/usr/bin/env bash
# Lab 6 – pornire rapidă Gemini CLI (fără comenzi manuale la fiecare sesiune)
# Utilizare: ./start-gemini.sh | ./start-gemini.sh check | ./start-gemini.sh test

set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$LAB_DIR"

# --- Node.js: /usr/bin/node sau node din PATH ---
NODE_BIN=""
if [[ -x /usr/bin/node ]]; then
  NODE_BIN=/usr/bin/node
elif command -v node >/dev/null 2>&1; then
  NODE_BIN="$(command -v node)"
fi

check_node() {
  if [[ -z "$NODE_BIN" ]]; then
    echo "EROARE: Node.js nu a fost găsit. Instalează Node 20 LTS (vezi CONFIG.md)."
    return 1
  fi
  local ver major
  ver="$("$NODE_BIN" --version 2>/dev/null || true)"
  major="${ver#v}"
  major="${major%%.*}"
  if [[ -z "$major" || ! "$major" =~ ^[0-9]+$ ]]; then
    echo "EROARE: Nu pot citi versiunea Node ($ver)."
    return 1
  fi
  echo "Node.js: $ver ($NODE_BIN)"
  if (( major >= 20 )); then
    return 0
  fi
  if (( major == 18 )); then
    echo "ATENȚIE: Node 18 detectat. Gemini CLI 0.42+ necesită Node 20+ (eroare „File is not defined”)."
    echo "        Actualizează Node: vezi CONFIG.md → „Instalare Node 20 LTS”."
    return 2
  fi
  echo "EROARE: Node $ver este prea vechi. Necesar Node 20+."
  return 1
}

load_env() {
  if [[ -f .env ]]; then
    echo "Încarc .env din $LAB_DIR ..."
    set -a
    # shellcheck source=/dev/null
    source .env
    set +a
  else
    echo "Notă: fișierul .env lipsește (opțional dacă folosești Login with Google)."
  fi
}

check_api_key() {
  if [[ -z "${GEMINI_API_KEY:-}" ]]; then
    echo "ATENȚIE: GEMINI_API_KEY nu este setată."
    echo "        Pentru cheie API: cp .env.example .env → editează .env → rulează din nou acest script."
    echo "        Alternativ: rulează gemini și alege Login with Google."
    return 1
  fi
  echo "GEMINI_API_KEY: setată (valoarea nu este afișată)."
  return 0
}

check_gemini_cli() {
  if ! command -v gemini >/dev/null 2>&1; then
    echo "EROARE: comanda gemini lipsește. Rulează o dată: ./setup-once.sh"
    return 1
  fi
  echo "Gemini CLI: $(gemini --version 2>/dev/null || echo 'versiune necunoscută')"
  return 0
}

run_checks() {
  echo "=== Verificare mediu Lab 6 (Gemini CLI) ==="
  local node_rc=0
  check_node || node_rc=$?
  command -v npm >/dev/null 2>&1 && echo "npm: $(npm --version)" || echo "ATENȚIE: npm lipsește."
  load_env
  check_api_key || true
  check_gemini_cli || return 1
  if [[ $node_rc -eq 1 ]]; then
    return 1
  fi
  echo "=== Verificare terminată ==="
  return 0
}

# Încredere workspace (evită prompt trusted directory în lab)
export GEMINI_CLI_TRUST_WORKSPACE=true

MODE="${1:-}"

case "$MODE" in
  check)
    run_checks
    exit $?
    ;;
  test)
    echo "=== Test headless Gemini CLI ==="
    node_rc=0
    check_node || node_rc=$?
    if [[ $node_rc -eq 1 ]]; then
      exit 1
    fi
    load_env
    if ! check_api_key; then
      echo "EROARE: testul headless necesită GEMINI_API_KEY sau login Google anterior."
      exit 1
    fi
    check_gemini_cli || exit 1
    echo "Rulez: gemini -p \"hello\" ..."
    gemini -p "hello"
    echo "=== Test reușit ==="
    exit 0
    ;;
  "")
    echo "=== Pornire Gemini CLI (interactiv) ==="
    node_rc=0
    check_node || node_rc=$?
    if [[ $node_rc -eq 1 ]]; then
      exit 1
    fi
    load_env
    check_api_key || true
    check_gemini_cli || exit 1
    echo "Lansez sesiunea interactivă gemini (Ctrl+C sau /exit pentru ieșire) ..."
    exec gemini
    ;;
  *)
    echo "EROARE: argument necunoscut: $MODE"
    echo "Utilizare: ./start-gemini.sh | ./start-gemini.sh check | ./start-gemini.sh test"
    exit 1
    ;;
esac
