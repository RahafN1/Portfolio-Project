# Sprint 3 Retrospective (W9–W10)

## What Went Well

- Implementing user profile editing (`US-17`, `feature/profile`) and completed trails tracking (`US-16`, `feature/completed-trails`, `feature/my-trails`) completed the personal hiker user experience.
- Interactive map enhancements showing the user's current GPS location (`US-22`, `feature/maps-v2`), safety tips (`US-18`), and trail sharing (`US-19`) worked reliably during on-device app testing.
- Implementing admin user account suspension (`feature/admin-dashboard`, `feature/admin-api`), alongside dedicated branches for bug fixes and testing (`fix`, `feature/frontend-tests`), improved final release stability.

## What Did Not Go Well

- Handling GPS location permissions (`feature/maps-v2`) across different mobile devices and simulators required extra edge-case handling, especially when users denied location access.
- Compressed regression testing and bug fixing (`fix`) reduced available schedule buffer during Week 10.

## Lessons Learned

- Device-dependent features, such as  location tracking and sharing via the native share sheet, should be tested early on physical devices rather than waiting until the final week.
- Dedicating a separate `fix` branch alongside automated frontend tests (`feature/frontend-tests`) helps reduce the risk of introducing new bugs or repeating past issues before final deployment.
- Creating a clear test plan that defines test levels, tools, and functional verification scenarios is essential to ensure core project requirements are covered.

## Improvement Actions

| Action | Owner | Due Sprint | Status |
|---|---|---|---|
| Prepare and document the test plan—including test levels, tools, and core test scenarios—in the Stage 4 Test Plan | Team | Final Submission | Completed |
| Perform full end-to-end testing to verify system functionality and User Stories from `US-01` to `US-22` | Team | Final Submission | Determined by test results |
