#!/usr/bin/env bash
# Instalează doar skill-urile Lab 6 în ~/.gemini/skills/
# Comenzile TOML rămân în lab06-gemini/.gemini/commands/ (fără copiere globală — evită conflictul /doc:functie)

set -euo pipefail
LAB06="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Lab 6: instalare exerciții (skill-uri) ==="

mkdir -p "$HOME/.gemini/skills"

for skill in traductor.md brainstorming-gemini.md; do
  if [ -f "$LAB06/skills-installed/$skill" ]; then
    cp "$LAB06/skills-installed/$skill" "$HOME/.gemini/skills/$skill"
    echo "Skill: $HOME/.gemini/skills/$skill"
  fi
done

echo "Comandă /doc:functie: $LAB06/.gemini/commands/doc/functie.toml (pornește gemini din lab06-gemini)"

chmod +x "$LAB06/exercitii/raport-zilnic.sh" 2>/dev/null || true

echo ""
echo "Gata. Pornește din lab06-gemini: ./start-gemini.sh"
echo "Test rapid: ./run-lab6.sh test-exercitii"
