# Sprint 2 Retrospective (W7–W8)

## What Went Well

- Trail filtering by difficulty and region (`US-05`) and search with live result counts (`US-08`) significantly improved trail discovery.
- User reviews (`feature/reviews`, `feature/user-reviews`) and favorites (`feature/favorites`) integrated smoothly with existing trail details pages.
- Admin role permissions (`feature/admin-api`) and the admin dashboard (`feature/admin-dashboard`, `feature/reviews-and-admin`) cleanly separated moderator actions from regular users.

## What Did Not Go Well

- Synchronizing real-time average ratings after submitting a new review (`US-12`) required extra state-management adjustments.
- Testing role-based access boundaries across Guest, User, and Admin roles uncovered edge cases in route protection.

## Lessons Learned

- Role-based access control (RBAC) must be enforced on both backend endpoints and frontend UI components.
- State updates (such as review counts and favorites toggles) should refresh immediately without requiring a full page reload.

## Improvement Actions

| Action | Owner | Due Sprint | Status |
|---|---|---|---|
| Verify role permissions for Guest, User, and Admin on every new endpoint | Backend Owner | Sprint 3 | Completed |
| Add automated frontend widget/unit tests for core user flows | Frontend Owner | Sprint 3 | Completed |
