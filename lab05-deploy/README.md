# Lab 05 — Gestionar de sarcini (deploy)

## Local

```bash
cp .env.example .env
# editează SECRET_KEY în .env
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
```

Deschide: http://127.0.0.1:8000

## GitHub + Render

1. `git init` în acest folder (fără `.env`, fără `*.db`, fără `venv/`)
2. Push pe GitHub
3. Render → **New → Blueprint** → selectează repo → **Apply**
4. Upload screenshot URL public pentru formularul cursului

## Docker (bonus)

```bash
touch sarcini.db
docker build -t gestionar-sarcini .
docker run -p 8000:8000 --env-file .env gestionar-sarcini
```
