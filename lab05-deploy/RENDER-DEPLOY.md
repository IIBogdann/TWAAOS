# Deploy Lab 05 pe Render (monorepo TWAAOS)

## De ce apare eroarea „Blueprint file render.yaml not found on main branch”

Render caută fișierul Blueprint la calea pe care o introduci în formular, **relativ la rădăcina repo-ului GitHub** (`main`), nu în interiorul unui subfolder ales după aceea.

- Greșit: `render.yaml` (rădăcină repo) — fișierul nu există acolo.
- Corect: `lab05-deploy/render.yaml`

În `render.yaml`, câmpul `rootDir: lab05-deploy` spune serviciului web să construiască și să ruleze din acel folder (monorepo). Nu înlocuiește calea Blueprint din dashboard.

## Varianta A — Monorepo (recomandat)

Păstrezi structura: `lab02-fastapi/`, `lab03-tasks/`, `lab04-web-ui/`, `lab05-deploy/`.

### Render Dashboard

| Câmp | Valoare |
|------|---------|
| Repository | `IIBogdann/TWAAOS` |
| Branch | `main` |
| **Blueprint file path** | `lab05-deploy/render.yaml` |

Apoi **Apply Blueprint**.

### Git (din rădăcina monorepo-ului local)

Dacă nu există încă repo local:

```bash
cd /path/to/TWAAOS
git init
git remote add origin https://github.com/IIBogdann/TWAAOS.git
```

Adaugă doar ce trebuie pe GitHub (fără `.env`, `venv/`, `*.db` — sunt în `.gitignore` din `lab05-deploy/`):

```bash
git add lab05-deploy/
git status
git commit -m "Add lab05-deploy Render blueprint and FastAPI app"
git push -u origin main
```

Dacă monorepo-ul există deja pe GitHub dar `lab05-deploy/` lipsește pe `main`:

```bash
git add lab05-deploy/
git commit -m "Add lab05-deploy for Render Blueprint"
git push origin main
```

Verificare: pe GitHub, branch `main` trebuie să conțină `lab05-deploy/render.yaml`.

## Varianta B — Repo doar pentru deploy

Creezi un repo separat (ex. `TWAAOS-lab05`) și copiezi **conținutul** folderului `lab05-deploy/` la **rădăcina** noului repo (nu folderul `lab05-deploy` în sine).

Structură repo nou:

```
main.py
requirements.txt
render.yaml   # fără rootDir sau șterge rootDir din render.yaml
...
```

În `render.yaml` pentru acest repo, elimină linia `rootDir: lab05-deploy`.

Render Blueprint path: `render.yaml`.

## După deploy

- Health: `https://<nume-serviciu>.onrender.com/healthz`
- Pentru curs: screenshot cu URL public al aplicației.
