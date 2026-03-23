# Taskly 📋

Taskly is a personal planner app that helps you stay on top of your tasks, appointments, and events. Think of it as a smart agenda on your phone — create tasks with due dates and times, set them to repeat, and view everything on a calendar. Simple and easy to use for students, professionals, and anyone who wants to stay organized.

---

## Software & Technologies Used

- **Flutter** (Dart) — Mobile and web frontend
- **Python + FastAPI** — Backend REST API
- **SQLAlchemy** — ORM for database management
- **PostgreSQL** — Database (hosted on Render)
- **bcrypt + python-jose** — Password hashing and JWT authentication
- **Render** — Cloud hosting for backend and database

---

## How to Run

**Backend**
```bash
cd backend
.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload
```

**Frontend**
```bash
cd frontend
flutter run -d chrome     # Web
flutter run               # Android emulator
```

> Before running locally, set `baseUrl` in `api_service.dart`:
> - Local Chrome: `http://127.0.0.1:8000`
> - Android emulator: `http://10.0.2.2:8000`
> - Deployed: `https://taskly-backend-qrjc.onrender.com`

---
