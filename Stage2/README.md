# Project Charter

## Sports Field Booking Platform (urSoprt)

### 1. Project Objectives

#### Purpose

The Sports Field Booking Platform is a platform that allows users to easily find nearby sports fields, view their information, check available time slots, and make bookings through one place. The platform also includes a women’s feature that helps female users identify sports fields that provide suitable options for women.

#### Project Objectives

* **Provide an easy-to-use platform** that allows users to search for nearby sports fields, view their information and available time slots, and make bookings through a single platform during the MVP stage.

* **Reduce the time and effort** users spend searching for suitable sports fields by providing location-based search, manual search, and organized field information.

* **Simplify the sports field booking process** through a digital system that allows users to select a suitable field and time slot and complete their booking easily, while providing a feature that helps women identify sports fields that offer suitable options for them.

---

### 2. Stakeholders and Roles

#### Stakeholders

| Category | Stakeholder                        | Interest / Role                                   |
| -------- | ---------------------------------- | ------------------------------------------------- |
| Internal | Team Members                       | Design, develop, test, and document the platform  |
| Internal | Holberton Trainers and Supervisors | Provide guidance and evaluate the project         |
| External | Individual Users                   | Search for and book sports fields                 |
| External | Groups and Sports Teams            | Find suitable fields and make bookings            |
| External | Sports Field Owners                | Provide sports field information and availability |

#### Team Roles

| Role                                    | Responsibilities                                                                                                        | Name                 |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | -------------------- |
| **Project manager**                     | Coordinate technical decisions, organize team tasks, track progress, facilitate communication, and review code          | Rahaf Alabdalh       |
| **Backend Developer**                   | Develop the backend, database, APIs, authentication, and booking logic                                                  | Zahraa Ali Alhussain |
| **Backend Developer**                   | Develop the application interface, search, field listings, booking screens, and user features                           | Sarah Alkhubaizy     |
| **UI/UX Designer & Frontend Developer** | Design the user interface and user experience, create wireframes and prototypes, and ensure the platform is easy to use | Dhay Aldhwayan       |

**Note:** Testing and documentation responsibilities will be shared among all team members.

---

## Define Scope

### Project Scope Overview

The Sports Field Booking Platform is a digital platform designed to help users find nearby sports fields, view field information, check available time slots, and make bookings through a single, user-friendly platform.

The MVP focuses on simplifying the process of searching for and booking sports fields, while also providing a feature that helps women identify sports fields that offer suitable options for them.

### In-Scope (Included in MVP)

* Search for nearby sports fields based on the user's location.
* Manually search for sports fields.
* View sports field details, including name, location, sport type, price, and available time slots.
* View available booking time slots.
* Book a sports field for a specific time.
* Prevent duplicate bookings for the same time slot.
* User registration and login.
* User profile completion.
* View previously booked sports fields and booking details.
* Women’s feature to help identify sports fields that offer suitable options for women.
* Responsive user interface for different screen sizes.
* Initial database containing a limited number of sports fields within a specific city or area.

### Out-of-Scope (Excluded from MVP)

* Online payment processing.
* Ratings and reviews.
* Advanced and complete management dashboard for sports field owners.
* Automatic synchronization with sports field owners' systems.
* Coverage of all cities across Saudi Arabia.

---

## 3. Identify Risks

### Risk Management Overview

The Sports Field Booking Platform may face several challenges during the planning, design, and development stages. The following risk register identifies the main potential risks and the strategies that will be used to reduce their impact on the project.

### Risk Register

| # | Risk                                                 | Category       | Project Phase                         | Likelihood | Impact | Mitigation Strategy                                                                            |
| - | ---------------------------------------------------- | -------------- | ------------------------------------- | ---------- | ------ | ---------------------------------------------------------------------------------------------- |
| 1 | Delays in completing some core features              | Timeline       | All Phases (Week 1–12)                | Medium     | High   | Prioritize core features and review task progress weekly.                                      |
| 2 | Insufficient or outdated sports field information    | Data           | Stage 3 & 4 (Week 5–10)               | Medium     | High   | Start with a limited number of sports fields and use organized, reliable data for the MVP.     |
| 3 | Difficulty implementing location-based field search  | Technical      | Stage 4 – MVP Development (Week 7–10) | Medium     | Medium | Test the location feature early and provide manual search as an alternative.                   |
| 4 | Booking conflicts for the same field and time slot   | Booking System | Stage 4 – MVP Development (Week 7–10) | Low        | High   | Check time slot availability before confirming a booking and test different booking scenarios. |
| 5 | Adding requirements or features beyond the MVP scope | Scope          | Stage 3 & 4 (Week 5–10)               | Medium     | High   | Follow the agreed MVP scope and postpone additional features to future phases.                 |
| 6 | Issues with protecting user account and booking data | Security       | Stage 4 & 5 (Week 7–12)               | Low        | High   | Use secure authentication, validate user input, and restrict access to user information.       |

---

### 5. High-Level Plan
<img width="1800" height="1090" alt="project-timeline (urSport)" src="https://github.com/user-attachments/assets/b3aa6f7e-98f8-4c26-ade9-6d4e4ca28a83" />

---

### 6. Key Milestones
