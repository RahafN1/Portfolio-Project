# Stage 2 Report – Project Charter

**Project:** Qimmah (قمة) – Saudi Hiking Trails Platform
**Team:** Sarah Alkhubaizy, Rahaf Alabdalh, Dhay Aldhuwyan, Zahraa Alhussain
**Stage:** 2 – Project Charter Development

---

## 1. Project Objectives

### 1.1 Project Purpose

Qimmah is a mobile application that brings together the hiking trails approved by the Saudi Climbing and Hiking Federation in one trusted place.

Hiking is growing quickly in Saudi Arabia, but trail information today is spread across social media, is often unverified, and rarely shows how hard a trail is. This makes it difficult for hikers, especially beginners, to choose a trail that is safe and suits their level. Qimmah solves this by showing only officially approved trails, with clear details for each one, so hikers can plan safer trips and the federation has a digital place to point hikers to.

### 1.2 SMART Objectives

1. **One trusted trail directory:** By the end of Week 10, deliver a working MVP that shows every approved trail received from the federation on a map of Saudi Arabia. Each trail will have its own page with difficulty, distance, elevation gain, estimated duration, and the approval badge.
2. **Fast and easy trail search:** By the end of Week 10, users can find a suitable trail by region and difficulty in 3 taps or fewer. We will confirm this by testing with at least 5 users in Week 10.
3. **Community feedback:** By the end of Week 10, signed-in users can rate trails (1–5 stars), write comments, and save trails to "My Trails", and the admin can add and edit trails and remove inappropriate comments. All of these features will pass the team's test checklist before the final presentation.

---

## 2. Stakeholders and Team Roles

### 2.1 Stakeholders

| Type | Stakeholder | Role / Interest |
|---|---|---|
| Internal | Project Team | Plans, designs, builds, tests, and documents Qimmah. |
| Internal | Mentors and Instructors (Holberton School) | Guide the team, review each stage, and evaluate the deliverables. |
| Internal | Admin (the team during the MVP) | Adds and edits trails and moderates comments. |
| External | Saudi Climbing and Hiking Federation | Provides the approved trail data and approves the use of its name and badge. |
| External | Beginner Hikers | Need to know which trails are easy and safe before they go. |
| External | Experienced Hikers | Look for new, challenging trails with accurate details. |
| External | Visitors and Tourists | Look for outdoor activities in different Saudi regions. |
| External | Map Provider (OpenStreetMap) | Provides the free map used to display the trails. |

### 2.2 Team Roles

As agreed in Stage 1, all team members work on both the Frontend and the Backend. Each member also leads one main area.

| Team Member | Role | Responsibilities |
|---|---|---|
| Rahaf Alabdalh | Project Manager | Plans tasks and deadlines, runs team meetings, tracks progress and risks, and manages communication with the federation. Also connects the app parts together and leads testing. |
| Sarah Alkhubaizy | Backend Developer – Trails & Data | Designs and builds the database. Owns everything about trails on the server: adding the official trail data, checking every trail before it is published, and making the trail list, region filter, and difficulty filter work. Keeps the README and stage documents up to date. |
| Dhay Aldhuwyan | UI/UX Designer & Frontend Developer | Designs the screens and user flows in Figma, creates the visual identity, and leads the app screens, the map, and the trail pages. |
| Zahraa Alhussain | Backend Developer – Users & Community | Owns everything about users on the server: sign-up and login, saved trails ("My Trails"), ratings, and comments. Builds the admin dashboard tools for managing trails and removing inappropriate comments. Writes the technical notes for these features. |

**Testing:** each member tests the features she builds, and Rahaf keeps a shared test checklist that the whole team reviews before each delivery.


---

## 3. Scope

### 3.1 Scope Overview

The MVP focuses only on approved hiking trails: helping users find a trail, understand it, and share feedback about it. It does not include trip booking or social features.

### 3.2 In-Scope (Included in MVP)

- Main map showing all approved trails in Saudi Arabia
- Filter trails by region (Asir, Madinah, Makkah, Tabuk, Riyadh, …)
- Filter trails by difficulty (Easy / Medium / Hard)
- Trail page with a map showing the start point, end point, and route
- Trail details: difficulty, distance (km), elevation gain, and estimated duration
- Trail description and tips
- "Approved by the Saudi Federation" badge on every trail
- Star ratings (1–5) with the average rating
- Comments
- "My Trails" page for saved trails
- Sign up and log in (required to save, rate, and comment)
- Admin dashboard to add and edit trails and moderate comments

### 3.3 Out-of-Scope (Excluded from MVP)

- Trip booking and online payments
- Social features (messages, followers, social feed)
- Users uploading their own trails
- Turn-by-turn voice navigation
- Selling or renting hiking gear

**Planned for later versions:** offline maps, GPX download, user-uploaded photos, live weather, and closed-trail alerts.

---

## 4. Risks

### 4.1 Risk Register

| # | Risk | Category | Stage | Likelihood | Impact | Trigger | Mitigation | Owner |
|---|---|---|---|---|---|---|---|---|
| 1 | The federation does not send the official trail data on time. | External / Data | Stages 2–4 (Weeks 2–10) | High | High | No reply from the federation by the end of Week 3. | Contact the federation early in Stage 2. Start building with a small set of sample trails so development is not blocked, and replace them with the official data once it arrives. | Rahaf |
| 2 | The federation does not allow us to use its name and logo. | External | Stages 2–3 (Weeks 2–4) | Medium | Medium | No approval for the logo by the end of Week 4. | Ask for permission early. If it is not given, use a neutral "Verified Trail" label without the logo. | Rahaf |
| 3 | Trail data contains mistakes (wrong start point or route). | Data | Stages 3–4 (Weeks 3–10) | Medium | High | A trail's route on the map does not match its official description. | Use official sources only, and check every trail on the map before adding it to the app. | Sarah |
| 4 | Showing routes on the map with an Arabic, right-to-left interface is harder than expected. | Technical | Stages 3–4 (Weeks 3–10) | Medium | Medium | The map test screen is not working by the end of Week 4. | Build a small test screen with the map early in Stage 3 to find problems before full development. | Dhay |
| 5 | Hikers have no phone signal on many trails. | Users | Stage 4 (Weeks 5–10) | High | Medium | Test users report that trail pages do not load outdoors. | Remind users inside the app to check trail details before leaving. Offline maps are planned for the next version. | Dhay |
| 6 | New feature ideas are added during development and delay the MVP. | Scope | Stages 3–4 (Weeks 3–10) | Medium | Medium | A task appears that is not in the In-Scope list. | Keep to the scope in this charter. Write any new idea in a "Later Versions" list instead of adding it now. | Rahaf |
| 7 | Study load and deadlines cause delays or an unbalanced workload. | Team | All stages (Weeks 1–12) | Medium | High | A task misses its deadline by more than 3 days. | Hold weekly Zoom meetings, share updates on WhatsApp, and move tasks between members quickly if someone falls behind. | Rahaf |
| 8 | Users post inappropriate comments. | Content | Stage 4 (Weeks 5–10) | Low | Medium | A comment is reported or found during testing. | Only signed-in users can comment, and the admin can hide or delete comments. | Zahraa |

### 4.2 Risk Priority

| Priority | Risks |
|---|---|
| 🔴 High | 1, 3, 7 |
| 🟡 Medium | 2, 4, 5, 6 |
| 🟢 Low | 8 |

---

## 5. High-Level Plan

### 5.1 Timeline (12 Weeks)

<img width="1890" height="861" alt="qimmah-timeline-v2" src="https://github.com/user-attachments/assets/0647b2d0-ac9b-4b16-8fae-8080ec8a34db" />



| Stage | Weeks | Key Deliverable |
|---|---|---|
| Stage 1 – Team Formation & Idea Development | Week 1 | Stage 1 Report (Completed) |
| Stage 2 – Project Charter Development | Week 2 | Project Charter |
| Stage 3 – Technical Documentation | Weeks 3–4 | Technical documents and Figma screens |
| Stage 4 – MVP Development & Execution | Weeks 5–10 | Working, tested MVP |
| Stage 5 – Project Closure | Weeks 11–12 | Final presentation and closure report |

### 5.2 Key Milestones and Dependencies

| # | Milestone | Key Deliverables | Stage | Target | Depends On |
|---|---|---|---|---|---|
| M1 | Idea approved | Stage 1 Report with the selected idea and team roles | Stage 1 | End of Week 1 | None |
| M2 | Project Charter approved | This document: objectives, stakeholders, scope, risks, and plan | Stage 2 | End of Week 2 | M1 |
| M3 | Technical documentation finalized | App structure, database plan, Figma screens, and first trail data | Stage 3 | End of Week 4 | M2, and trail data from the federation (or sample trails) |
| M4 | Core features working | Map, filters, trail pages, sign up and login, ratings, comments, My Trails, admin dashboard | Stage 4 | End of Week 9 | M3 |
| M5 | MVP tested | All features tested with the team checklist and at least 5 users, and main bugs fixed | Stage 4 | End of Week 10 | M4 |
| M6 | Project closed | Final presentation, code on GitHub, and Stage 5 closure report | Stage 5 | End of Week 12 | M5 |

---

*Report prepared by: Sarah Alkhubaizy, Rahaf Alabdalh, Dhay Aldhuwyan, Zahraa Alhussain*
*Stage 2 – Portfolio Project | Holberton School*
