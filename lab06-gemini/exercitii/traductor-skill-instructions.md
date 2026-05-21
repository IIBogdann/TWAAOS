# Exercițiul 1 – Skill `traductor` (instrucțiuni)

**Obiectiv:** Creezi skill-ul în `~/.gemini/skills/traductor.md` (global), nu în acest folder.

## Pași

1. Creează directorul (dacă nu există):
   ```bash
   mkdir -p ~/.gemini/skills
   ```

2. Creează fișierul `~/.gemini/skills/traductor.md` cu structura de mai jos.

3. Completează tu frontmatter-ul și corpul conform cerințelor din laborator:
   - Detectează limba textului primit
   - Traduce în **română** dacă textul e în altă limbă
   - Traduce în **engleză** dacă textul e deja în română
   - Păstrează formatarea (Markdown, blocuri de cod, liste)

## Șablon de completat (șterge liniile TODO)

```markdown
---
name: traductor
description: |
  TODO: Descrie ce face skill-ul și când se folosește.
  Include „Use when..." – ex.: când utilizatorul cere traducere RO↔EN.
---

# Traductor

TODO: Instrucțiuni pentru model – pași clari, fără tool-uri web necesare.

## Reguli

- TODO: Detectare limbă
- TODO: Direcție traducere (RO ↔ EN)
- TODO: Păstrare formatare
```

## Test în sesiunea `gemini`

```
/traductor The quick brown fox jumps over the lazy dog
/traductor Aceasta este o propoziție de test în română
```

## Livrabil

- Fișier `~/.gemini/skills/traductor.md`
- Captură sau notă scurtă cu rezultatul cel puțin unui test `/traductor`
