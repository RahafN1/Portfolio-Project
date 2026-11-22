# Sprint 2 Review (W7–W8)

## Sprint Goal

Implement and demonstrate trail filtering and search with result counts, user reviews and ratings, favorites management, and admin permissions for managing trails and reviews.

## Completed Work

- Trail filtering by difficulty levels (Easy, Moderate, Hard) and Saudi regions (`US-05`) was implemented on `feature/trails-list`.
- Keyword search displaying matching trails along with total result counts (`US-08`) was implemented.
- Reading existing trail reviews and ratings (`US-09`, `feature/reviews`) and submitting new user reviews and star ratings (`US-12`, `feature/user-reviews`) were implemented.
- Trail favorites management (`feature/favorites`) was implemented for authenticated users.
- Admin backend APIs (`feature/admin-api`) and the admin dashboard (`feature/admin-dashboard`, `feature/reviews-and-admin`) were implemented for managing trails and moderating reviews.
- All Sprint 2 Pull Requests were reviewed and merged into `develop`.

## Demonstration

| Demonstrated Flow | Result |
|---|---|
| Filter trails by difficulty and region (`US-05`) | Completed |
| Search trails by keyword and verify displayed result counts (`US-08`) | Completed |
| Read existing trail reviews (`US-09`) and submit a new rating/review (`US-12`) | Completed |
| Add and remove trails from the user favorites list | Completed |
| Manage trails and moderate reviews via the admin dashboard | Completed |

## Incomplete or Deferred Work

- Completed trails tracking (`US-16`), profile editing (`US-17`), safety tips (`US-18`), trail link sharing (`US-19`), live map  location (`US-22`), and admin user suspension were scheduled for Sprint 3.

## Feedback

The team verified that search, filtering, reviews, and role-based access control between Guest, User, and Admin roles functioned as expected, and agreed to focus on extended profile features, interactive GPS maps, and final end-to-end testing in Sprint 3.
