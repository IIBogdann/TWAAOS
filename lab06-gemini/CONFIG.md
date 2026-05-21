# Configurare API Gemini CLI (Lab 6)

Cheia API rămâne **doar pe mașina ta**. Nu o pune în chat, nu o comite în git.

---

## Cerință Node.js 20+ (obligatoriu)

`@google/gemini-cli` **0.42+** necesită **Node.js 20 sau mai nou**. Pe Ubuntu 24.04, pachetul `nodejs` din `apt` instalează de obicei **Node 18** — insuficient.

### Eroare tipică cu Node 18

```text
ReferenceError: File is not defined
```

Aceasta **nu** este o problemă de cheie API, ci de versiune Node. Actualizează Node la 20 LTS (vezi mai jos), apoi reinstalează CLI-ul.

### Instalare Node 20 LTS pe Ubuntu 24.04 (NodeSource)

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version    # trebuie v20.x.x
npm --version
```

Verifică că folosești Node din sistem, nu un alt binar din PATH:

```bash
/usr/bin/node --version
which node
```

După upgrade:

```bash
sudo npm install -g @google/gemini-cli
gemini --version
```

---

## Securitate cheie API

- **Nu** testa cheia punând-o direct în comandă (ex. `GEMINI_API_KEY=AIza... gemini ...`) — intră în **istoricul shell** (`~/.bash_history`) și poate fi citită de alți utilizatori sau backup-uri.
- Folosește fișierul `.env` + `source .env` (vezi Varianta A).
- **Nu** trimite cheia în chat, issue-uri sau commit-uri git.
- Dacă ai expus cheia (istoric, chat, captură ecran), **revocă-o** în [Google AI Studio](https://aistudio.google.com/app/apikey) și generează una nouă.

---

## Varianta A – fișier `.env` în `lab06-gemini/` (recomandat pentru laborator)

1. Copiază șablonul:
   ```bash
   cd ~/Documents/TWAAOS/lab06-gemini
   cp .env.example .env
   ```
2. Editează `.env` și pune cheia reală (din [Google AI Studio](https://aistudio.google.com/app/apikey)).

   **Format corect** (fără spații în jurul `=`, fără ghilimele inutile):

   ```env
   GEMINI_API_KEY=AIzaSy...cheia_ta
   ```

   **Greșit:**

   ```env
   GEMINI_API_KEY = AIzaSy...    # spații — bash nu exportă corect
   GEMINI_API_KEY= AIzaSy...     # spațiu după =
   export GEMINI_API_KEY=...     # nu e necesar în .env; source face export cu set -a
   ```

3. Verifică și testează cu scriptul de laborator (încarcă `.env` automat):
   ```bash
   ./start-gemini.sh check
   ./start-gemini.sh test
   ```
4. Sesiune interactivă:
   ```bash
   ./start-gemini.sh
   ```

**Manual (alternativ):** `set -a && source .env && set +a` apoi `gemini -p "Salut"`.

**De ce funcționează:** Gemini CLI citește `GEMINI_API_KEY` din mediul procesului. Fișierul `.env` din acest folder **nu** este citit automat de CLI până nu îl „sursezi” cu `source` (sau nu exporti manual). Alternativ, poți pune aceeași linie în `~/.gemini/.env` — CLI o încarcă la pornire (vezi [documentația de autentificare](https://google-gemini.github.io/gemini-cli/docs/get-started/authentication.html)).

**Nu comite `.env`** — este listat în `.gitignore`.

---

## Varianta B – autentificare interactivă (fără cheie în fișier)

1. Rulează:
   ```bash
   gemini
   ```
2. La prima pornire alege **Login with Google** și urmează pașii din browser.
3. Test headless după login:
   ```bash
   gemini -p "hello"
   ```

Potrivit pentru lucru local rapid; pentru scripturi headless (exercițiul 3) este mai practică **Varianta A**.

---

## Instalare CLI (dacă lipsește)

**Mai întâi** Node 20+ (secțiunea de mai sus). Apoi, din `lab06-gemini/`:

```bash
./setup-once.sh          # instalează @google/gemini-cli dacă lipsește; sare dacă există
./start-gemini.sh check
```

**Manual (alternativ):**

```bash
sudo npm install -g @google/gemini-cli
gemini --version
```

Nu te baza pe `sudo apt install npm` singur — pe Ubuntu 24.04 vine cu Node 18 și provoacă `File is not defined`.

---

## Test rapid

```bash
cd ~/Documents/TWAAOS/lab06-gemini
./start-gemini.sh check    # Node v20+, npm, gemini, GEMINI_API_KEY
./start-gemini.sh test     # headless: gemini -p "hello"
./start-gemini.sh          # interactiv
```

Scriptul `start-gemini.sh` setează automat `GEMINI_CLI_TRUST_WORKSPACE=true` (evită promptul „trusted directory” în lab). Alternativ manual: `gemini --skip-trust -p "hello"` (vezi [trusted folders](https://geminicli.com/docs/cli/trusted-folders/)).

---

## Referințe

- [Autentificare Gemini CLI](https://google-gemini.github.io/gemini-cli/docs/get-started/authentication.html)
- [Mod headless](https://google-gemini.github.io/gemini-cli/docs/cli/headless.html)
