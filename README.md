# 🐚 Menta-Ray — Gamified 2D Learning Platform

> A Flutter-based gamified educational app for children featuring **Mathematical Quizzing** and **Indian Sign Language (ISL)** learning with **LLM (Gemini API)** integration.

---

## 📖 Table of Contents

- [About the Project](#about)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [System Architecture](#system-architecture)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Project Structure](#project-structure)
- [Modules](#modules)
- [Environment Variables](#environment-variables)
- [Database Setup](#database-setup)
- [API Endpoints](#api-endpoints)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [Team](#team)
- [License](#license)

---
<a name="about"></a>
## 🫧 About the Project

**Menta-Ray** transforms passive screen time into meaningful educational engagement for children under 12. Built with an underwater pixel-art theme, the platform combines:

- Curriculum-aligned **Math quizzing** with adaptive difficulty powered by Google Gemini LLM
- **Indian Sign Language (ISL)** alphabet learning through an interactive matching game
- Game mechanics like hearts, scores, leaderboards, and a progression map
- **Offline-first** architecture so learning is never interrupted

This project was developed as a final-year B.E. Computer Science project at **Avinashilingam Institute for Home Science and Higher Education for Women, Coimbatore**.

---

## 🪼 Features

- ⋆ JWT-based secure authentication (Login / Signup)
- ⋆ Math module with Easy / Medium / Hard difficulty levels
- ⋆ ISL alphabet learning with animated pixel-art hand signs
- ⋆ LLM-powered dynamic question generation via Gemini API
- ⋆ Offline fallback with local question banks
- ⋆ Leaderboard and progress tracking
- ⋆ Parent/teacher analytics dashboard
- ⋆ Underwater 2D game world with mascot and quest board

---

## 🪸 Tech Stack

| Layer        | Technology                          |
|--------------|-------------------------------------|
| Frontend     | Flutter (Dart), Flame Game Engine   |
| Backend      | Java, Spring Boot                   |
| Database     | MySQL                               |
| AI / LLM     | Google Gemini API (via Python)      |
| Auth         | JWT (JSON Web Token)                |
| UI Assets    | Aseprite (pixel art)                |
| IDE          | VS Code, IntelliJ IDEA              |
| State Mgmt   | Provider (Flutter)                  |

---

## ⛵ System Architecture

```
User Device (Android / Windows)
        │
        ▼
  FLAME Engine (Flutter)
  ├── Gaming Layer
  └── Services Layer
        │
        ▼
  Spring Boot Backend
  ├── Authentication (JWT)
  └── Business Logic
        │         │
        ▼         ▼
  MySQL DB    Gemini API
  ├── Player    ├── api_services
  ├── Progress  └── LLM (Question Gen)
  └── Login
```

---

## 🗺️ Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>= 3.x)
- [Java JDK 17+](https://www.oracle.com/java/technologies/downloads/)
- [MySQL 8.x](https://dev.mysql.com/downloads/)
- [Python 3.10+](https://www.python.org/) (for LLM service)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/) (for backend)
- [Android Studio](https://developer.android.com/studio) or a physical Android device
- A valid **Google Gemini API key**

---

### Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/your-username/menta-ray.git
cd menta-ray
```

#### 2. Flutter Frontend Setup

```bash
cd frontend
flutter pub get
```

#### 3. Spring Boot Backend Setup

```bash
cd backend
# Open in IntelliJ IDEA or run via Maven
./mvnw install
```

#### 4. Python LLM Service Setup

```bash
cd llm-service
pip install -r requirements.txt
```

#### 5. MySQL Database Setup

```sql
CREATE DATABASE mentaray;
USE mentaray;
-- Run the schema file
SOURCE db/schema.sql;
```

---

### Running the App

#### Start the Backend (Spring Boot)

```bash
cd backend
./mvnw spring-boot:run
```

> Backend runs on `http://localhost:8080` by default.

#### Start the LLM Service (Python / Streamlit)

```bash
cd llm-service
streamlit run app.py
# or
python api_service.py
```

#### Run the Flutter App

```bash
cd frontend
flutter run
```

> For a specific device:
> ```bash
> flutter run -d <device_id>
> ```
> List available devices: `flutter devices`

---

## 🦪 Project Structure

```
menta-ray/
│
├── frontend/                   # Flutter application
│   ├── lib/
│   │   ├── main.dart           # App entry point
│   │   ├── gaming/
│   │   │   ├── math_directive.dart
│   │   │   ├── math_game.dart
│   │   │   └── isl_game.dart
│   │   ├── services/
│   │   │   ├── auth_provider.dart
│   │   │   ├── player_provider.dart
│   │   │   ├── progress_provider.dart
│   │   │   └── api_service.dart     # Gemini API calls
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       └── signup_screen.dart
│   ├── assets/
│   │   ├── images/             # Pixel art sprites
│   │   └── sounds/             # Audio files
│   └── pubspec.yaml
│
├── backend/                    # Spring Boot application
│   ├── src/main/java/
│   │   └── com/mentaray/
│   │       ├── controller/
│   │       ├── service/
│   │       ├── model/
│   │       └── config/         # CORS, JWT config
│   └── pom.xml
│
├── llm-service/                # Python LLM integration
│   ├── api_service.py
│   ├── app.py
│   └── requirements.txt
│
├── db/
│   └── schema.sql              # MySQL schema
│
└── README.md
```

---

## 🦈 Modules

### Module 1 — User Interface
- Pixel-art login and signup screens
- Landscape orientation locked
- SharedPreferences for "Remember Me"
- `MultiProvider` for AuthProvider, PlayerProvider, ProgressProvider

### Module 2 — Backend Integration
- Spring Boot + Flutter communication via RESTful APIs
- CORS configured for localhost development
- JWT authentication with role-based access (USER / ADMIN)
- Progress and player state persisted in MySQL

### Module 3 — Math Module
- Quest board with subject and difficulty selection (Easy / Medium / Hard)
- Questions dynamically generated by Gemini LLM
- Structured JSON response: question, options, answer
- Offline fallback to local question banks
- Life system (hearts) and score tracking

### Module 4 — ISL Module
- ISL alphabet matching game (sign image → letter)
- Animated pixel-art hand signs
- Timer, score, and life system
- Dataset: 35 directories, ~42.7k images

---

## ⚓ Environment Variables

Create a `.env` file (or set in `application.properties`):

```env
# Backend (application.properties)
spring.datasource.url=jdbc:mysql://localhost:3306/mentaray
spring.datasource.username=your_db_user
spring.datasource.password=your_db_password
jwt.secret=your_jwt_secret_key

# LLM Service (.env)
GEMINI_API_KEY=your_google_gemini_api_key
```

In `api_service.dart` (Flutter), update the base URL:

```dart
const String baseUrl = "http://10.0.2.2:8080"; // Android emulator
// or
const String baseUrl = "http://localhost:8080"; // Desktop
```

---

## 🐳 Database Setup

```sql
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'USER'
);

CREATE TABLE player_progress (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    subject VARCHAR(50),
    difficulty VARCHAR(20),
    score INT DEFAULT 0,
    completed_levels INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE player_state (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNIQUE,
    coins INT DEFAULT 0,
    hearts INT DEFAULT 3,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## 🪸 API Endpoints

| Method | Endpoint                  | Description                  |
|--------|---------------------------|------------------------------|
| POST   | `/api/auth/register`      | Register a new user          |
| POST   | `/api/auth/login`         | Login and get JWT token      |
| GET    | `/api/player/{id}`        | Get player state             |
| PUT    | `/api/player/{id}/update` | Update score / hearts        |
| GET    | `/api/progress/{userId}`  | Get full progress report     |
| POST   | `/api/progress/save`      | Save level completion data   |
| GET    | `/api/leaderboard`        | Get top 10 leaderboard       |

---

## 📸 Screenshots

| Login | Quest Board |
|-------|-------------|
| ![Login](assets/screenshots/login.png) | ![Quest](assets/screenshots/quest.png) |

| Math Quiz | ISL Module |
|-----------|------------|
| ![Math](assets/screenshots/math.png) | ![ISL](assets/screenshots/isl.png) |


---
## 🐙 Team

| Name | GitHub Profile | Role / Focus |
| :--- | :--- | :--- |
| **Jeni Cyndrella Yazhini R** | [@jeni](https://github.com/) | LLM Integration and Database |
| **Lakshika Mangai S** | [@lakshika](https://github.com/Lakshika-mangai) | Spring Boot & SQL  |
| **Sherlyn Samuel** | [@sherlyn-samuel](https://github.com/sherlyn-samuel) | Frontend flutter & SQL |
| **Vibhasha R** | [@vibhasha](https://github.com/vibhasharg) | Design & Game Mechanics |

**Project Guide:** Dr. D. Nithya M.E., Ph.D., Associate Professor, CSE  
**Institution:** Avinashilingam Institute for Home Science and Higher Education for Women, Coimbatore

---

## 🏅 Publication

**"Redesigning Digital Habits in Early Adolescents through Gamification"**  
*Second International Conference on Engineering, Science and Management (ICESM-2026)*  
🥇 **Won Best Paper Presentation Award (UG Category)**

---

## 📄 License

This project is submitted in partial fulfilment of the requirements for the degree of Bachelor of Engineering in Computer Science and Engineering. All rights reserved © 2026.
