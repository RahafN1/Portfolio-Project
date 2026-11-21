# Qimmah (قمة) – Stage 4

Stage 4 delivers the working Qimmah application: Flutter mobile frontend, Flask API, MySQL database, authentication with email OTP, trails browsing, favorites, completed trails, reviews, an admin interface, image upload, bilingual (Arabic / English) trail data, seed data, and testing documentation.

This README is organised by feature to give a clear overview of the project's structure, implementation, routing, and testing.

## Table of Contents

1. [Current Status](#current-status)
2. [Project Delivery Evidence](#project-delivery-evidence)
3. [Tech Stack](#tech-stack)
4. [Production Environment](#production-environment)
5. [Run the Project](#run-the-project)
6. [Project Structure](#project-structure)
7. [Feature Documentation](#feature-documentation)
8. [Testing and Quality](#testing-and-quality)
9. [Project Management Links](#project-management-links)

## Current Status

| Area | Status | Notes |
|---|---|---|
| Flutter UI screens | Done | Splash, login, sign-up, OTP, explore, trail details, map, my trails, profile |
| Database and authentication | Done | MySQL, SQLAlchemy, JWT, email OTP, role-based access |
| Trails APIs | Done | List, details, search |
| Favorites and completed trails | Done | Per-user saved and completed trails |
| Reviews | Done | Create, view, edit, and delete reviews |
| Admin interface | Done | Inside the mobile app, add and edit trails, moderate users and reviews |
| Image upload | Done | Cloudinary |
| Bilingual data | Done | Arabic columns plus `_en` columns in the Trail model |
| Seed data | Done | Trail data and trail routes (GeoJSON) |
| Testing documentation | Done | 130 automated pytest tests, Swagger checks, manual end-to-end checks |

## Project Delivery Evidence

| Evidence | Documentation |
| --- | --- |
| Sprint planning | [Sprint 1](docs/project-management/sprint-01/planning.md) · [Sprint 2](docs/project-management/sprint-02/planning.md) · [Sprint 3](docs/project-management/sprint-03/planning.md) |
| Sprint reviews | [Sprint 1](docs/project-management/sprint-01/review.md) · [Sprint 2](docs/project-management/sprint-02/review.md) · [Sprint 3](docs/project-management/sprint-03/review.md) |
| Retrospectives | [Sprint 1](docs/project-management/sprint-01/retrospective.md) · [Sprint 2](docs/project-management/sprint-02/retrospective.md) · [Sprint 3](docs/project-management/sprint-03/retrospective.md) |
| Source repository | [Portfolio-Project](https://github.com/RahafN1/Portfolio-Project) · TODO add pull requests link · TODO add develop history link |
| Bug tracking | TODO add bug process link · TODO add GitHub Issues link |
| Testing evidence and results | [Test plan](https://github.com/RahafN1/Portfolio-Project/blob/develop/Stage4/Qimmah_app/docs/STAGE4_TEST_PLAN.md) · [Backend automated tests](#backend-automated-tests-pytest) · [Swagger checks](#api-testing-with-swagger) · TODO add GitHub Actions link |
| Production environment | [API health](https://portfolio-project-production-d5d7.up.railway.app/api/health) · [Swagger](https://portfolio-project-production-d5d7.up.railway.app/apidocs/) · TODO add frontend link |

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (MVVM, feature-first folder structure), Google Maps SDK, geolocator, pinput |
| Backend | Python, Flask, JWT |
| Database | MySQL, SQLAlchemy, Flask-Migrate |
| Email | Resend (OTP emails, sent from the team domain) |
| Uploads | Cloudinary |
| Testing | pytest (Resend and Cloudinary mocked), Swagger for manual API testing, manual end-to-end testing |
| Dev tools | Docker, Git (main / develop / feature branches), GitHub |
| Hosting | Backend on Railway, database on Aiven, Flutter web on Vercel |

## Production Environment

| Service | Where it runs |
|---|---|
| Backend API (base URL) | Railway: https://portfolio-project-production-d5d7.up.railway.app (no page at the root; use the Swagger page or the health check below) |
| Database | MySQL hosted on Aiven |
| Frontend (Flutter web) | Vercel: TODO add link |
| API documentation (Swagger) | https://portfolio-project-production-d5d7.up.railway.app/apidocs/ |
| API health check | https://portfolio-project-production-d5d7.up.railway.app/api/health |

Secrets (database credentials, JWT secret, Resend and Cloudinary keys) are stored in environment variables and are never committed to the repository.

## Run the Project

### Backend

```bash
cd Stage4/Qimmah_app/backend

# create and activate a virtual environment
python -m venv .venv
.venv\Scripts\activate        # Windows
source .venv/bin/activate     # Mac / Linux

# install dependencies
pip install -r requirements.txt
```

Create a `.env` file inside `backend/` with the required variables (database, JWT secret, Resend, Cloudinary). Never commit this file.

Apply the database migrations, then start the API:

```bash
flask db upgrade
python run.py
```

Run the backend with Docker:

```bash
cd Stage4/Qimmah_app/backend
docker build -t qimmah-backend .
```

### Frontend

```bash
cd Stage4/Qimmah_app/mobile
flutter pub get
flutter run
```

### Seed the database

Seed scripts are in `backend/seed/` (trail data in `trails.sql`, route files in `seed/raw/` and `seed/routes/`).

Useful URLs:

| Service | URL |
|---|---|
| Swagger (production) | https://portfolio-project-production-d5d7.up.railway.app/apidocs/ |
| Health check (production) | https://portfolio-project-production-d5d7.up.railway.app/api/health |

## Project Structure

### Backend

```
Stage4/Qimmah_app/backend
|-- app/
|   |-- models/
|   |-- routes/
|   |-- services/
|   |-- utils/
|   |-- blocklist.py
|   |-- config.py
|   |-- errors.py
|   |-- extensions.py
|   `-- __init__.py
|-- migrations/
|   `-- versions/
|-- seed/
|   |-- raw/
|   `-- routes/
|-- tests/
|-- Dockerfile
|-- .dockerignore
|-- requirements.txt
|-- setup.cfg
|-- run.py
`-- mock_server.py
```

### Frontend

Flutter app with an MVVM, feature-first structure. Each feature has `data` (repository), `models`, `viewmodels`, and `views` (screens and widgets).

```
Stage4/Qimmah_app/mobile/lib
|-- core/
|   |-- constants/
|   |-- locale/
|   |-- network/
|   |-- routing/
|   |-- services/
|   |-- storage/
|   |-- theme/
|   |-- utils/
|   `-- widgets/
|-- features/
|   |-- admin/
|   |   |-- data/
|   |   |-- models/
|   |   |-- viewmodels/
|   |   `-- views/
|   |       `-- widgets/
|   |-- auth/
|   |   |-- data/
|   |   |-- models/
|   |   |-- viewmodels/
|   |   `-- views/
|   |       `-- widgets/
|   |-- favorites/
|   |   |-- data/
|   |   |-- models/
|   |   |-- viewmodels/
|   |   `-- views/
|   |       `-- widgets/
|   |-- profile/
|   |   |-- data/
|   |   |-- viewmodels/
|   |   `-- views/
|   |-- reviews/
|   |   |-- data/
|   |   |-- models/
|   |   |-- viewmodels/
|   |   `-- views/
|   |       `-- widgets/
|   |-- splash/
|   |   `-- views/
|   `-- trails/
|       |-- data/
|       |-- models/
|       |-- utils/
|       |-- viewmodels/
|       `-- views/
|           `-- widgets/
|-- l10n/
|-- app.dart
`-- main.dart
```

## Feature Documentation

### Authentication and Role Access

**Purpose:** Signs users up with email OTP verification, logs users in and out, and protects routes by role (guest, user, admin).

**Key Files**

| Area | Important Files |
|---|---|
| Backend routes and logic | `backend/app/routes/auth.py`, `backend/app/models/user.py`, `backend/app/services/email_service.py` |
| Backend protection | `backend/app/utils/decorators.py` |
| Tests | `backend/tests/test_auth.py`, `test_auth_errors.py`, `test_logout.py` |

**API Routes**

| Method | Route | Access | Purpose |
|---|---|---|---|
| POST | `/api/auth/register` | Public | Sign up and send a verification code to the user's email |
| POST | `/api/auth/verify-email` | Public | Verify the code, activate the account, and return JWT |
| POST | `/api/auth/resend-code` | Public | Send a new verification code |
| POST | `/api/auth/login` | Public | Log in and return JWT |
| POST | `/api/auth/logout` | Authenticated | Log out (the token is revoked) |
| POST | `/api/auth/change-password` | Authenticated | Change the password |

**Validation and Business Rules**

| Validation or Rule | Details |
|---|---|
| Email verification | Sign-up requires an OTP code sent by email through Resend |
| Password rules | Must include uppercase, lowercase, and a digit, with a minimum and maximum length |
| Guest role | Guests can browse only; they cannot save, complete, comment, or rate |
| Admin accounts | No sign-up for admins; the admin account is created in the database and logs in from the same login screen |
| Logout | The token is added to a blocklist on the server, so it cannot be used again, and it is deleted on the device |
| Suspension | `isSuspended` is checked on every protected request |
| Errors | Unified error shape `{"error": "..."}` with the project's HTTP status codes |

**Test Results**

| Test | Expected Result | Status |
|---|---|---|
| Register with valid data | Account created and OTP email sent | Pass |
| Register with missing name, invalid email, or short password | Validation error returned | Pass |
| Register with password missing uppercase, lowercase, or digit, or too long | Validation error returned | Pass |
| Register with an already verified email | Error returned | Pass |
| Register with an unverified email again | Code is sent again | Pass |
| Register when the email service fails | Error returned | Pass |
| Verify with a wrong code | Error returned | Pass |
| Verify with an expired code | Error returned | Pass |
| Verify after too many attempts | Request blocked | Pass |
| Verify with an unknown email | Error returned | Pass |
| Resend code | A new code is sent | Pass |
| Resend code too soon, for a verified email, or for an unknown email | Error returned | Pass |
| Login with a valid account | JWT returned | Pass |
| Login with a wrong password or unknown email | Error returned | Pass |
| Login with an unverified account | Request blocked | Pass |
| Login with a suspended account | Request blocked | Pass |
| Access a protected route without a token | Request blocked | Pass |
| Access a protected route with an invalid token | Request blocked | Pass |
| Use a token after the user is suspended | Request blocked | Pass |
| Change password with the correct current password | Password changed, old password stops working | Pass |
| Change password without a token | Request blocked | Pass |
| Change password with a wrong current password | Error returned | Pass |
| Change password with a weak new password | Validation error returned | Pass |
| Change password to the same password | Error returned | Pass |
| Logout with a valid token | User logged out | Pass |
| Use the token after logout | Request blocked | Pass |

### Trails

**Purpose:** Lets visitors discover Saudi hiking trails: list, details, search, and map markers.

**Key Files**

| Area | Important Files |
|---|---|
| Backend | `backend/app/routes/trails.py`, `backend/app/services/trail_service.py`, `backend/app/models/trail.py` |
| Tests | `backend/tests/test_trails.py` |

**API Routes**

| Method | Route | Access | Purpose |
|---|---|---|---|
| GET | `/api/trails` | Public | List trails (summary only) with search, filters, and pagination |
| GET | `/api/trails/{trail_id}` | Public | Full trail details (route, start and end points) |

Query parameters of `GET /api/trails` (all optional):

| Parameter | Purpose |
|---|---|
| `search` | Search by trail name |
| `region` | Filter by region |
| `difficulty` | Filter by difficulty |
| `page` | Page number (default 1) |
| `limit` | Items per page (default 20) |
| `lang` | Response language, `ar` (default) or `en` |

`GET /api/trails/{trail_id}` also accepts `lang`.

**Validation and Business Rules**

| Validation or Rule | Details |
|---|---|
| Bilingual data | Arabic columns plus `_en` columns (name, description, region, estimated duration, safety tips) |
| Trail routes | Stored as GeoJSON in a MySQL JSON column |
| Difficulty filter | Invalid difficulty value returns 400 |
| User location | Stays on the device and is never sent to the API |
| Search | Debounced on the frontend before the request is sent |

**Test Results**

| Test | Expected Result | Status |
|---|---|---|
| List trails | Trail summaries returned with the summary fields only | Pass |
| List trails as a guest without a token | Trails list returned | Pass |
| Filter by difficulty | Only trails with that difficulty returned | Pass |
| Filter by an invalid difficulty | 400 error returned | Pass |
| Open trail details | Full details, start point, and route returned | Pass |
| Open a trail id that does not exist | 404 error returned | Pass |
| Search by trail name (`?search=...`) | Trails matching the name returned | TODO |
| Filter by region (`?region=...`) | Only trails from that region returned | TODO |
| Pagination (`?page=...&limit=...`) | Correct page returned | TODO |
| Language switch (`?lang=en`) | Trail data returned in English | TODO |

### Favorites

**Purpose:** Lets signed-in users save trails to their favorites and view them in My Trails.

**Key Files**

| Area | Important Files |
|---|---|
| Backend | `backend/app/models/favorite.py`, `backend/app/routes/users.py` |
| Tests | `backend/tests/test_favorites.py` |

**API Routes**

| Method | Route | Access | Purpose |
|---|---|---|---|
| GET | `/api/users/me/favorites` | Authenticated | List saved trails, newest first |
| POST | `/api/users/me/favorites` | Authenticated | Save a trail |
| DELETE | `/api/users/me/favorites/{trail_id}` | Authenticated | Remove a saved trail |

**Validation and Business Rules**

| Validation or Rule | Details |
|---|---|
| Guests | Tapping save shows a sign-in sheet |
| Ownership | Users see only their own favorites |
| Button | Save button is debounced on the frontend |

**Test Results**

| Test | Expected Result | Status |
|---|---|---|
| Access favorites without a token | Request blocked | Pass |
| Save a trail | Trail saved | Pass |
| Save a trail that does not exist | Error returned | Pass |
| Save the same trail twice | Error returned | Pass |
| Save with an invalid id | Validation error returned | Pass |
| List favorites | Saved trails returned | Pass |
| List favorites of another user | Only the logged-in user's favorites returned | Pass |
| Remove a saved trail | Trail removed | Pass |
| Remove a trail that is not saved | Error returned | Pass |

### Completed Trails

**Purpose:** Lets signed-in users mark trails as completed and view them in My Trails.

**Key Files**

| Area | Important Files |
|---|---|
| Backend | `backend/app/models/completed_trail.py`, `backend/app/routes/users.py` |
| Tests | `backend/tests/test_completed_trails.py` |

**API Routes**

| Method | Route | Access | Purpose |
|---|---|---|---|
| GET | `/api/users/me/completed-trails` | Authenticated | List completed trails, newest first |
| POST | `/api/users/me/completed-trails` | Authenticated | Mark a trail as completed |
| DELETE | `/api/users/me/completed-trails/{trail_id}` | Authenticated | Remove a trail from the completed list |

**Validation and Business Rules**

| Validation or Rule | Details |
|---|---|
| Completion | Users mark a trail as completed manually |
| Ownership | Users see only their own completed trails |
| Button | Complete button is debounced on the frontend |

**Test Results**

| Test | Expected Result | Status |
|---|---|---|
| Access completed trails without a token | Request blocked | Pass |
| Mark a trail as completed | Trail marked | Pass |
| Mark a trail that does not exist | Error returned | Pass |
| Mark the same trail twice | Error returned | Pass |
| Mark with an invalid id | Validation error returned | Pass |
| List completed trails | Completed trails returned | Pass |
| List completed trails of another user | Only the logged-in user's trails returned | Pass |
| Remove a completed trail | Trail removed | Pass |
| Remove a trail that is not completed | Error returned | Pass |

### Reviews

**Purpose:** Lets signed-in users rate and comment on trails, and lets everyone read reviews.

**Key Files**

| Area | Important Files |
|---|---|
| Backend | `backend/app/routes/reviews.py`, `backend/app/services/review_service.py`, `backend/app/models/review.py` |
| Tests | `backend/tests/test_reviews.py` |

**API Routes**

| Method | Route | Access | Purpose |
|---|---|---|---|
| POST | `/api/trails/{trail_id}/reviews` | Authenticated | Add a review to a trail |
| GET | `/api/trails/{trail_id}/reviews` | Public | A trail's reviews with the average rating |
| PUT | `/api/reviews/{review_id}` | Authenticated | Edit your own review |
| DELETE | `/api/reviews/{review_id}` | Authenticated | Delete your own review |
| GET | `/api/users/me/reviews` | Authenticated | My reviews, newest first |

**Validation and Business Rules**

| Validation or Rule | Details |
|---|---|
| Guests | Guests can read reviews but cannot comment or rate |
| Rating | Rating must be a valid value (0, 6, and negative values are rejected) |
| Comment | Empty comments are rejected |
| Ownership | Users can edit and delete only their own reviews |
| Average rating | Calculated from the trail's reviews |

**Test Results**

| Test | Expected Result | Status |
|---|---|---|
| Add a review without a token | Request blocked | Pass |
| Add a valid review | Review saved | Pass |
| Add a review to a trail that does not exist | Error returned | Pass |
| Add a review with an invalid rating (0, 6, -1) | Validation error returned | Pass |
| Add a review with an empty comment | Validation error returned | Pass |
| Read reviews without a token | Reviews returned | Pass |
| Read reviews of a trail that does not exist | Error returned | Pass |
| Read reviews with user data and average rating | Reviews returned with the average rating | Pass |
| Read reviews with pagination | Correct page returned | Pass |
| Edit a review without a token | Request blocked | Pass |
| Edit my own review | Review updated | Pass |
| Edit another user's review | Request blocked | Pass |
| Edit a review that does not exist | Error returned | Pass |
| Edit with an empty body or invalid rating | Validation error returned | Pass |
| Delete a review without a token | Request blocked | Pass |
| Delete my own review | Review deleted | Pass |
| Delete another user's review | Request blocked | Pass |
| Delete a review that does not exist | Error returned | Pass |
| View my reviews without a token | Request blocked | Pass |
| View my reviews | My reviews returned | Pass |
| View my reviews when other users have reviews | Only my reviews returned | Pass |
| Trail average rating | Average calculated correctly | Pass |

### Profile

**Purpose:** Shows the user's profile and lets them edit their data.

**Key Files**

| Area | Important Files |
|---|---|
| Backend | `backend/app/routes/users.py`, `backend/app/models/user.py` |
| Tests | `backend/tests/test_users.py`, `backend/tests/test_auth.py` |

**API Routes**

| Method | Route | Access | Purpose |
|---|---|---|---|
| GET | `/api/users/me` | Authenticated | My profile |
| PUT | `/api/users/me` | Authenticated | Edit my name (the email cannot be changed) |

**Validation and Business Rules**

| Validation or Rule | Details |
|---|---|
| Editable data | Only the name can be changed |
| Email | The email cannot be changed |

**Test Results**

| Test | Expected Result | Status |
|---|---|---|
| Get my profile with a valid token | Profile returned | Pass |
| Get my profile without a token | Request blocked | Pass |
| Update my name | Name updated | Pass |
| Update my name without a token | Request blocked | Pass |
| Try to change my email | Email stays unchanged | Pass |

### Admin Interface and Image Upload

**Purpose:** Gives the admin tools inside the mobile app to add and edit trails, moderate users and reviews, and upload images through Cloudinary.

**Key Files**

| Area | Important Files |
|---|---|
| Backend | `backend/app/routes/admin.py`, `backend/app/models/admin.py`, `backend/app/services/cloudinary_service.py` |
| Tests | `backend/tests/test_admin.py` |

**API Routes**

| Method | Route | Access | Purpose |
|---|---|---|---|
| POST | `/api/admin/trails` | Admin | Add a trail |
| PUT | `/api/admin/trails/{trail_id}` | Admin | Edit a trail |
| DELETE | `/api/admin/trails/{trail_id}` | Admin | Delete a trail |
| POST | `/api/admin/trails/{trail_id}/images` | Admin | Upload trail images (multipart) |
| PUT | `/api/admin/trails/{trail_id}/route` | Admin | Replace the trail route |
| DELETE | `/api/admin/reviews/{review_id}` | Admin | Delete any review |
| PATCH | `/api/admin/users/{user_id}/suspend` | Admin | Suspend a user |
| PATCH | `/api/admin/users/{user_id}/unsuspend` | Admin | Unsuspend a user |
| GET | `/api/admin/stats` | Admin | Dashboard statistics |
| GET | `/api/admin/users` | Admin | List users (page, limit) |
| GET | `/api/admin/reviews` | Admin | List reviews (page, limit) |

**Validation and Business Rules**

| Validation or Rule | Details |
|---|---|
| Admin only | Non-admin users are blocked from admin routes |
| Required fields | Trail creation requires the trail fields and a valid difficulty |
| Route format | The route must be valid GeoJSON |
| User moderation | Admin can suspend and unsuspend users and delete any review |
| Self suspension | An admin cannot suspend their own account |
| Admin interface | Lives inside the mobile app, not a separate web dashboard |
| Image upload | Flutter sends the picked images as multipart; the backend uploads them to Cloudinary |

**Test Results**

| Test | Expected Result | Status |
|---|---|---|
| Admin adds a trail | Trail created | Pass |
| Add a trail without a token | Request blocked | Pass |
| Add a trail as a normal user | Request blocked | Pass |
| Add a trail with missing fields or a bad difficulty | Validation error returned | Pass |
| Admin updates a trail | Trail updated | Pass |
| Update a trail with a bad difficulty | Validation error returned | Pass |
| Update a trail that does not exist | Error returned | Pass |
| Update a trail as a normal user | Request blocked | Pass |
| Admin deletes a trail | Trail deleted | Pass |
| Delete a trail that does not exist | Error returned | Pass |
| Delete a trail as a normal user | Request blocked | Pass |
| Admin uploads trail images (Cloudinary mocked) | Images saved | Pass |
| Upload images that are not a list or an empty list | Validation error returned | Pass |
| Upload images to a trail that does not exist | Error returned | Pass |
| Admin updates a trail route | Route updated | Pass |
| Update a trail route with invalid GeoJSON | Validation error returned | Pass |
| Update the route of a trail that does not exist | Error returned | Pass |
| Admin deletes any review | Review deleted | Pass |
| Delete a review that does not exist | Error returned | Pass |
| Delete a review as a normal user | Request blocked | Pass |
| Admin suspends a user | User suspended | Pass |
| Admin suspends their own account | Error returned | Pass |
| Suspend a user that does not exist | Error returned | Pass |
| Suspend a user as a normal user | Request blocked | Pass |
| Suspended user uses an old token | Request blocked | Pass |
| Admin unsuspends a user | User unsuspended | Pass |
| Unsuspended user uses the token again | Access restored | Pass |
| Unsuspend a user that does not exist | Error returned | Pass |
| Unsuspend a user as a normal user | Request blocked | Pass |
| Admin opens statistics | Statistics returned | Pass |
| Open statistics without a token | Request blocked | Pass |
| Open statistics as a normal user | Request blocked | Pass |
| Admin lists users | Users returned with page and total | Pass |
| Admin lists users with pagination | Correct page returned | Pass |
| List users as a normal user | Request blocked | Pass |
| Admin lists reviews | Reviews returned with page and total | Pass |
| List reviews as a normal user | Request blocked | Pass |
| Upload real images to Cloudinary from the app | Images appear on the trail | Pass |

### Seed Data and Migrations

**Purpose:** Gives repeatable trail data and database changes instead of manual edits.

**Key Files**

| Area | Important Files |
|---|---|
| Migrations | `backend/migrations/versions/` (Flask-Migrate) |
| Seed scripts | `backend/seed/` (`seed_routes.py`, `trails.sql`, `add_english_step1.py`, `add_english_step2.py`) |
| Trail routes | `backend/seed/raw/` and `backend/seed/routes/` (GeoJSON) |

**Test Results**

| Test | Expected Result | Status |
|---|---|---|
| Run `flask db upgrade` on an empty database | All tables created | TODO |
| Load the seed data | Trails and routes inserted | TODO |
| Open the app after seeding | Seeded trails appear in the Explore page | TODO |

### Health and Error Handling

**Purpose:** Confirms the API is running and returns consistent errors.

**Key Files**

| Area | Important Files |
|---|---|
| Health | `backend/app/routes/health.py` |
| Errors | `backend/app/errors.py` |
| Tests | `backend/tests/test_health.py` |

**API Routes**

| Method | Route | Access | Purpose |
|---|---|---|---|
| GET | `/api/health` | Public | API health check, returns `{"status": "ok"}` |

**Test Results**

| Test | Expected Result | Status |
|---|---|---|
| Call `/api/health` | `{"status": "ok"}` returned | Pass |
| Open a route that does not exist | Not found error returned | TODO |
| Open `/api/health` on the production URL | `{"status": "ok"}` returned | TODO |

## Testing and Quality

| Document | Purpose |
|---|---|
| [Test plan](https://github.com/RahafN1/Portfolio-Project/blob/develop/Stage4/Qimmah_app/docs/STAGE4_TEST_PLAN.md) | Overall testing approach and coverage |
| [Backend automated tests](https://github.com/RahafN1/Portfolio-Project/tree/develop/Stage4/Qimmah_app/backend/tests) | 130 pytest tests in `backend/tests/` with Resend and Cloudinary mocked |
| [Swagger API documentation](https://portfolio-project-production-d5d7.up.railway.app/apidocs/) | Interactive page used to try and verify endpoints manually |
| [Manual end-to-end tests](#manual-end-to-end-tests-flutter-app--api--database) | Testing the Flutter app together with the API and the database |
| [Bug tracking](https://github.com/RahafN1/Portfolio-Project/issues) | GitHub Issues |

### Backend automated tests (pytest)

Latest run: 130 passed.

| File | Tests | Covers |
|---|---|---|
| `test_auth.py` | 4 | Register, login, protected profile, change password |
| `test_auth_errors.py` | 32 | Validation, OTP errors, login errors, token errors, password rules |
| `test_logout.py` | 2 | Logout and token revocation |
| `test_trails.py` | 6 | Trails list, difficulty filter, details, not found |
| `test_favorites.py` | 9 | Favorites |
| `test_completed_trails.py` | 9 | Completed trails |
| `test_reviews.py` | 25 | Reviews |
| `test_users.py` | 3 | Profile update |
| `test_admin.py` | 39 | Admin trails, images, routes, reviews, suspension, stats, lists |
| `test_health.py` | 1 | Health check |

Run the backend tests:

```bash
cd Stage4/Qimmah_app/backend
pytest -v
```

### API testing with Swagger

We used Swagger to verify the production API manually.

| Swagger page | Link |
|---|---|
| Production (Railway) | https://portfolio-project-production-d5d7.up.railway.app/apidocs/ |

How to test an endpoint:

1. Open the Swagger page.
2. For protected endpoints, log in to get a token, click the Authorize button, and enter `Bearer` followed by a space and the token.
3. Choose an endpoint and click Try it out.
4. Fill in the request body or parameters, then click Execute.
5. Check the status code and the response body against the expected result.

Swagger test results on production:

| Area | Test | Expected Result | Status |
|---|---|---|---|
| Health | `GET /api/health` | `{"status": "ok"}` returned | Pass |
| Auth | `POST /api/auth/logout` with a valid token | User logged out and the token is revoked | Pass |
| Trails | `GET /api/trails` as a guest | Trails list returned | Pass |
| Trails | `GET /api/trails?search=...` | Trails matching the name returned | Pass |
| Trails | `GET /api/trails?region=...` | Only trails from that region returned | Pass |
| Trails | `GET /api/trails?difficulty=...` | Only trails with that difficulty returned | Pass |
| Trails | `GET /api/trails?page=...&limit=...` | Correct page returned | Pass |
| Trails | `GET /api/trails?lang=en` | Trail data returned in English | Pass |
| Trails | `GET /api/trails/{trail_id}` as a guest | Full trail details returned | Pass |
| Users | `GET /api/users/me` | My profile returned | Pass |
| Users | `PUT /api/users/me` with a new name | Name updated | Pass |
| Favorites | `POST /api/users/me/favorites` | Trail saved | Pass |
| Favorites | `GET /api/users/me/favorites` | Saved trails returned | Pass |
| Favorites | `DELETE /api/users/me/favorites/{trail_id}` | Trail removed | Pass |
| Completed trails | `POST /api/users/me/completed-trails` | Trail marked as completed | Pass |
| Completed trails | `GET /api/users/me/completed-trails` | Completed trails returned | Pass |
| Completed trails | `DELETE /api/users/me/completed-trails/{trail_id}` | Trail removed from the list | Pass |
| Reviews | `POST /api/trails/{trail_id}/reviews` | Review saved | Pass |
| Reviews | `GET /api/trails/{trail_id}/reviews` | Reviews returned with the average rating | Pass |
| Reviews | `PUT /api/reviews/{review_id}` on my own review | Review updated | Pass |
| Reviews | `DELETE /api/reviews/{review_id}` on my own review | Review deleted | Pass |
| Reviews | `GET /api/users/me/reviews` | My reviews returned | Pass |
| Admin | `POST /api/admin/trails` as admin | Trail created | Pass |
| Admin | `PUT /api/admin/trails/{trail_id}` as admin | Trail updated | Pass |
| Admin | `DELETE /api/admin/trails/{trail_id}` as admin | Trail deleted | Pass |
| Admin | `POST /api/admin/trails/{trail_id}/images` as admin | Images uploaded to Cloudinary | Pass |
| Admin | `PUT /api/admin/trails/{trail_id}/route` as admin | Route updated | Pass |
| Admin | `DELETE /api/admin/reviews/{review_id}` as admin | Review deleted | Pass |
| Admin | `PATCH /api/admin/users/{user_id}/suspend` as admin | User suspended | Pass |
| Admin | `PATCH /api/admin/users/{user_id}/unsuspend` as admin | User unsuspended | Pass |
| Admin | `GET /api/admin/stats` as admin | Statistics returned | Pass |
| Admin | `GET /api/admin/users` as admin | Users returned with page and total | Pass |
| Admin | `GET /api/admin/reviews` as admin | Reviews returned with page and total | Pass |
| Admin | Call any admin endpoint as a normal user | Request blocked | Pass |

Sign-up, email verification, resend code, login, and change password are not listed on the Swagger page. They are covered by the pytest tests and by the manual end-to-end tests below.

### Manual end-to-end tests (Flutter app + API + database)

| Test | Expected Result | Status |
|---|---|---|
| Open the app as a guest and browse trails | Trails list and details open | Pass |
| Guest taps save or complete | Sign-in sheet appears | Pass |
| Sign up and enter the OTP code | Account created, then the login page opens | Pass |
| Log in as a user | Explore page opens | Pass |
| Search for a trail | Matching trails appear | Pass |
| Save a trail to favorites | Trail appears in My Trails (saved) | Pass |
| Mark a trail as completed | Trail appears in My Trails (completed) | Pass |
| Add a review | Review appears on the trail page | Pass |
| Open the map | Trail markers and location permission sheet appear | Pass |
| Edit profile data | Changes are saved | Pass |
| Switch language between Arabic and English | UI and trail data change language | Pass |
| Log in with the admin email | Admin page opens | Pass |
| Admin adds a trail with images | Trail appears in the app with its images | Pass |
| Log out | Returns to the guest state | Pass |
## Project Management Links

| Resource | Link |
|---|---|
| GitHub repository | [Portfolio-Project](https://github.com/RahafN1/Portfolio-Project) |
| Pull requests | [TODO add link](https://github.com/RahafN1/Portfolio-Project/pulls
) |
| Issues |https://github.com/RahafN1/Portfolio-Project/issues |
| Bug tracker | TODO add link |
| Project board | TODO add link |

Sprint documentation:

| Sprint | Planning | Review | Retrospective |
|---|---|---|---|
| Sprint 1 | TODO | TODO | TODO |
| Sprint 2 | TODO | TODO | TODO |
