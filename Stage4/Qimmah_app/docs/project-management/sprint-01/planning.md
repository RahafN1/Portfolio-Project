# Sprint 1 Planning (W5–W6)

## Sprint Details

- **Status:** Completed
- **Duration:** Weeks 5–6
- **Sprint Goal:** Set up the development environment and project structure, configure Git workflows, and implement core user authentication, navigation, trail seed data, and trail listing/details views.

## Planned Work

| Owner | Task | Branch | Acceptance Criteria |
|---|---|---|---|
| Team | Set up project structure, environment, and Git branching workflow | `feature/project-structure` | Folder architecture, dependencies, and `main`/`develop` workflow are established |
| Frontend / Backend Owner | Build home navigation bar and language switcher | `feature/home-navbar`, `feature/language-switch` | Users can navigate core screens and switch app language smoothly |
| Frontend / Backend Owner | **US-01 & US-02:** User Registration (OTP), Login, and Password Recovery | `feature/signup-otp`, `feature/forgot-password-and-frontend-tests` | Users can register with OTP verification, log in, and reset forgotten passwords |
| Backend Owner | Prepare initial trail seed data and trail details API endpoint | `feature/trails-seed-data`, `feature/trail-details-endpoint` | Trail records are seeded in the database and accessible via API endpoints |
| Frontend / Backend Owner | **US-03 & US-04:** Guest Browsing, Trail List, Trail Details & Images | `feature/trails-list`, `feature/trail-details-page`, `feature/trail-moredetails`, `feature/trail-images-cloudinary` | Guests and users can browse trails, view full trail details, and load Cloudinary-hosted trail images |
| Team | Review and merge Sprint 1 features | Pull Request -> `develop` | All Sprint 1 branches are reviewed and merged into `develop` |

## Dependencies and Risks

- Consistent environment setup and Cloudinary image configuration across team members' machines.
- Backend seed data (`feature/trails-seed-data`) and endpoints (`feature/trail-details-endpoint`) had to be ready before binding the trail list and details UI.
- Ensuring smooth navigation for both guest visitors (`US-03`) and authenticated users (`US-01`, `US-02`).

## Definition of Done

- Project structure, environment, and Git workflow (`develop` & feature branches) are operational.
- Registration (`US-01`), login (`US-02`), guest browsing (`US-03`), trail listing (`US-04`), and trail details pages are implemented.
- All Sprint 1 feature branches are reviewed via Pull Requests and merged into `develop`.
- Sprint 1 Retrospective (`Sprint 1 Retro`) is documented.
