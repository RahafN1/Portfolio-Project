# Sprint 1 Review (W5–W6)

## Sprint Goal

Set up the project foundation and Git workflow, and build and demonstrate core user authentication, guest browsing, and trail listing/details features for the Qimmah app.

## Completed Work

- Project folder structure (`feature/project-structure`) and Git branching workflow (`main`, `develop`, and feature branches) were established.
- Home navigation bar (`feature/home-navbar`) and language switcher (`feature/language-switch`) were implemented.
- User registration with OTP verification (`US-01`, `feature/signup-otp`), user login (`US-02`), and password recovery (`feature/forgot-password-and-frontend-tests`) were implemented.
- Trail seed data (`feature/trails-seed-data`), trail details API endpoint (`feature/trail-details-endpoint`), and Cloudinary trail images (`feature/trail-images-cloudinary`) were integrated.
- Guest browsing mode (`US-03`), trail listing (`US-04`, `feature/trails-list`), and trail details pages (`feature/trail-details-page`, `feature/trail-moredetails`) were implemented.
- All Sprint 1 Pull Requests were reviewed and merged into `develop`.

## Demonstration

| Demonstrated Flow | Result |
|---|---|
| Register a new account with OTP (`US-01`) and log in (`US-02`) | Completed |
| Browse public hiking trails in guest mode (`US-03`) | Completed |
| View the main trail list (`US-04`) and open trail details pages | Completed |
| Switch application language and navigate via the home navbar | Completed |
| Load trail images hosted on Cloudinary | Completed |

## Incomplete or Deferred Work

- Trail filtering, keyword search with result counts, reviews, ratings, favorites, and admin moderation were scheduled for Sprint 2.
- User profile editing, completed trails tracking, safety tips, link sharing, live map GPS location, and user suspension were scheduled for Sprint 3.

## Feedback

The team confirmed that the core authentication, guest access, and trail browsing flows were working reliably and agreed to prioritize trail filtering, search, user reviews, and admin moderation in Sprint 2.
