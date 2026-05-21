# Lab 6 — Gemini CLI

Materiale curs: `Notes/TWAAOS-RCC,SC lab #06 (part 01).md` și `part 02.md`.

## Pornire

```bash
cd lab06-gemini
cp .env.example .env          # cheie API local, fără commit
./setup-once.sh               # prima dată
./run-lab6.sh                 # instalare skill-uri + verificare
./start-gemini.sh             # sesiune interactivă
```

## Exerciții

| # | Livrabil |
|---|----------|
| 1 | Skill `traductor` → `skills-installed/`, test `/traductor` |
| 2 | Comandă `/doc:functie` → `.gemini/commands/doc/functie.toml` |
| 3 | `./exercitii/raport-zilnic.sh` → `rapoarte/` |
| 4 | Skill `brainstorming-gemini` + `COMPARATIE-brainstorming.md` |

Arhivele de curs (skill-uri exemplu) se pot dezarhiva local din `Notes/`; nu sunt în repo.
