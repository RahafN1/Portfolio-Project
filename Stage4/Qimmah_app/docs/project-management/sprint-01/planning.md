# Sprint 1 Planning (W5–W6)

## Sprint Details

- **Status:** Completed
- **Duration:** Weeks 5–6
- **Sprint Goal:** Set up the development environment, establish the Git/GitHub workflow and project architecture, and implement core user authentication, guest browsing, and trail listing features.

## Planned Work

| Owner | Task | Branch | Acceptance Criteria |
|---|---|---|---|
| Team | Set up the development environment and project structure | Initial setup | Flutter/Dart environment, backend/database setup, and Git branching workflow (`main`, `develop`, `feature/*`) are configured |
| Frontend / Backend Owner | **US-01:** New User Registration | `feature/us01-user-registration` | New users can register an account with valid credentials and validation feedback |
| Frontend / Backend Owner | **US-02:** Registered User Login | `feature/us02-user-login` | Registered users can log in securely and maintain an authenticated session |
| Frontend Owner | **US-03:** Guest Browsing Mode | `feature/us03-guest-browsing` | Visitors can browse public trail content without creating an account |
| Frontend / Backend Owner | **US-04:** Trail Listing Display | `feature/us04-trail-listing` | Available hiking trails are fetched and displayed cleanly in the main trail list |
| Team | Review, test, and merge Sprint 1 features | Pull Request | All Sprint 1 User Stories pass acceptance checks and merge into `develop` |

## Dependencies and Risks

- Consistent Flutter SDK, dependencies, and environment configurations across all team members' devices.
- Authentication endpoints and database schemas had to be finalized early to support `US-01` and `US-02`.
- Ensuring clear access boundaries between authenticated users and guest users (`US-03`).

## Definition of Done

- Development environment and repository structure are fully operational for all team members.
- User registration (`US-01`), user login (`US-02`), guest browsing (`US-03`), and trail listing (`US-04`) are implemented and verified.
- Code is reviewed via Pull Requests and merged into `develop`.
- Sprint 1 Retrospective (`Sprint 1 Retro`) is documented.
