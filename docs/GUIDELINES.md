# Project Guidelines & Architecture Reference

## 1. Vision & Scope
* **Core Objective:** A 24/7 Real-time Location Tracking application for families.
* **Future Scope:** Modular expansion into "Family Care" (Groceries, Finances) via feature flags.
* **Target Audience:** Families requiring safety and coordination.
* **Platforms:** Android (Primary/MVP), iOS (Secondary - pending hardware).

## 2. Technical Stack
* **Mobile:** Flutter (Dart).
* **Backend:** NestJS (TypeScript).
* **Database:** PostgreSQL with **PostGIS** extension (Spatial indexing).
* **Cache/Queue:** Redis (for high-throughput location ingestion).
* **Communication:** * REST (Standard Operations).
    * Protobuf over WebSockets (Real-time Location Updates).

## 3. Strict Code Protocol
* **Linter:** * Mobile: `very_good_analysis` (Strict typing, no magic numbers).
    * Backend: `eslint-config-prettier` with strict TypeScript checks.
* **Testing:** * CI must pass `flutter test` and `npm run test:e2e` before merge.
    * No "commented out" code committed.
* **Version Control:** * Conventional Commits (`feat:`, `fix:`, `chore:`).
    * Feature Branch Workflow.

## 4. Architectural Decisions

### A. Location Tracking Strategy
* **Engine:** `flutter_background_geolocation` (or equivalent robust background service).
* **Battery Optimization:** Hybrid Profile.
    * *Motion-Activity:* High frequency when moving (walking/driving).
    * *Heartbeat:* Low frequency (every X minutes) when stationary.
* **Offline First:** * Location points are queued in local SQlite/Isar when offline.
    * Batch upload occurs immediately upon reconnection.

### B. Map & Geocoding
* **Provider:** **Google Maps Platform**.
* **Reasoning:** Superior "Places" (POI) data for user-friendly location naming.
* **Optimization:** Map styling handles distinct markers for family members.

### C. Authentication & Onboarding
* **Methods:** * OTP (Phone Number).
    * Google Social Login.
* **Family Joining:** * MVP: 6-Digit alphanumeric codes.
    * Post-MVP: Deep Links (Firebase Dynamic Links / UniLinks).

### D. Data Privacy & Safety (LGPD Compliance)
* **Encryption:** Data encrypted at rest in DB.
* **User Control:** * "Purge Account" feature must exist in-app (deletes DB records).
    * App Launch: Explicit "Foreground Service" notification (Android requirement).
* **Transparency:** First-launch dialog explaining *why* background location is needed (Store Policy Requirement).

### E. Infrastructure & Devops
* **Crash Reporting:** **Sentry** (Full stack tracing: Flutter + NestJS).
* **Data Retention:** * MVP: 7 Days rolling window.
    * Future: Tiered retention (14/30 days) based on user roles.

## 5. Development Workflow (Linux/Mac)
* **Mobile Dev:** Primary development on Linux Mint (Android Emulator).
* **iOS Build:** Remote CI/CD or Work Mac (Manual build).
* **Dependencies:** managed via `pubspec.yaml` (Flutter) and `package.json` (NestJS).

## 6. Known Constraints
* **iOS Simulator:** Does not accurately simulate background location behavior. Real device testing required before iOS release.
* **Costs:** Google Maps API usage must be monitored to prevent billing spikes.