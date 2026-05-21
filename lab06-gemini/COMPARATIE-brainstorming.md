# Exercițiul 4 — Comparație Claude vs Gemini (brainstorming)

| Aspect | Claude (`brainstorming`) | Gemini (`brainstorming-gemini`) |
|--------|--------------------------|----------------------------------|
| Declanșare | description în română, fără „Use when” explicit | description cu **Use when...** (stil Gemini) |
| Întrebări user | Tool dedicat `AskUserQuestion` | Întrebări în chat, o dată pe rând |
| Tool-uri | AskUserQuestion, Bash browser | `read_file`, `list_directory`, `google_web_search` |
| Pași extra | git worktree, writing-plans, logo AI-Wizard | Eliminate — focus pe design simplu |
| Limbă | Română | Română + instrucțiuni tool-uri în engleză |

## Concluzie scurtă

Ambele ghidează același flux (întrebări → opțiuni → design). Versiunea Gemini e mai explicită pentru CLI-ul Google și mai ușor de portat fără tool-uri specifice Claude.
