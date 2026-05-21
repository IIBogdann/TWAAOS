---
name: brainstorming-gemini
description: |
  Use when starting a new feature, UI change, or creative work before writing code.
  Use when the user wants ideas, design options, or planning — not direct implementation yet.
---

# Brainstorming (Gemini)

## Tool-uri

Folosește după nevoie: `read_file`, `list_directory`, `glob`, `google_web_search` (doar dacă e necesar context extern).

## Proces

### 1. Înțelegerea ideii

- Verifică contextul proiectului (fișiere relevante, README).
- Pune **o întrebare pe rând** pentru a clarifica scopul, constrângerile și criteriile de succes.
- Preferă întrebări cu 2–3 variante de răspuns când e posibil.

### 2. Explorarea abordărilor

- Propune **2–3 abordări** cu avantaje și dezavantaje.
- Recomandă o opțiune și explică de ce.

### 3. Prezentarea designului

- Prezintă designul în secțiuni scurte (arhitectură, componente, date, erori, testare).
- După fiecare secțiune, cere confirmare înainte de a continua.

## Principii

- YAGNI — fără funcții inutile.
- Validare incrementală — nu un singur bloc uriaș de text.
- La final, oferă rezumat și pași următori (implementare opțională).

## Diferențe față de skill-ul Claude original

- Claude folosește `AskUserQuestion`; aici pui întrebări direct în chat.
- Tool-urile sunt numite explicit pentru Gemini CLI.
- Fără pași specifici git/worktree din ecosistemul Claude.
