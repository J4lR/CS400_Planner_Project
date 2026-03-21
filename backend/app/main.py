from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel, Field, field_validator
from datetime import date
from sqlalchemy.orm import Session
from app.db import init_db, get_db
from typing import Optional
from app.models import Task, User
from app.auth import hash_password, verify_password, create_token, decode_token
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer

app = FastAPI()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class TaskCreate(BaseModel):
    title: str = Field(..., min_length=1)
    due_date: date
    completed: bool = False
    category: str = "task"
    description: Optional[str] = None
    repeats: bool = False

    @field_validator("title")
    @classmethod
    def title_not_blank(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("Title cannot be empty")
        return v

    @field_validator("category")
    @classmethod
    def category_must_be_valid(cls, v: str) -> str:
        allowed = ["task", "homework", "payment", "meeting", "appointment", "misc"]
        if v not in allowed:
            raise ValueError(f"Category must be one of: {allowed}")
        return v


class TaskUpdate(BaseModel):
    title: Optional[str] = None
    due_date: Optional[date] = None
    completed: Optional[bool] = None
    category: Optional[str] = None
    description: Optional[str] = None
    repeats: Optional[bool] = None

    @field_validator("title")
    @classmethod
    def title_not_blank_if_present(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return v
        v = v.strip()
        if not v:
            raise ValueError("Title cannot be empty")
        return v

    @field_validator("category")
    @classmethod
    def category_must_be_valid(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return v
        allowed = ["task", "homework", "payment", "meeting", "appointment", "misc"]
        if v not in allowed:
            raise ValueError(f"Category must be one of: {allowed}")
        return v

class UserCreate(BaseModel):
    username: str = Field(..., min_length=1)
    email: str = Field(..., min_length=1)
    password: str = Field(..., min_length=6)

class UserLogin(BaseModel):
    username: str
    password: str


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    payload = decode_token(token)
    if payload is None:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    user_id = payload.get("user_id")
    if user_id is None:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
    
    return user


@app.on_event("startup")
def on_startup():
    init_db()


@app.get("/")
def root():
    return {"message": "Backend is running"}


@app.get("/tasks")
def get_tasks(
    category: Optional[str] = None,
    filter: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    query = db.query(Task).filter(Task.user_id == current_user.id)

    if category:
        query = query.filter(Task.category == category)

    if filter == "today":
        today = date.today().isoformat()
        query = query.filter(Task.due_date == today)
    elif filter == "upcoming":
        today = date.today().isoformat()
        query = query.filter(Task.due_date > today)
    elif filter == "completed":
        query = query.filter(Task.completed == True)

    tasks = query.order_by(Task.due_date.asc()).all()
    return tasks


@app.post("/tasks")
def create_task(task: TaskCreate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    new_task = Task(
        title=task.title,
        due_date=task.due_date.isoformat(),
        completed=task.completed,
        category=task.category,
        description=task.description,
        repeats=task.repeats,
        user_id=current_user.id
    )
    db.add(new_task)
    db.commit()
    db.refresh(new_task)
    return new_task


@app.patch("/tasks/{task_id}")
def update_task(task_id: int, task: TaskUpdate, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    existing = db.query(Task).filter(Task.id == task_id, Task.user_id == current_user.id).first()

    if not existing:
        raise HTTPException(status_code=404, detail="Task not found")

    if task.title is not None:
        existing.title = task.title
    if task.due_date is not None:
        existing.due_date = task.due_date.isoformat()
    if task.completed is not None:
        existing.completed = task.completed
    if task.category is not None:
        existing.category = task.category
    if task.description is not None:
        existing.description = task.description
    if task.repeats is not None:
        existing.repeats = task.repeats

    db.commit()
    db.refresh(existing)
    return existing


@app.delete("/tasks/{task_id}")
def delete_task(task_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    existing = db.query(Task).filter(Task.id == task_id, Task.user_id == current_user.id).first()

    if not existing:
        raise HTTPException(status_code=404, detail="Task not found")

    db.delete(existing)
    db.commit()
    return {"message": f"Task {task_id} deleted"}


@app.post("/register")
def register(user: UserCreate, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.username == user.username).first()
    if existing:
        raise HTTPException(status_code=400, detail="Username already taken")
    
    new_user = User(
        username=user.username,
        email=user.email,
        password=hash_password(user.password)
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return {"message": f"User {new_user.username} created successfully"}


@app.post("/login")
def login(user: UserLogin, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.username == user.username).first()
    
    if not existing:
        raise HTTPException(status_code=401, detail="Invalid username or password")
    
    if not verify_password(user.password, existing.password):
        raise HTTPException(status_code=401, detail="Invalid username or password")
    
    token = create_token({"user_id": existing.id})
    return {"access_token": token, "token_type": "bearer", "username": existing.username}