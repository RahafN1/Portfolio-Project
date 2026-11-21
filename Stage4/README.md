# Qimmah | قمّة

**Discover Saudi Arabia's hiking trails.** Qimmah is a mobile app that helps hikers explore, track and review trails across Saudi Arabia, in Arabic and English.

> Stage 4 – MVP Development and Execution

---

## Production Environment

| | Link |
|---|---|
| API (Railway) | https://portfolio-project-production-d5d7.up.railway.app |
| API docs (Swagger) | https://portfolio-project-production-d5d7.up.railway.app/apidocs/ |
| Mobile app | <link to APK / TestFlight / demo video> |

---

## MVP Features

- **Accounts:** register with email OTP verification, login, logout, change password, forgot/reset password.
- **Trails:** browse, search and filter by region and difficulty, with pagination.
- **Trail details and map:** route, start/end points, and live route tracking using the device location.
- **My trails:** favorites and completed trails.
- **Reviews:** write, edit and delete reviews and ratings.
- **Profile:** edit name, language (Arabic / English) and theme (light / dark).
- **Guest mode:** browse trails without an account.
- **Admin dashboard:** statistics, manage users, trails and reviews.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (MVVM, Provider) |
| Backend | Flask, SQLAlchemy, Flask-Migrate (Alembic), JWT |
| Database | MySQL |
| Services | Resend (email OTP), Cloudinary (images) |
| API docs | Swagger (Flasgger) |
| DevOps | Docker Compose, Railway |
| Testing | pytest, flake8, flutter analyze |

---

## Project Structure

```
Qimmah_app/
├── backend/        # Flask API (routes, services, models, migrations, tests, seed data)
├── mobile/         # Flutter app (features: auth, trails, favorites, reviews, profile, admin)
├── docs/           # Test plan and project documents
├── docker-compose.yml
└── .env.example
```

---

## Getting Started

### Backend

```bash
cp .env.example .env          # fill in the values
docker compose up --build     # API on http://localhost:5000, MySQL on port 3307
docker compose exec api flask db upgrade
```

### Run the backend tests

```bash
cd backend
pip install -r requirements.txt
python -m pytest tests -q
```

### Mobile app

```bash
cd mobile
flutter pub get
flutter run
```

The API address is set in `mobile/lib/core/constants/api_endpoints.dart`.

---

## Team and Roles

| Name | Role |
|---|---|
| Rahaf Alabdalh | <role> |
| Sarah Alkhubaizy | <role> |
| Dhay Aldhwayan | <role> |
| Zahraa Ali Alhussain | <role> |

(Project Manager, Source Control Manager, QA, and developers.)

---

## Stage 4 Deliverables

| Deliverable | Link |
|---|---|
| Sprint planning | <link> |
| Sprint reviews | <link> |
| Retrospectives | <link> |
| Source repository | https://github.com/RahafN1/Portfolio-Project |
| Bug tracking | <link to GitHub Issues / Trello / Jira board> |
| Testing evidence and results | See [Testing](#testing) |
| Production environment | See [Production Environment](#production-environment) |

---

## Agile Process

- **Sprints:** <number of sprints and their length>, planned at the start of each sprint with goals, task owners and deadlines.
- **Daily stand-ups:** <where, e.g. Discord>.
- **Code reviews:** every pull request into `develop` is reviewed by the SCM and needs at least one approval.
- **QA:** completed tasks are tested before merging, following the test plan.
- **Branching:** feature branches → `develop` → `main`.

---

## Testing

The full plan is in [docs/STAGE4_TEST_PLAN.md](docs/STAGE4_TEST_PLAN.md).

- **Backend:** over 130 automated pytest tests covering authentication, users, trails, favorites, completed trails, reviews and admin endpoints, including error cases.
- **Static checks:** `flake8` for the backend and `flutter analyze` for the mobile app.
- **Manual API testing:** Swagger (`/apidocs/`).
- **Integration and acceptance:** the critical flows listed in the test plan, run on the mobile app against the production API.

Evidence: <screenshots / test run output / link to CI run>

---

## Known Issues and Next Steps

  ### Known limitations
      - **Offline support:** the app needs an internet connection to load trails.
  ### Next steps
      - Add more trails and regions across Saudi Arabia.
