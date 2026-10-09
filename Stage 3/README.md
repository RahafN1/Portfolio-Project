## 0. User Stories

User stories for **Qimmah (قمة)**, a hiking-trails discovery app in Saudi Arabia, prioritized using the **MoSCoW** method.

**User types:**

* **Guest:** browses the app without an account.
* **Registered User:** has an account and can save, rate, and review trails.
* **Admin:** manages trails, reviews, and users.

### [🔴](https://fonts.gstatic.com/s/e/notoemoji/17.0/1f534/72.png) Must Have

| ID    | User Type               | User Story                                                                                                                                                                      |
| ----- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| US-01 | New User                | As a new user, I want to create an account with my email and password, so that I can save my activity and preferences.                                                          |
| US-02 | Registered User         | As a registered user, I want to log in and log out securely, so that my account stays protected.                                                                                |
| US-03 | Guest                   | As a guest, I want to browse trails without creating an account, so that I can explore the app before signing up.                                                               |
| US-04 | Guest / Registered User | As a guest or registered user, I want to browse a list of hiking trails in Saudi Arabia, so that I can discover new places to hike.                                             |
| US-05 | Guest / Registered User | As a guest or registered user, I want to filter trails by region and difficulty level, so that I can find trails that suit my location and fitness.                             |
| US-06 | Guest / Registered User | As a guest or registered user, I want to view a trail's details (distance, estimated duration, difficulty, description, and photos), so that I can decide if it's right for me. |
| US-07 | Guest / Registered User | As a guest or registered user, I want to see the trail's starting point on a map, so that I can know how to get there.                                                          |

### [🟠](https://fonts.gstatic.com/s/e/notoemoji/17.0/1f7e0/72.png) Should Have

| ID    | User Type               | User Story                                                                                                                                        |
| ----- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| US-08 | Guest / Registered User | As a guest or registered user, I want to search for a trail by name, so that I can quickly find a specific trail.                                 |
| US-09 | Guest / Registered User | As a guest or registered user, I want to read other users' reviews, so that I can get real feedback before going.                                 |
| US-10 | Guest                   | As a guest, I want to be prompted to sign up when I try to rate, review, or save a trail, so that I know an account is needed for these features. |
| US-11 | Registered User         | As a registered user, I want to save trails to my favorites, so that I can return to them later.                                                  |
| US-12 | Registered User         | As a registered user, I want to rate and review trails I've visited, so that I can share my experience with others.                               |
| US-13 | Registered User         | As a registered user, I want to edit or delete my own reviews, so that I can correct or remove what I wrote.                                      |
| US-14 | Admin                   | As an admin, I want to add, edit, and delete trails, so that the trail information stays accurate and up to date.                                 |
| US-15 | Admin                   | As an admin, I want to delete inappropriate reviews, so that the content stays respectful and useful.                                             |

### [🟡](https://fonts.gstatic.com/s/e/notoemoji/17.0/1f7e1/72.png) Could Have

| ID    | User Type               | User Story                                                                                                                                                                          |
| ----- | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| US-16 | Registered User         | As a registered user, I want to mark trails as completed, so that I can track my hiking history.                                                                                    |
| US-17 | Registered User         | As a registered user, I want to edit my account information, so that my profile stays up to date.                                                                                   |
| US-18 | Guest / Registered User | As a guest or registered user, I want to see safety tips for each trail, so that I can prepare properly before hiking.                                                              |
| US-19 | Guest / Registered User | As a guest or registered user, I want to share a trail link with friends, so that we can plan a hike together.                                                                      |
| US-20 | Guest / Registered User | As a guest or registered user, I want to switch the app language between Arabic and English, so that I can use it comfortably.                                                      |
| US-21 | Admin                   | As an admin, I want to suspend users who violate the rules, so that the community stays safe.                                                                                       |
| US-22 | Guest / Registered User | As a guest or registered user, I want to see my current location on the trail map, updated periodically while hiking, so that I can check whether I am following the correct route. |

### [⚪](https://fonts.gstatic.com/s/e/notoemoji/17.0/26aa/72.png) Won't Have (this version)

| ID    | User Type               | User Story                                                                                                                                                               |
| ----- | ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| US-23 | Guest / Registered User | As a guest or registered user, I want to see live weather conditions for the trail, so that I can plan my hike safely.                                                   |
| US-24 | Guest / Registered User | As a guest or registered user, I want to see an elevation profile of the trail, so that I can understand how steep and demanding it is.                                  |
| US-25 | Guest / Registered User | As a guest or registered user, I want to use offline maps and continuous background GPS tracking during the hike, so that I can navigate even without internet coverage. |

### Summary

| Priority    | Count  |
| ----------- | ------ |
| Must Have   | 7      |
| Should Have | 8      |
| Could Have  | 7      |
| Won't Have  | 3      |
| **Total**   | **25** |




<img width="1046" height="1028" alt="WhatsApp Image 2026-10-08 at 2 51 06 PM" src="https://github.com/user-attachments/assets/3faba557-fe05-4aca-a002-73cf3062031c" />



<img width="3200" height="3468" alt="Qimmah-design-guide" src="https://github.com/user-attachments/assets/aaef395c-24e4-48cc-aae4-052bd9f583f5" />



<img width="8000" height="3815" alt="Qimmah-user-flow" src="https://github.com/user-attachments/assets/1c6830f6-65a8-4f89-bc46-4dd99becccbb" />






# 1. System Architecture

## Overview

This document defines the high-level system architecture for **Qimmah (قمة)**, a mobile application for discovering officially approved hiking trails across Saudi Arabia.

The architecture follows a **layered model** — Presentation (Flutter), Business (Flask API), and Data (MySQL) — with integration to external third-party services for maps, image hosting, and email. The system supports three user roles: **Guest**, **Registered User**, and **Admin**.

## Architecture Diagram

<img width="1600" height="1600" alt="WhatsApp Image 2026-10-07 at 8 04 21 PM" src="https://github.com/user-attachments/assets/fcccc75f-1cb6-4611-850d-e678b49742da" />

> All app data flows through the Flask API. Maps and images load directly in the app. Dashed borders mark external services.

## Component Descriptions

| Component | Technology | Role |
|---|---|---|
| Frontend | Flutter (one app) | Renders the user interface in Arabic and English. Handles all hiker interactions: browsing, searching, filtering, trail details, the trail map, reviews, favorites, completed trails, and the profile. Shows a sign-up prompt when a guest tries to save, rate, or review. Communicates with the backend via REST API calls. |
| Admin Panel | Flutter (in-app) | Part of the same app, shown only to accounts with the `admin` role. Lets the admin add, edit, and delete trails, upload photos and GeoJSON routes, delete inappropriate reviews, and suspend users. |
| Backend | Flask (Python) on Railway | Processes all business logic: authentication, email verification, data validation, search and filtering, rating calculation, and communication between the frontend and the database. Exposes RESTful API endpoints organized into Flask Blueprints: Auth, Users, Trails, Reviews, and Admin. |
| ORM | SQLAlchemy | Maps Python classes (User, Trail, Review, Favorite, CompletedTrail) to MySQL tables and builds safe, parameterized SQL queries. |
| Database | MySQL on Railway | Stores all application data: users (including email verification data), trails, reviews, favorites, and completed trails. Uses relational tables with foreign key constraints to enforce data integrity, and utf8mb4 for Arabic text. Each trail's route is stored as GeoJSON in the `routeCoordinates` JSON column. |
| Auth Layer | JWT (Flask-JWT-Extended) | Manages stateless authentication. Issues tokens on login (valid for 24 hours) and verifies identity on protected routes. Supports 3 roles: Guest, Registered User, and Admin. Rejects suspended users on every request. Passwords and OTP codes are hashed with Werkzeug. |
| Email Verification | Resend Email API (backend) + pinput (app) | The backend sends a 6-digit OTP code to the user's email through the Resend API during sign-up, and the app displays the code input field with `pinput`. The account is activated after the correct code is entered. |
| Image Storage | Cloudinary | Stores and serves trail photos. Provides CDN delivery and automatic optimization. |
| Map Service | Google Maps SDK (google_maps_flutter) | Displays trails on the map, draws each trail's route with its start and end points, and shows the user's current location. |
| Device Location | geolocator | Reads the user's current location with permission, updated periodically while the app is open. The location stays on the device and is never sent to the server. |
| Language Switch | flutter_localizations | Switches the app interface between Arabic (right-to-left) and English. |
| Sharing | share_plus | Shares a trail through the device's share menu. |

## Data Flow

Steps describing how data moves through the system, covering the four key use cases defined in the sequence diagrams (Task 3):

### Use Case 1: User Login

| # | Step |
|---|---|
| 1 | The user enters their email and password on the Frontend (Flutter). |
| 2 | The frontend sends a login request to the Backend (Flask) over HTTPS. |
| 3 | The backend checks the user's credentials against MySQL. |
| 4 | MySQL returns the matching user record (password hash, role, `isVerified`, `isSuspended`) to the backend. |
| 5 | The backend verifies the password, and checks that the email is verified and the account is not suspended. |
| 6 | The backend returns an authentication response (JWT token and role) to the frontend. |
| 7 | The frontend stores the token securely and displays the home screen (with the admin panel if the role is `admin`), or an error message. If the email is not verified, it opens the verification screen, where the user enters the code with `pinput`. |

### Use Case 2: Browse, Search, and Filter Trails

| # | Step |
|---|---|
| 1 | The user (guest or registered) searches by name or selects a region and difficulty on the Frontend. |
| 2 | The frontend requests the matching trails from the Backend. |
| 3 | The backend queries MySQL for trails matching the search or filters. |
| 4 | MySQL returns the matching trails to the backend. |
| 5 | The backend sends a short summary of each trail, with its average rating, to the frontend as a JSON response. |
| 6 | The frontend renders the list of trails for the user. |
| 7 | Trail photos are fetched directly from Cloudinary via CDN URLs. |

### Use Case 3: View Trail Details and Current Location on the Map

| # | Step |
|---|---|
| 1 | The user taps a trail on the Frontend. |
| 2 | The frontend requests the trail's details from the Backend. |
| 3 | The backend queries MySQL for the trail's data and GeoJSON route. |
| 4 | The backend returns the trail details, route, start and end points, and safety tips to the frontend. |
| 5 | The frontend passes the route to Google Maps SDK, which draws it on the map with the start and end points. |
| 6 | If the user allows location access, the frontend reads their location with geolocator and updates it on the map periodically while the app is open. The location is not sent to the backend. |

### Use Case 4: Rate and Review a Trail

| # | Step |
|---|---|
| 1 | The user taps "Add your review" on the Frontend. If the user is a guest, the frontend prompts them to sign up. |
| 2 | The registered user selects a rating (1–5), writes a comment, and the frontend sends it to the Backend with the JWT. |
| 3 | The backend verifies the token and validates the rating and comment. |
| 4 | The backend saves the review in MySQL and calculates the trail's new average rating. |
| 5 | The backend returns the new review to the frontend, which displays it with the updated average rating. |

## Deployment Architecture

| Environment | Description |
|---|---|
| Development | Local machines — each developer runs the Flask API and MySQL locally, and runs the Flutter app on an emulator or device. |
| Staging | Pre-production environment on Railway with sample trail data, used for testing before release. |
| Production | The Flask API and MySQL database are deployed on Railway. The mobile app is distributed as an Android APK / iOS test build. Secret keys (database, JWT, Cloudinary, Resend) are stored as environment variables on Railway, never in the code. |

## Technical Justifications

Every technology in this architecture was chosen based on the team's functional requirements, non-functional requirements, and project constraints.

| Technology | Decision | Justification |
|---|---|---|
| Layered Architecture | Architecture Style | Each layer (Presentation, Business, Data) has one clear responsibility and communicates only with the layer below it. The team can work on layers in parallel, test business logic separately, and change one layer without rewriting the others. |
| Flutter | Frontend Framework | One codebase builds the Android and iOS app, which suits a small student team. The admin panel is part of the same app, so the team builds and maintains a single frontend. Flutter supports right-to-left (Arabic) and left-to-right (English) layouts, with official packages for Google Maps and localization. |
| Flask (Python) | Backend Framework | Builds on the team's Python foundation from the Holberton program. Flask is lightweight and well-suited for building RESTful APIs quickly, and Blueprints keep each module independent. |
| SQLAlchemy | ORM | Lets the team work with Python classes instead of raw SQL, and its parameterized queries protect against SQL injection. |
| MySQL | Database | A relational database was chosen over a non-relational one for Qimmah's core data model.<br><br>MySQL (relational — interconnected tables) enforces strong relationships between users, trails, reviews, favorites, and completed trails, and guarantees data integrity (e.g., a review cannot exist without a valid user and trail). Foreign key constraints prevent orphaned or invalid records.<br><br>MongoDB (non-relational — JSON documents) was considered but not selected, as it does not enforce relational integrity by default. MySQL's JSON column type still stores GeoJSON routes. |
| GeoJSON | Route Data Format | An open standard for geographic data. Routes recorded with GPS tools can be uploaded as files and drawn on the map without conversion. |
| JWT | Authentication | Stateless authentication eliminates the need for session management on the server. JWT tokens support role-based access control for 3 user types: Guest, Registered User, and Admin. Tokens expire after 24 hours, and logout removes the token from the device. |
| Email OTP (Resend + pinput) | Email Verification | Verifying the email at sign-up confirms the user owns the address and reduces fake accounts. Resend sends emails through an HTTPS API with an official Python SDK, which works on Railway (Railway blocks SMTP on non-Pro plans), and its free plan covers the MVP. `pinput` provides a clear 6-digit code input in the app. |
| Google Maps SDK | Map Service | Provides reliable map coverage of Saudi Arabia, route lines, and a built-in current-location layer, with an official Flutter package. |
| geolocator | Device Location | Reads the device location on Android and iOS with permission handling. Updating only while the app is open keeps the feature simple and saves battery. |
| Cloudinary | Image Hosting | Provides a free-tier CDN for image storage and delivery, with no credit card required. Photos are not lost when the server redeploys, and they are optimized automatically for mobile. |
| Railway | Hosting | Hosts both the Flask API and MySQL in one place, with simple deployment from GitHub and environment variables for secrets. |

## Non-Functional Requirements Addressed

| Requirement | How the Architecture Addresses It |
|---|---|
| Performance | Flutter compiles to native code for smooth scrolling and map interaction. Trail lists return short summaries, and full GeoJSON routes load only on the details screen. MySQL indexes on region, difficulty, and name speed up search and filtering. Cloudinary CDN reduces image load times. |
| Scalability | MySQL supports indexing and read replicas. The stateless JWT backend allows adding more Flask instances on Railway as usage grows. Location tracking runs on the device, so it adds no load to the server. |
| Security & Privacy | JWT ensures only authenticated users access protected routes, admin routes check the user's role, and suspended users are rejected on every request. Users can edit or delete only their own reviews. Emails are verified with OTP. HTTPS encrypts all client-server communication. Passwords and OTP codes are hashed using Werkzeug, and SQLAlchemy prevents SQL injection. The user's location is used only with permission and never leaves the device. |
| Maintainability | Separation of concerns: the presentation, business, and data layers are fully decoupled, and each layer can be updated independently. Flask Blueprints keep each backend module independent. |
| Usability | Arabic-first, right-to-left interface with simple navigation and an option to switch to English. Guests can browse all trails without an account, and are prompted to sign up only when they try to save, rate, or review. |
| Battery Efficiency | The location updates periodically and only while the app is open. |
