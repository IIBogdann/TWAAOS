# Lab 6 – Gemini CLI, agenți și skill-uri

> Materiale oficiale: `Notes/TWAAOS-RCC,SC lab #06 (part 01).md` și `Notes/TWAAOS-RCC,SC lab #06 (part 02).md`  
> Lucrul tău pentru laborator: doar în acest folder `lab06-gemini/` (nu modifica `lab02`–`lab05`).

---

## Despre ce este Lab 6

Lab 6 te învață să folosești **Gemini CLI** (linia de comandă Google Gemini): instalare, autentificare, comenzi interactive (`/help`, `@fișier`, `!shell`), mod headless (`gemini -p "..."`), fișierul de context `GEMINI.md`, apoi **skill-uri** (fișiere `.md` cu YAML) și **comenzi personalizate** (fișiere `.toml`). Compari formatul și filozofia skill-urilor **Claude Code** vs **Gemini CLI** și faci 4 exerciții practice (traducător, documentație funcție, script raport zilnic, conversie skill).

---

## Ce conturi și unelte îți trebuie

| Necesar | Detalii |
|--------|---------|
| **Node.js** | Versiune **18+** (recomandat 20 LTS). Pe mașina ta: `v20.18.2` ✓ |
| **npm** | Pentru `npm install -g @google/gemini-cli` — instalat via `apt` (verifică `npm --version`) |
| **Cont Google** | Metoda recomandată: „Login with Google” la prima rulare `gemini` |
| **Sau API Key** | Din [Google AI Studio](https://aistudio.google.com/app/apikey) — vezi **Configurare API** mai jos (fișier `.env` local, fără chat) |
| **Opțional GCP** | Vertex AI / `gcloud` — doar dacă folosești varianta enterprise din tutorial |
| **Git** | Pentru exercițiul 3 (raport zilnic din `git diff`) |
| **jq** | Recomandat pentru parsare JSON din mod headless (`sudo apt install jq`) |

**Pornire rapidă (recomandat):** `./run-lab6.sh` (instalează exercițiile + verifică mediu), apoi `./start-gemini.sh`. Prima dată pe mașină: `./setup-once.sh`. Configurare cheie API: `CONFIG.md` și `.env.example`.

---

## Configurare API (fără a trimite cheia în chat)

1. Copiază șablonul: `cp .env.example .env`
2. Editează **local** `.env` și pune cheia la `GEMINI_API_KEY=...` (din [AI Studio](https://aistudio.google.com/app/apikey)).
3. Verifică mediu: `./start-gemini.sh check`
4. Test headless: `./start-gemini.sh test`
5. Sesiune interactivă: `./start-gemini.sh`

**Alternativă:** `./start-gemini.sh` fără `.env` → Login with Google la prima pornire.

Detalii complete: [`CONFIG.md`](CONFIG.md). Fișierul `.env` este în `.gitignore` — **nu** face `git add .env`.

---

## Stare locală (verificat la pregătirea lab-ului)

- Folder creat: `lab06-gemini/`
- Arhive dezarhivate în `lab06-gemini/archives/`:
  - `gemini-skills-main/` — 3 skill-uri exemplu Gemini
  - `claude-code-skills/` — 2 skill-uri exemplu Claude (inclusiv `deepresearcher`)
  - `skills-main/` — colecție mai mare Anthropic (18 skill-uri + spec)
- **Gemini CLI**: `gemini --version` → 0.42.0 (instalat global în `/usr/local/bin/gemini`)
- **npm**: instalat (`/usr/bin/npm`, Node apt v18 — CLI recomandă Node 20+; vezi `CONFIG.md`)

---

## Checklist pas cu pas (limbaj simplu)

### Partea A – Instalare și utilizare de bază (Part 01)

- [ ] **A1.** Verifică Node: `node --version` (trebuie v18+)
- [ ] **A2.** Instalează npm dacă lipsește: `sudo apt install -y npm` (sau reinstalează Node cu npm din [nodejs.org](https://nodejs.org))
- [ ] **A3.** Instalează Gemini CLI global: `npm install -g @google/gemini-cli`
- [ ] **A4.** Verifică: `gemini --version`
- [ ] **A5.** Autentificare: rulează `gemini` → alege **Login with Google** (sau setează `GEMINI_API_KEY`)
- [ ] **A6.** În sesiune interactivă, testează: `/help`, `/about`, `/stats`
- [ ] **A7.** Testează includere fișier: `@README.md` + o întrebare scurtă
- [ ] **A8.** Testează shell: `!ls -la` sau `!pwd`
- [ ] **A9.** Mod headless: `gemini -p "Explică pe scurt ce este un skill în Gemini CLI"`
- [ ] **A10.** Opțional: generează context proiect cu `/init` sau creează manual `GEMINI.md` în rădăcina unui proiect de test

### Partea B – Agenți, skill-uri, comenzi (Part 02)

- [ ] **B1.** Citește secțiunea despre ce este un „agent” (3 niveluri: TOML → skill → headless)
- [ ] **B2.** Creează folder skill-uri: `mkdir -p ~/.gemini/skills`
- [ ] **B3.** Urmează exercițiul ghidat: creează `news-summary.md` (tutorial) sau sari la exercițiile de la final
- [ ] **B4.** Compară skill **Claude** vs **Gemini** folosind arhivele locale (vezi secțiunea de mai jos)
- [ ] **B5.** Înțelege comenzi TOML: `.gemini/commands/` **în proiect** (lab06); skill-urile merg în `~/.gemini/skills/` via `./install-exercitii.sh`
- [x] **B6.** Exercițiul 1: skill `traductor.md` — `skills-installed/` + `./install-exercitii.sh`
- [x] **B7.** Exercițiul 2: comandă `/doc:functie` — `lab06-gemini/.gemini/commands/doc/functie.toml` (fără duplicat în `~/.gemini/commands/`)
- [x] **B8.** Exercițiul 3: script `exercitii/raport-zilnic.sh` → `rapoarte/YYYY-MM-DD.md`
- [x] **B9.** Exercițiul 4: `brainstorming-gemini.md` + `COMPARATIE-brainstorming.md`

### Livrabile pentru profesor / notare (din exercițiile oficiale)

1. Fișier `~/.gemini/skills/traductor.md` + captură/test cu `/traductor`
2. Fișier `lab06-gemini/.gemini/commands/doc/functie.toml` + test `/doc:functie <nume>` din acest folder (ex. `salut_utilizator` în `exemple/demo_funcs.py`)
3. Script `raport-zilnic.sh` + folder `rapoarte/` cu cel puțin un fișier `YYYY-MM-DD.md`
4. Un skill convertit din Claude → Gemini (cu descriere „Use when...” și tool-uri explicite) + scurtă comparație observată

---

## Comparație Claude Code vs Gemini CLI (skill-uri)

| Aspect | Claude Code | Gemini CLI |
|--------|-------------|------------|
| Format | `.md` + YAML frontmatter | La fel |
| Folder global | `~/.claude/skills/` | `~/.gemini/skills/` |
| Folder proiect | `.claude/skills/` | `.gemini/skills/` |
| Invocare | `/nume-skill` | `/nume-skill` |
| Descriere YAML | Mai scurtă | Mai lungă — include **când** se activează („Use when...”) |
| Tool-uri în corp | Implicite / vagi | Explicite: `google_web_search`, `web_fetch`, etc. |
| Routing automat | Mai puțin dependent de descriere | Modelul poate alege skill-ul după `description` |

**Exemplu local:** deschide și compară:
- Claude: `archives/claude-code-skills/claude.code.skills/deepresearcher/SKILL.md`
- Gemini (tutorial menționează `deepresearcher.geminicli.SKILL.md` — poți crea varianta convertită în `lab06-gemini/skills-convertite/`)

**Arhive pentru studiu:**
- `archives/claude.code.skills.zip` → `claude-code-skills/` (brainstorming, deepresearcher)
- `archives/gemini-skills-main.zip` → API dev, interactions, live API
- `archives/skills-main.zip` → bibliotecă Anthropic (pdf, docx, skill-creator, etc.) — util la Exercițiul 4

---

## Comenzi utile (copiere rapidă)

```bash
cd /home/vboxuser/Documents/TWAAOS/lab06-gemini

# Prima dată pe mașină (instalare CLI + verificare Node 20+)
./setup-once.sh

# Configurare cheie (o dată)
cp .env.example .env
# editează .env local

# La fiecare sesiune de laborator (din lab06-gemini)
./run-lab6.sh              # skill-uri în ~/.gemini/skills/ + verificare mediu
./start-gemini.sh check    # verifică Node, npm, gemini, .env
./start-gemini.sh test     # test headless: gemini -p "hello"
./start-gemini.sh          # sesiune interactivă — /doc:functie fără prefix workspace/user
./run-lab6.sh test-exercitii  # listă teste: /doc:functie salut_utilizator, etc.

# Exemplu prompt headless manual (după ./start-gemini.sh test reușit)
gemini -p "Listează 3 diferențe între skill Claude și skill Gemini"

# Creare skill (exercițiu 1)
mkdir -p ~/.gemini/skills
nano ~/.gemini/skills/traductor.md
```

---

## Exerciții – ce faci tu (schelete în `exercitii/`)

| # | Fișier ghid / șablon | Ce completezi |
|---|----------------------|---------------|
| 1 | `exercitii/traductor-skill-instructions.md` | `~/.gemini/skills/traductor.md` + test `/traductor` |
| 2 | `templates/doc-functie.toml` → `.gemini/commands/doc/functie.toml` (doar în lab06) | `./start-gemini.sh` apoi `/doc:functie salut_utilizator` pe `exemple/demo_funcs.py` |
| 3 | `exercitii/raport-zilnic.sh` | Script headless + folder `rapoarte/YYYY-MM-DD.md` |
| 4 | `exercitii/skill-conversie-instructions.md` | Skill convertit din `archives/` + comparație scurtă |

---

## Structura acestui folder

```
lab06-gemini/
├── README.md                 ← acest ghid
├── CONFIG.md                 ← API key + autentificare (română)
├── start-gemini.sh           ← pornire zilnică (check / test / interactiv)
├── setup-once.sh             ← instalare unică CLI
├── .env.example              ← șablon cheie (copie → .env)
├── .gitignore                ← exclude .env
├── install-exercitii.sh      ← skill-uri → ~/.gemini/skills/ (nu comenzi globale)
├── install-comenzi.sh        ← referință comenzi manuale (legacy)
├── .gemini/commands/doc/     ← /doc:functie (doar proiect — evită conflict CLI)
├── exemple/demo_funcs.py     ← funcții de test pentru /doc:functie
├── exercitii/                ← schelete pentru cele 4 exerciții
├── templates/                ← doc-functie.toml (ex. 2)
├── archives/                 ← zip-uri dezarhivate din Notes/
│   ├── gemini-skills-main/
│   ├── claude-code-skills/
│   └── skills-main/
└── (tu creezi: skills-convertite/, rapoarte/, .env)
```

---

## Primele 3 pași pe care să le faci acum

1. **Setup (o dată):** `./setup-once.sh` → `cp .env.example .env` → editează `.env`.
2. **Testează CLI:** `./run-lab6.sh` apoi `./start-gemini.sh check` și `./start-gemini.sh test`.
3. **Exercițiul 1:** `./start-gemini.sh` pentru sesiune interactivă; urmează `exercitii/traductor-skill-instructions.md`.

---

## Conflict `/doc:functie` (rezolvat)

Dacă aceeași comandă există în `~/.gemini/commands/` și în `lab06-gemini/.gemini/commands/`, Gemini CLI o afișează dublu (`/workspace.doc:functie` și `/user.doc:functie`). Lab 6 instalează **doar skill-urile** global; comanda rămâne în proiect. Pornește `gemini` din `lab06-gemini` și folosește `/doc:functie salut_utilizator` (vezi `exemple/demo_funcs.py`). Șterge manual vechiul `~/.gemini/commands/doc/functie.toml` dacă l-ai creat anterior.

---

## Referințe oficiale

- [Comenzi CLI](https://google-gemini.github.io/gemini-cli/docs/cli/commands.html)
- [Headless](https://google-gemini.github.io/gemini-cli/docs/cli/headless.html)
- [Autentificare](https://google-gemini.github.io/gemini-cli/docs/get-started/authentication.html)
- [Custom commands (TOML)](https://google-gemini.github.io/gemini-cli/docs/cli/custom-commands.html)
