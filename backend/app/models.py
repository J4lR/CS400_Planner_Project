from sqlalchemy import Column, Integer, String, Boolean
from sqlalchemy.orm import DeclarativeBase

class Base(DeclarativeBase):
    pass

class Task(Base):
    __tablename__ = "tasks"

    id = Column(Integer, primary_key=True, autoincrement=True)
    title = Column(String, nullable=False)
    due_date = Column(String, nullable=False)
    completed = Column(Boolean, default=False)
    category = Column(String, default="task")
    description = Column(String, nullable=True)
    repeats = Column(Boolean, default=False)
    user_id = Column(Integer, nullable=True)
    priority = Column(String, default="medium")


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, autoincrement=True)
    username = Column(String, nullable=False, unique=True)
    email = Column(String, nullable=False, unique=True)
    password = Column(String, nullable=False)