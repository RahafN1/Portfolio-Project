# Sprint 3 Planning (W9–W10)

## Sprint Details

- **Status:** Completed
- **Duration:** Weeks 9–10
- **Sprint Goal:** Deliver user profile management, completed trails tracking, interactive map updates with current user location using Geolocator, safety tips, trail sharing, admin user suspension, and final frontend/end-to-end testing.

## Planned Work

| Owner | Task | Branch | Acceptance Criteria |
|---|---|---|---|
| Frontend / Backend Owner | **US-16:** Completed Trails & User Trails Tracking | `feature/completed-trails`, `feature/my-trails` | Users can mark trails as completed and view their saved/completed trails in their profile |
| Frontend / Backend Owner | **US-17:** User Profile & Account Editing | `feature/profile` | Authenticated users can view and update their account details persistently |
| Frontend Owner | **US-18 & US-19:** Trail Safety Tips & Share Trail Link | `feature/trail-moredetails`, `develop` | Hiking safety guidelines are visible on trail pages and users can share trail links externally |
| Frontend Owner | **US-22:** Interactive Maps & Current User Location | `feature/maps-v2` | Maps display trail routes alongside the user's current location using the Geolocator package |
| Backend / Frontend Owner | Admin User Suspension & Management | `feature/admin-dashboard`, `feature/admin-api` | Admins can suspend violating user accounts and prevent suspended users from logging in |
| Team | Final End-to-End Testing & Bug Fixes | `feature/frontend-tests`, `fix` | Automated frontend tests pass, final bugs are resolved on `fix`, and release is merged |

## Dependencies and Risks

- Current user location (`feature/maps-v2`) requires proper permission handling.
- Final regression testing (`feature/frontend-tests`) and bug fixes (`fix`) must be completed before merging final release branches.

## Definition of Done

- Profile editing (`US-17`), completed trails (`US-16`), safety tips (`US-18`), sharing (`US-19`), current map location (`US-22`), and admin user suspension are verified.
- Frontend tests (`feature/frontend-tests`) pass and critical issues in `fix` are resolved.
- All branches are reviewed and merged into `develop` and `main`.
- Sprint 3 Retrospective (`Sprint 3 Retro`) and final documentation are finalized.
