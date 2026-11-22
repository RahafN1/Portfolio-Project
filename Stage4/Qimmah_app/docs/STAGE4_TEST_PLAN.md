# Stage 4 Test Plan

## Objectives

- Verify Must Have user flows.
- Prevent regressions when feature branches are merged.
- Validate authentication and role authorization.
- Confirm frontend, backend, database, and image upload integration.

## Test Levels

| Level | Tool | Owner | Purpose |
|---|---|---|---|
| Static checks | `flutter analyze` | Frontend owner | Catch code-quality problems in the Flutter app |
| Backend API tests | pytest | Backend owner | Test Flask endpoints and errors |
| Manual API tests | Swagger | Backend owners and reviewer | Verify contracts and collect evidence |
| Integration tests | Flutter app with the API and the database | QA / Team | Verify complete user flows end to end |
| Acceptance testing | Mobile app and production environment | Team | Confirm sprint and release criteria |

## Critical Test Flows

1. Register with email OTP, Login, and Logout.
2. Guest restrictions and protected routes.
3. Browse, search, and filter trails, then view trail details and the map.
4. Add and remove favorites and completed trails.
5. Create, edit, and delete a review.
6. Edit the profile and change the password.
7. Perform authorized Admin operations.
8. Switch the app language between Arabic and English.

## Pull Request Quality Gate

- [ ] Acceptance criteria are satisfied.
- [ ] `flutter analyze` passes for frontend changes.
- [ ] The app builds.
- [ ] Relevant pytest tests pass for backend changes.
- [ ] Swagger evidence is provided for API changes.
- [ ] No secrets are committed.
- [ ] Documentation is updated.
- [ ] At least one approving review is recorded.
