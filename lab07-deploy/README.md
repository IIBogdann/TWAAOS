# Lab 7 — Gestionar de sarcini (final)

Versiune finală a aplicației din Lab 3–5: API FastAPI + interfață web + pagină **Despre mine**.

## Pornire locală

```bash
cd ~/Documents/TWAAOS/lab07-deploy
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# editează SECRET_KEY în .env
uvicorn main:app --reload
```

Deschide: http://127.0.0.1:8000/ și http://127.0.0.1:8000/about.html

## Deploy Render (înlocuiește Lab 5)

Vezi `RENDER-DEPLOY.md`. Pe scurt:

1. `git add lab07-deploy/` && `git push`
2. În Render: **Blueprint file path** → `lab07-deploy/render.yaml` (sau schimbă Root Directory la `lab07-deploy`)
3. Același serviciu → același URL public după redeploy

## Personalizare About

Editează `static/about.html` (nume, grupă, text, inițiale în avatar).

## Formular curs

https://forms.gle/ucZD3FziG52MZVjv8
