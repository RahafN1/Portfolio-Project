# Sprint 2 Planning (W7–W8)

## Sprint Details

- **Status:** Completed
- **Duration:** Weeks 7–8
- **Sprint Goal:** Implement trail filtering and search with result counts, user reviews and ratings, favorites management, and admin dashboard/API permissions for managing trails and reviews.

## Planned Work

| Owner | Task | Branch | Acceptance Criteria |
|---|---|---|---|
| Frontend / Backend Owner | **US-05 & US-08:** Trail Filtering (Difficulty & Region) and Search Results Count | `feature/trails-list`, `develop` | Filter buttons (Easy, Moderate, Hard, and regions) and search bar display accurate matching trails and result counts |
| Frontend / Backend Owner | **US-09 & US-12:** Read Trail Reviews and Submit Ratings/Reviews | `feature/reviews`, `feature/user-reviews` | Users can view existing reviews and submit new star ratings and comments on trails |
| Frontend / Backend Owner | Trail Favorites Management | `feature/favorites` | Authenticated users can add and remove trails from their favorites list |
| Backend Owner | Admin Backend APIs & Role Permissions | `feature/admin-api` | Role-based access control restricts admin actions and exposes endpoints for managing trails and reviews |
| Frontend / Backend Owner | Admin Dashboard & Moderation Controls | `feature/admin-dashboard`, `feature/reviews-and-admin` | Admins can manage trails and moderate user reviews through the admin dashboard |
| Team | Review and merge Sprint 2 features | Pull Request -> `develop` | All Sprint 2 User Stories pass testing and merge into `develop` |

## Dependencies and Risks

- Admin UI (`feature/admin-dashboard`) depended on backend role authorization (`feature/admin-api`).
- Synchronizing submitted reviews (`feature/user-reviews`) with average trail ratings and review lists (`feature/reviews`).
- Enforcing strict access control between regular users, guests, and administrators.

## Definition of Done

- Filtering (`US-05`), search result counts (`US-08`), reading/writing reviews (`US-09`, `US-12`), favorites (`feature/favorites`), and admin moderation (`feature/admin-dashboard`, `feature/admin-api`) are functional.
- All Sprint 2 Pull Requests are reviewed and merged into `develop`.
- Sprint 2 Retrospective (`Sprint 2 Retro`) is completed.
