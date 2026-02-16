import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).parent / "planner.db"


def get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        due_date TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0
    )
    """)

    conn.commit()
    conn.close()
