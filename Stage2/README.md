# Stage 2 – Project Charter Document

**Project:** Qimmah (قمة) – Certified Saudi Hiking Trails Directory
**Team:** Sara Alkhubaizi –Dhay Aldhwayan – Rahaf Alabdullah – Zahraa Ali Alhussain

---

## 1. Project Objectives

### 1.1 Purpose
The purpose of **Qimmah (قمة)** is to establish a unified, trustworthy digital directory for certified hiking trails across Saudi Arabia. While outdoor tourism and hiking are rapidly expanding under Saudi Vision 2030, enthusiasts currently face fragmented, unverified, and potentially unsafe route details online. Qimma addresses this gap by aggregating 33 officially certified hiking trails accredited by the Saudi Climbing and Hiking Federation (SCHF) into a single, intuitive mobile platform, ensuring safer outdoor exploration and promoting domestic eco-tourism.

### 1.2 SMART Objectives

1. **Deliver an Accredited 33-Trail Directory:** Develop and launch a cross-platform mobile application (iOS & Android) within **12 weeks** that renders all **33 SCHF-certified** hiking trails on an interactive map of Saudi Arabia, providing 100% verified route coordinates, technical specs, and elevation profiles.
2. **Optimize User Discovery & Offline Access:** Enable users to discover and filter trails by region (e.g., Asir, Makkah, Tabuk) and difficulty level (Easy, Moderate, Hard) in **under 3 screen interactions**, maintaining an average app load time under **2.0 seconds** with instant local caching for offline accessibility.
3. **Establish Community Engagement Loop:** Achieve an active community feedback system where users rate (1 to 5 stars) and review trail conditions on at least **80% of listed trails within 30 days post-launch**, while maintaining an administrative moderation response time of **under 24 hours** for flagged content.

---

## 2. Stakeholders and Roles

### 2.1 Project Stakeholders

| Stakeholder Category | Stakeholder Group | Role / Stake in Project |
| --- | --- | --- |
| **Internal Stakeholders** | Project Team | Responsible for designing, building, testing, and documenting the Qimma MVP within the 12-week schedule. |
| **Internal Stakeholders** | Instructors & Supervisors | Provide academic oversight, evaluate stage deliverables, monitor milestones, and assess code quality. |
| **External Stakeholders** | End-Users (Saudi Hikers & Tourists) | Primary beneficiaries who explore, filter, navigate, rate, and review accredited trails across Saudi Arabia. |
| **External Stakeholders** | Saudi Climbing & Hiking Federation (SCHF) | External governing body whose official trail accreditations, route safety ratings, and GPX datasets validate app content. |
| **External Stakeholders** | Third-Party API Service Providers | Map SDKs (Mapbox/Google Maps) and Weather APIs (OpenWeather) providing map rendering and live meteorological forecasts. |
| **External Stakeholders** | Administrative Content Managers | Platform administrators responsible for updating trail data schemas, managing GPX updates, and moderating reviews. |

### 2.2 Team Roles & Responsibilities

| Role | Name | Core Responsibilities |
| --- | --- | --- |
| **Project Manager (PM)** | Sara Alkhubaizi | Tracks timeline milestones, manages task allocation in Notion, leads bi-weekly syncs, mitigates risks, and compiles project documentation. |
| **UI/UX Designer** | Dhay Aldhwayan | Maps user journeys, designs high-fidelity wireframes/prototypes in Figma, designs custom map markers, elevation charts, and ensures Arabic/English UI accessibility. |
| **Frontend Lead Developer** | Rahaf Alabdullah | Leads cross-platform mobile application development (Flutter/React Native), integrates Map SDKs to render GPX route polylines, implements multi-criteria search filters, and manages client-side offline storage. |
| **Backend & Database Developer** | Zahraa Ali Alhussain | Architectures database schema (Supabase/Firebase), configures Role-Based Access Control (RBAC), constructs RESTful APIs, implements server-side caching, and integrates external weather APIs. |
| **QA & Content Coordinator** | Shared Team Effort | Validates coordinate integrity for all 33 SCHF trails, creates test suites, executes end-to-end device testing (iOS & Android), and manages review moderation workflows. |

---

## 3. Scope Definition

### 3.1 In-Scope Items (Included in MVP)

* **33 Certified Trails Directory:** Cataloging all 33 official hiking trails accredited by the Saudi Climbing and Hiking Federation (SCHF).
* **Interactive Map & GPS Route Visualization:** Dynamic interactive map rendering trail markers, start/end coordinates, and GPX route lines.
* **Multi-Criteria Search & Filtering:** Dynamic filtering by Region (Asir, Al-Madinah, Makkah, Tabuk, Riyadh, etc.) and Difficulty Level (Easy, Moderate, Hard).
* **Comprehensive Trail Detail Pages:** Displaying total distance (km), elevation gain (m), estimated completion time, elevation profile graph, route description, safety warnings, and the official SCHF accreditation badge.
* **Community Rating & Review System:** 1-to-5-star rating scale and written review submissions with administrative content moderation capabilities.
* **Offline Bookmarks ("My Trails"):** Local data caching mechanism allowing hikers to save favorite routes and view trail maps without an active internet connection.
* **Live Weather Integration:** REST API integration displaying current temperature, wind speed, and short-term forecasts for specific trailhead coordinates.
* **Basic Admin Management Portal:** Backend dashboard for administrators to edit trail metadata, update GPX route files, and moderate flagged reviews.

### 3.2 Out-of-Scope Items (Excluded from MVP)

* **Guided Tour Bookings & Payment Processing:** No commercial transactions, ticketing, or integration with tour operators or payment gateways.
* **Social Networking Features:** Excludes direct messaging, friend lists, user followings, or live social feeds.
* **Turn-by-Turn GPS Voice Navigation:** No real-time voice guidance or live turn prompts during active hikes.
* **E-Commerce & Gear Rentals:** Excludes gear sales, equipment rental services, or marketplace integrations.
* **Custom User Route Uploads:** Users cannot upload or publish unverified personal GPX routes to preserve data accuracy and hiker safety standards.

---

## 4. Risk Identification and Mitigation

| # | Risk Description | Category | Phase | Impact / Likelihood | Risk Trigger | Mitigation Strategy | Owner |
| :-: | --- | --- | --- | :-: | --- | --- | --- |
| **1** | **Lack of Cellular Coverage on Trails:** Users cannot load online maps or trail details while hiking in remote areas. | Technical | Stage 4 (W7–W10) | High / High | Device loses cellular connection at trailhead. | Implement local offline caching (SQLite/AsyncStorage) so saved trail coordinates, descriptions, and elevation maps remain accessible offline. | Frontend Lead |
| **2** | **Inaccurate or Outdated GPX Data:** Coordinate errors or outdated route polylines could compromise hiker safety. | Data | Stage 3 (W5–W6) | High / Low | Discrepancy between published route map and physical trail path. | Source GPX datasets exclusively from official SCHF records and conduct manual coordinate verification before database seeding. | QA & Content Coordinator |
| **3** | **Complexity in Map SDK & Elevation Profiling:** Team faces a learning curve rendering interactive GPX polylines and elevation graphs. | Technical | Stage 4 (W7–W10) | Medium / Medium | Rendering lag or chart rendering errors during map testing. | Build early proof-of-concept map prototypes using lightweight open-source charting libraries (e.g., `fl_chart`). | Frontend Lead |
| **4** | **Scope Creep:** Unplanned feature additions (e.g., social feeds or booking systems) cause delivery delays. | Scope | Stage 3 & 4 (W5–W10) | High / Medium | Feature requests outside defined MVP boundaries during development. | Enforce strict Scope boundaries; log any new feature ideas into a "Future Release Backlog" for post-MVP iterations. | Project Manager |
| **5** | **Third-Party Weather API Rate Limit Exceeded:** Free tier rate limits lead to request failures on trail detail pages. | API | Stage 4 (W7–W10) | Medium / Low | Weather API returns HTTP 429 (Too Many Requests). | Implement aggressive client-side caching (fetching weather data once every 3–6 hours per trailhead coordinate). | Backend Lead |
| **6** | **Unbalanced Team Workload & Schedule Slippage:** Academic commitments cause delayed deliverable submissions. | Operational | All Stages (W1–W12) | Medium / Medium | Missed task completion deadlines in Notion. | Hold bi-weekly status syncs, track async updates via Slack, and reallocate tasks promptly if delays occur. | Project Manager |

---

## 5. High-Level Plan and Timeline

### 5.1 Project Timeline Overview

```text
+-----------------------------------------------------------------------------------+
|                            QIMMAh PROJECT TIMELINE                                 |
+-------------------+--------------------+--------------------+---------------------+
| Stage 1 & 2       | Stage 3            | Stage 4            | Stage 5             |
| Weeks 1 - 4       | Weeks 5 - 6        | Weeks 7 - 10       | Weeks 11 - 12       |
+-------------------+--------------------+--------------------+---------------------+
| • Idea Approval   | • System Arch.     | • Mobile Frontend  | • QA & Testing      |
| • Team Roles      | • Database Schema  | • Map & GPX SDK    | • Bug Fixing        |
| • Project Charter | • Figma UI/UX      | • Backend APIs     | • Presentation      |
|                   | • SCHF Trail Data  | • Weather API      | • Final Submission  |
+-------------------+--------------------+--------------------+---------------------+

```

### 5.2 Key Milestones and Dependencies

| Milestone # | Milestone Name | Key Deliverables | Stage | Timeline | Prerequisites / Dependencies |
| --- | --- | --- | --- | --- | --- |
| **M1** | **Project Initiation & Concept Approval** | Finalized project idea (*Qimmah Platform*), team role assignments, and Stage 1 Report. | Stage 1 | Weeks 1–2 | None |
| **M2** | **Project Charter Approval** | Approved Project Charter document including SMART goals, scope, risk register, and timeline. | Stage 2 | Weeks 3–4 | Completion of Milestone M1 |
| **M3** | **Architecture & Design Specification** | System architecture diagrams, Supabase database schema, high-fidelity Figma UI prototypes, and structured SCHF GPX dataset. | Stage 3 | Weeks 5–6 | Completion of Milestone M2 |
| **M4** | **Core MVP Development** | Cross-platform mobile app with authentication, interactive Map SDK integration, multi-criteria filtering, and live weather API. | Stage 4 | Weeks 7–9 | Completion of Milestone M3 |
| **M5** | **Testing & Quality Assurance** | Fully tested MVP, optimized offline caching, resolution of critical bugs, and cross-device performance validation. | Stage 4 | Week 10 | Completion of Milestone M4 |
| **M6** | **Project Closure & Final Handover** | Live MVP demonstration, code repository release on GitHub, project poster, and final Stage 5 Closure Report. | Stage 5 | Weeks 11–12 | Completion of Milestone M5 |

---

*Report prepared by: Sara Alkhubaizi, Rahaf Alabdullah, Dhay Aldhwayan, Zahraa Ali Alhussain*

*Stage 2 – Portfolio Project | Holberton School*

```

```
