# Deploy Lab 7 pe Render (monorepo TWAAOS)

Lab 7 **înlocuiește** deploy-ul Lab 5 pe același serviciu Render — nu e nevoie de cont nou sau card nou.

## Ce schimbi o singură dată în Render

| Câmp | Valoare veche (Lab 5) | Valoare nouă (Lab 7) |
|------|------------------------|----------------------|
| **Blueprint file path** | `lab05-deploy/render.yaml` | `lab07-deploy/render.yaml` |

Sau, dacă configurezi manual serviciul (fără Blueprint sync):

| Câmp | Valoare |
|------|---------|
| **Root Directory** | `lab07-deploy` |

Variabilele de mediu (`SECRET_KEY`, `DATABASE_PATH=/tmp/sarcini.db`, etc.) rămân — sunt definite în `render.yaml`.

## Git

Din rădăcina monorepo-ului:

```bash
cd ~/Documents/TWAAOS
git add lab07-deploy/
git commit -m "Add lab07-deploy final app with About page"
git push origin main
```

## Apply Blueprint

1. Render Dashboard → Blueprint / serviciul `gestionar-sarcini`
2. Actualizează calea Blueprint la `lab07-deploy/render.yaml`
3. **Manual Deploy** sau așteaptă auto-deploy de pe `main`

## Verificare

- https://gestionar-sarcini-qjbr.onrender.com/healthz → `{"status":"ok"}`
- Pagina principală + `/about.html`
- Screenshot pentru formular: https://forms.gle/ucZD3FziG52MZVjv8

## Notă

Folderul `lab05-deploy/` rămâne în repo ca arhivă Lab 5 — nu se șterge.
