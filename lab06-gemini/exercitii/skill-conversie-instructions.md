# Exercițiul 4 – Conversie skill Claude → Gemini

**Obiectiv:** Alegi un skill din `archives/claude-code-skills/` (sau `archives/skills-main/`) și creezi varianta Gemini.

## Pași

1. Alege un skill sursă (ex.: `archives/claude-code-skills/.../deepresearcher/SKILL.md`).
2. Creează folder de lucru (opțional):
   ```bash
   mkdir -p lab06-gemini/skills-convertite
   ```
3. Convertește conform regulilor din Part 02:
   - Îmbogățește `description` cu **„Use when..."**
   - Referențiază tool-uri explicit: `google_web_search`, `web_fetch`, `read_file`, etc.
   - Elimină redundanțele din corp
4. Salvează skill-ul convertit în `~/.gemini/skills/` sau `<proiect>/.gemini/skills/`.
5. Testează: `/nume-skill` + o cerere reprezentativă.
6. Notează 2–3 diferențe observate față de versiunea Claude.

## Livrabil

- Fișier skill convertit + scurtă comparație (text sau captură)
