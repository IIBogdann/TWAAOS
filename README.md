# TWAAOS — laboratoare RCC/SC

Proiecte pentru cursul de tehnologii web (FastAPI, SQLite, JWT, interfață web, deploy Render, Gemini CLI).

## Structură

| Folder | Conținut |
|--------|----------|
| `lab02-fastapi/` | API inventar produse (memorie) |
| `lab03-tasks/` | API sarcini + SQLite + JWT |
| `lab04-web-ui/` | Backend + interfață HTML (development local) |
| `lab05-deploy/` | Versiune deploy Lab 5 (arhivă) |
| `lab06-gemini/` | Gemini CLI, skill-uri, raport git |
| `lab07-deploy/` | Aplicație finală publicată pe Render |
| `Notes/` | Enunțuri laboratoare (Markdown) |

## Rulare aplicație finală (Lab 7)

```bash
cd lab07-deploy
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
uvicorn main:app --reload
```

Deploy: vezi `lab07-deploy/RENDER-DEPLOY.md`.
