# Sprint 1 Retrospective (W5–W6)

## What Went Well

- The project folder structure (`feature/project-structure`) and Git branching workflow (`develop` and feature branches) were established early.
- Core authentication flows including OTP registration (`feature/signup-otp`) and password recovery (`feature/forgot-password-and-frontend-tests`) were implemented smoothly.
- Trail seed data (`feature/trails-seed-data`), Cloudinary image hosting (`feature/trail-images-cloudinary`), and trail listing/details pages (`US-03`, `US-04`) worked together cleanly.
- Early setup of home navigation (`feature/home-navbar`) and bilingual support (`feature/language-switch`) kept the UI consistent across screens.

## What Did Not Go Well

- Initial environment and Flutter/Android emulator configurations took extra time across team members' machines.
- Some feature branches fell behind `develop`, causing minor merge conflicts during integration.
- Frontend trail views initially depended on mock data until `feature/trail-details-endpoint` was ready.

## Lessons Learned

- Always pull and rebase/merge the latest `develop` branch into feature branches before opening a Pull Request.
- Finalize backend API response structures early before connecting frontend screens.
- Keep environment keys (such as Cloudinary and database credentials) standardized in a shared `.env.example` file.

## Improvement Actions

| Action | Owner | Due Sprint | Status |
|---|---|---|---|
| Pull `develop` before creating or merging any Pull Request | Team | Sprint 2 | Completed |
| Define backend API contracts prior to frontend integration | Backend & Frontend Owners | Sprint 2 | Completed |
| Require at least one peer review before merging into `develop` | Team | Sprint 2 | Completed |
