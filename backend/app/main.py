from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import date
from pydantic import BaseModel, Field, field_validator
from app.db import init_db, get_connection

app = FastAPI()


class TaskCreate(BaseModel):
    title: str = Field(..., min_length=1)
    due_date: date
    completed: bool = False

    @field_validator("title")
    @classmethod
    def title_not_blank(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("Title cannot be empty")
        return v


class TaskUpdate(BaseModel):
    title: str | None = None
    due_date: date | None = None
    completed: bool | None = None

    @field_validator("title")
    @classmethod
    def title_not_blank_if_present(cls, v: str | None) -> str | None:
        if v is None:
            return v
        v = v.strip()
        if not v:
            raise ValueError("Title cannot be empty")
        return v

@app.on_event("startup")
def on_startup():
    init_db()


@app.get("/")
def root():
    return {"message": "Backend is running"}


@app.get("/tasks")
def get_tasks():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT id, title, due_date, completed FROM tasks ORDER BY id DESC")
    rows = cur.fetchall()
    conn.close()

    tasks = []
    for r in rows:
        tasks.append({
            "id": r["id"],
            "title": r["title"],
            "due_date": r["due_date"],
            "completed": bool(r["completed"]),
        })

    return tasks


@app.post("/tasks")
def create_task(task: TaskCreate):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(
        "INSERT INTO tasks (title, due_date, completed) VALUES (?, ?, ?)",
        (task.title, task.due_date.isoformat(), int(task.completed)),)
    conn.commit()
    new_id = cur.lastrowid
    conn.close()

    return {"id": new_id, **task.model_dump()}

@app.patch("/tasks/{task_id}")
def update_task(task_id: int, task: TaskUpdate):
    conn = get_connection()
    cur = conn.cursor()

    # Checks if the path exists
    cur.execute("SELECT id FROM tasks WHERE id = ?", (task_id,))
    existing = cur.fetchone()

    if not existing:
        conn.close()
        return {"error": "Task not found"}

    # Build update dynamically
    fields = []
    values = []

    if task.title is not None:
        fields.append("title = ?")
        values.append(task.title)

    if task.due_date is not None:
        fields.append("due_date = ?")
        values.append(task.due_date.isoformat())

    if task.completed is not None:
        fields.append("completed = ?")
        values.append(int(task.completed))

    if fields:
        query = f"UPDATE tasks SET {', '.join(fields)} WHERE id = ?"
        values.append(task_id)
        cur.execute(query, tuple(values))
        conn.commit()

    conn.close()

    return {"message": "Task updated"}

@app.delete("/tasks/{task_id}")
def delete_task(task_id: int):
    conn = get_connection()
    cur = conn.cursor()

    # Check if task exists
    cur.execute("SELECT id FROM tasks WHERE id = ?", (task_id,))
    existing = cur.fetchone()

    if not existing:
        conn.close()
        raise HTTPException(status_code=404, detail="Task not found")

    # Delete
    cur.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
    conn.commit()
    conn.close()

    return {"message": f"Task {task_id} deleted"}

