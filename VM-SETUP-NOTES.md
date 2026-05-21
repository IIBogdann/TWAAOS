# TWAAOS — pregătire VM (Lab #01–#05)

## Mediu
- **OS:** Ubuntu 24.04.4 LTS (Mate) — user `vboxuser`
- **VirtualBox Guest Additions:** 7.1.6
- **SSH:** Cursor remote
- **Notion (Python):** https://www.notion.so/Configurarea-mediului-de-dezvoltare-Python-Linux-1c96a07fc8488002aaf6fd96766733e0
- **Materiale curs:** `~/Documents/TWAAOS/Notes/`
  - Lab #02: `Notes/TWAAOS-RCC,SC lab #02.md`

## Reguli
- Nu copia comenzi din documente cu copy-paste (caractere invalide); tastează manual.
- Medii virtuale Python (`venv`); nu `sudo pip install` (PEP 668).
- **Denumiri noi:** prefix `lab2` + nume englezesc (ex. `lab2-inventory`). Nu folosi `lab-two`, `two` în nume noi.
- **IMPORTANT:** După ce un laborator e finalizat, **nu modifica** folderul acelui lab. Lucrările noi merg în folderul labului curent (ex. Lab 4 → `lab04-web-ui/`).

## Foldere (câte un lab = un folder)

| Folder | Conținut | Predare |
|--------|----------|---------|
| `lab02-fastapi/` | Lab 2 — inventar produse, memorie | ✓ finalizat |
| `lab03-tasks/` | Lab 3 — API + SQLite + JWT (fără CORS, fără HTML) | ✓ restaurat |
| `lab04-web-ui/` | Lab 4 — backend + CORS + `index.html` (Live Server) | ✓ finalizat |
| `lab05-deploy/` | Lab 5 — deploy: `.env`, StaticFiles, `render.yaml` | ✓ separat |

## IDE
- **Cursor** — remote SSH (agent).
- **VS Code** — editor local pe Mate (pachet `code` 1.121.0, repo Microsoft). Lansare: meniu Mate → **Visual Studio Code**, sau din terminal local (fără sesiune Cursor SSH): `env -u VSCODE_IPC_HOOK_CLI code .` — în sesiunea Cursor remote, `code` din PATH poate indica CLI-ul Cursor, nu VS Code de pe desktop.
- **Windsurf** — neinstalat (nu e necesar).

## Lab #01 — mediu Linux (21.05.2026) ✓

| Task | Stare |
|------|--------|
| `apt update` + `apt upgrade` (noninteractive) | ✓ |
| tree, mc, screen, curl, wget, git, sqlite3, zip, unzip | ✓ |
| python3, python3-dev, python3-pip, python3-wheel, python3-setuptools, python3-venv | ✓ |
| `apt autoremove` | ✓ |
| Versiuni: python3, pip3, sqlite3, git | ✓ (vezi mai jos) |
| `which python3 pip3 sqlite3 git` | ✓ |
| build-essential, libsqlite3-dev, sqlitebrowser, dbeaver-ce | ✓ (de la curs) |

**Versiuni verificate:**
- Python 3.12.3 — `/usr/bin/python3`
- pip 24.0 — `/usr/bin/pip3`
- SQLite 3.45.1 — `/usr/bin/sqlite3`
- git 2.43.0 — `/usr/bin/git`

## Structură proiect

```
~/Documents/TWAAOS/
├── VM-SETUP-NOTES.md
├── Notes/
│   ├── TWAAOS-RCC,SC lab #02.md
│   └── TWAAOS-RCC,SC lab #03 v3.md
├── lab02-fastapi/
│   ├── main.py
│   ├── requirements.txt
│   └── venv/
├── lab03-tasks/        ← doar Lab 3 (API, Swagger)
│   ├── main.py
│   ├── requirements.txt
│   ├── sarcini.db
│   └── venv/
├── lab04-web-ui/
│   ├── main.py
│   ├── index.html
│   └── venv/
└── lab05-deploy/       ← Lab 5 (un singur server, deploy)
    ├── main.py
    ├── static/index.html
    ├── render.yaml
    ├── .env.example
    ├── Dockerfile
    └── venv/
```

## Lab #02 FastAPI — inventar ✓

- **Proiect:** `lab02-fastapi/`
- **venv:** fastapi 0.136.1, uvicorn 0.47.0, pydantic 2.13.4
- **main.py:** GET/POST/DELETE/PUT `/produse`, filtru `stoc_minim` (bonus), model `Produs`, listă in-memory

**Pornire server:**
```bash
cd ~/Documents/TWAAOS/lab02-fastapi
source venv/bin/activate
uvicorn main:app --reload
```

**Test:** `http://127.0.0.1:8000/docs` (Swagger UI)

## Lab #03 — sarcini + SQLite + JWT ✓

- **Folder:** `lab03-tasks/` (doar API, **fără** CORS, **fără** `index.html`)
- **Test:** Swagger `http://127.0.0.1:8000/docs`

```bash
cd ~/Documents/TWAAOS/lab03-tasks && source venv/bin/activate && uvicorn main:app --reload
```

## Lab #04 — interfață web ✓

- **Folder:** `lab04-web-ui/` (backend complet + `index.html` + CORS)
- **Nu modifica** `lab03-tasks` pentru Lab 4 — tot ce ține de web e aici

```bash
# Terminal 1 — API din folderul Lab 4
cd ~/Documents/TWAAOS/lab04-web-ui && source venv/bin/activate && uvicorn main:app --reload

# VS Code: Open with Live Server pe lab04-web-ui/index.html
```

## Lab #05 — deploy Render ✓

- **Folder:** `lab05-deploy/` (nu modifica lab02–lab04)
- **Frontend:** `static/index.html`, `const API = ""`
- **Secrets:** `.env` local (gitignore); Render generează `SECRET_KEY`
- **DB producție:** `DATABASE_PATH=/tmp/sarcini.db` în `render.yaml`

```bash
cd ~/Documents/TWAAOS/lab05-deploy
cp .env.example .env   # editează SECRET_KEY
source venv/bin/activate
uvicorn main:app --reload
# http://127.0.0.1:8000 — UI + API același origin
```

## VM pregătit?
- **Lab #01–#04:** DA (foldere separate, neatinse)
- **Lab #05:** DA local — tu faci `git push` + Render + screenshot formular
