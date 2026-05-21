---
name: traductor
description: |
  Use when the user asks for translation between Romanian and English, or uses /traductor.
  Detect source language, translate to Romanian if foreign, to English if Romanian.
  Preserve Markdown, code blocks, and list formatting.
---

# Traductor RO ↔ EN

## Pași

1. Identifică limba textului primit (română, engleză sau altă limbă).
2. Dacă textul nu e română → traduce în **română**.
3. Dacă textul e română → traduce în **engleză**.
4. Păstrează formatarea: titluri Markdown, liste, blocuri de cod, emoji.

## Reguli

- Nu adăuga explicații lungi — livrează traducerea clară.
- Păstrează numele proprii și termenii tehnici consacrați (API, FastAPI, JWT) dacă sunt uzuali.
- Pentru blocuri de cod, traduce doar comentariile și docstring-urile, nu identificatorii din cod.
