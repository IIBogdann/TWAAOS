# Lab 6 — Gestionar sarcini / TWAAOS

Acest folder este pentru laboratorul Gemini CLI (skill-uri, comenzi TOML, rapoarte).

## Comenzi utile

- `./install-exercitii.sh` — instalează doar skill-urile în `~/.gemini/skills/` (nu copiază comenzi TOML global)
- `./start-gemini.sh` — pornește Gemini cu `.env` încărcat (cwd = lab06-gemini)
- `./run-lab6.sh` — instalare + verificare + instrucțiuni test

## Exerciții

1. `/traductor` — traducere RO↔EN
2. `/doc:functie NUME` — docstring funcție Python (comandă din `.gemini/commands/` acestui folder; fără prefix `workspace.` sau `user.` dacă pornești gemini aici)
3. `./exercitii/raport-zilnic.sh` — raport git în `rapoarte/`
4. `/brainstorming-gemini` — planificare idei (skill convertit din Claude)

## Test /doc:functie

Din `lab06-gemini` (după `./start-gemini.sh`):

```
/doc:functie salut_utilizator
/doc:functie calculeaza_total
```

Funcții de probă: `exemple/demo_funcs.py`. Conflictul cu `~/.gemini/commands/doc/functie.toml` este rezolvat — comanda nu se mai instalează global.
