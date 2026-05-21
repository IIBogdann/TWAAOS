import os
import sqlite3
import jwt
from contextlib import asynccontextmanager
from datetime import datetime, timedelta, timezone
from typing import Optional

import bcrypt
from dotenv import load_dotenv
from fastapi import Depends, FastAPI, HTTPException
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field, field_validator

load_dotenv()

DATABASE_PATH = os.environ.get("DATABASE_PATH", "sarcini.db")
SECRET_KEY = os.environ.get("SECRET_KEY", "dev-secret-local")
ALGORITHM = os.environ.get("ALGORITHM", "HS256")
EXPIRARE_TOKEN_MINUTE = int(os.environ.get("EXPIRARE_TOKEN_MINUTE", "30"))

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="autentificare")


def init_database() -> None:
    conn = sqlite3.connect(DATABASE_PATH)
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS utilizatori (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            parola_hash TEXT NOT NULL
        )
        """
    )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS sarcini (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titlu TEXT NOT NULL,
            descriere TEXT,
            finalizata INTEGER DEFAULT 0,
            utilizator_id INTEGER NOT NULL,
            data_crearii TEXT,
            FOREIGN KEY (utilizator_id) REFERENCES utilizatori(id)
        )
        """
    )
    conn.commit()
    conn.close()


def get_db():
    conn = sqlite3.connect(DATABASE_PATH, check_same_thread=False)
    conn.row_factory = sqlite3.Row
    try:
        conn.execute("PRAGMA foreign_keys = ON")
        yield conn
    finally:
        conn.close()


@asynccontextmanager
async def app_lifespan(app: FastAPI):
    init_database()
    yield


app = FastAPI(title="Gestionar de sarcini", version="1.0.0", lifespan=app_lifespan)


class UserRegister(BaseModel):
    email: str = Field(min_length=5, max_length=100)
    parola: str = Field(min_length=8, max_length=100)

    @field_validator("email")
    @classmethod
    def validate_email(cls, value: str) -> str:
        if "@" not in value or "." not in value.split("@")[-1]:
            raise ValueError("Adresa de email nu este validă.")
        return value.lower()


class TaskCreate(BaseModel):
    titlu: str = Field(min_length=1, max_length=200)
    descriere: Optional[str] = Field(default=None, max_length=1000)


class TaskUpdate(BaseModel):
    titlu: Optional[str] = Field(default=None, min_length=1, max_length=200)
    descriere: Optional[str] = Field(default=None, max_length=1000)
    finalizata: Optional[bool] = None


def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()


def verify_password(password: str, password_hash: str) -> bool:
    return bcrypt.checkpw(password.encode(), password_hash.encode())


def create_access_token(data: dict) -> str:
    payload = data.copy()
    payload["exp"] = datetime.now(timezone.utc) + timedelta(
        minutes=EXPIRARE_TOKEN_MINUTE
    )
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: sqlite3.Connection = Depends(get_db),
):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email = payload.get("sub")
        if not email:
            raise HTTPException(status_code=401, detail="Token invalid.")
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expirat. Autentificați-vă din nou.")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Token invalid.")

    user = db.execute("SELECT * FROM utilizatori WHERE email = ?", (email,)).fetchone()
    if not user:
        raise HTTPException(status_code=401, detail="Utilizatorul nu există.")
    return user


def row_to_dict(row: sqlite3.Row) -> dict:
    return dict(row)


@app.get("/healthz")
def health_check():
    return {"status": "ok"}


@app.post("/inregistrare", status_code=201)
def register_user(user: UserRegister, db: sqlite3.Connection = Depends(get_db)):
    existing = db.execute(
        "SELECT id FROM utilizatori WHERE email = ?", (user.email,)
    ).fetchone()
    if existing:
        raise HTTPException(status_code=400, detail="Adresa de email este deja înregistrată.")

    db.execute(
        "INSERT INTO utilizatori (email, parola_hash) VALUES (?, ?)",
        (user.email, hash_password(user.parola)),
    )
    db.commit()
    return {"mesaj": f"Utilizatorul {user.email} a fost înregistrat cu succes."}


@app.post("/autentificare")
def login(
    form: OAuth2PasswordRequestForm = Depends(),
    db: sqlite3.Connection = Depends(get_db),
):
    user = db.execute(
        "SELECT * FROM utilizatori WHERE email = ?", (form.username,)
    ).fetchone()
    if not user or not verify_password(form.password, user["parola_hash"]):
        raise HTTPException(status_code=401, detail="Email sau parolă incorectă.")

    token = create_access_token({"sub": user["email"]})
    return {"access_token": token, "token_type": "bearer"}


@app.get("/utilizatori/eu")
def get_current_user_profile(current_user=Depends(get_current_user)):
    return {"id": current_user["id"], "email": current_user["email"]}


@app.get("/sarcini")
def list_tasks(
    doar_nefinalizate: bool = False,
    db: sqlite3.Connection = Depends(get_db),
    current_user=Depends(get_current_user),
):
    if doar_nefinalizate:
        rows = db.execute(
            "SELECT * FROM sarcini WHERE utilizator_id = ? AND finalizata = 0",
            (current_user["id"],),
        ).fetchall()
    else:
        rows = db.execute(
            "SELECT * FROM sarcini WHERE utilizator_id = ?",
            (current_user["id"],),
        ).fetchall()
    return [row_to_dict(row) for row in rows]


@app.get("/sarcini/{task_id}")
def get_task(
    task_id: int,
    db: sqlite3.Connection = Depends(get_db),
    current_user=Depends(get_current_user),
):
    task = db.execute(
        "SELECT * FROM sarcini WHERE id = ? AND utilizator_id = ?",
        (task_id, current_user["id"]),
    ).fetchone()
    if not task:
        raise HTTPException(status_code=404, detail="Sarcina nu a fost găsită.")
    return row_to_dict(task)


@app.post("/sarcini", status_code=201)
def create_task(
    task: TaskCreate,
    db: sqlite3.Connection = Depends(get_db),
    current_user=Depends(get_current_user),
):
    created_at = datetime.now(timezone.utc).isoformat()
    cursor = db.execute(
        "INSERT INTO sarcini (titlu, descriere, utilizator_id, data_crearii) VALUES (?, ?, ?, ?)",
        (task.titlu, task.descriere, current_user["id"], created_at),
    )
    db.commit()
    new_task = db.execute(
        "SELECT * FROM sarcini WHERE id = ?", (cursor.lastrowid,)
    ).fetchone()
    return row_to_dict(new_task)


@app.put("/sarcini/{task_id}")
def update_task(
    task_id: int,
    data: TaskUpdate,
    db: sqlite3.Connection = Depends(get_db),
    current_user=Depends(get_current_user),
):
    task = db.execute(
        "SELECT * FROM sarcini WHERE id = ? AND utilizator_id = ?",
        (task_id, current_user["id"]),
    ).fetchone()
    if not task:
        raise HTTPException(status_code=404, detail="Sarcina nu a fost găsită.")

    task_dict = row_to_dict(task)
    new_title = data.titlu if data.titlu is not None else task_dict["titlu"]
    new_description = (
        data.descriere if data.descriere is not None else task_dict["descriere"]
    )
    new_done = (
        int(data.finalizata)
        if data.finalizata is not None
        else task_dict["finalizata"]
    )

    db.execute(
        "UPDATE sarcini SET titlu = ?, descriere = ?, finalizata = ? WHERE id = ?",
        (new_title, new_description, new_done, task_id),
    )
    db.commit()
    updated = db.execute("SELECT * FROM sarcini WHERE id = ?", (task_id,)).fetchone()
    return row_to_dict(updated)


@app.patch("/sarcini/{task_id}/finalizeaza")
def complete_task(
    task_id: int,
    db: sqlite3.Connection = Depends(get_db),
    current_user=Depends(get_current_user),
):
    task = db.execute(
        "SELECT * FROM sarcini WHERE id = ? AND utilizator_id = ?",
        (task_id, current_user["id"]),
    ).fetchone()
    if not task:
        raise HTTPException(status_code=404, detail="Sarcina nu a fost găsită.")

    db.execute("UPDATE sarcini SET finalizata = 1 WHERE id = ?", (task_id,))
    db.commit()
    updated = db.execute("SELECT * FROM sarcini WHERE id = ?", (task_id,)).fetchone()
    return row_to_dict(updated)


@app.delete("/sarcini/{task_id}")
def delete_task(
    task_id: int,
    db: sqlite3.Connection = Depends(get_db),
    current_user=Depends(get_current_user),
):
    task = db.execute(
        "SELECT * FROM sarcini WHERE id = ? AND utilizator_id = ?",
        (task_id, current_user["id"]),
    ).fetchone()
    if not task:
        raise HTTPException(status_code=404, detail="Sarcina nu a fost găsită.")

    db.execute("DELETE FROM sarcini WHERE id = ?", (task_id,))
    db.commit()
    return {"mesaj": f"Sarcina cu ID-ul {task_id} a fost ștearsă."}


app.mount("/", StaticFiles(directory="static", html=True), name="static")
