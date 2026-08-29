<div align="center">

# ⚡ VORTEX // HACKATHON OPERATING SYSTEM

**The Next-Gen, Cyber-Noir Real-Time Operating Platform for High-Stakes 24h+ Hackathons**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Riverpod](https://img.shields.io/badge/State-Riverpod%202.x-00F5FF)](https://riverpod.dev)
[![Deployment](https://img.shields.io/badge/Vercel-Production%20Live-black?logo=vercel&logoColor=white)](https://web-lovat-ten-11.vercel.app)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

[🌐 Live Web App](https://web-lovat-ten-11.vercel.app) • [📱 Features](#-core-capabilities) • [🛠️ Architecture](#-architecture--tech-stack) • [🚀 Quickstart](#-getting-started)

---

</div>

## 🌌 Overview

**Vortex** is an end-to-end hackathon operating platform designed to eliminate the friction of organizing, participating in, and judging intense hackathons (such as 24-hour sprint events). Built with a sleek cyber-noir aesthetic, glassmorphism, responsive navigation, and resilient offline-first architecture, Vortex unifies organizers, participants, and judges into a synchronized real-time ecosystem.

---

## 🚀 Core Capabilities

### 👨‍💻 1. Participant Experience (Hacker OS)
* **Event Intelligence:** Live countdown timers, venue telemetry, rules, and problem statement tracks.
* **Squad Matchmaker & Formation:**
  * Toggle **`SEEKING: ON / OFF`** to control whether your squad is publicly discoverable.
  * Send & receive join requests with an application review queue for team leaders.
  * AI-powered compatibility scoring based on skill-gap analysis.
* **Anti-Screenshot QR Pass:** Secure, non-screenshot participant and team credentials for gate checkpoints.
* **Food & Meal Voucher Vault:** Digital QR meal coupons with instant scan validation and geolocation verification.
* **SOS Mentor Dispatch:** Summon domain mentors on-demand directly to your assigned table.
* **Interactive Hackathon Agenda:** Real-time schedule timeline with bookmarking and live-now markers.

---

### 🛡️ 2. Organizer Command Center
* **Live Telemetry Dashboard:** Real-time hacker check-in velocity, table occupancy rates, and active coupon redemptions.
* **Team Approval & Table Allocation:** Verify team requirements and assign tables in real time.
* **Scanner Hub:** Camera-based scanner for instant ticket redemption, food validation, and gate passes with GPS coordinate logging.
* **Mentor Dispatch Grid:** Live queue of hacker distress calls, status tracking (Pending → Dispatched → Resolved).
* **Emergency Broadcast Engine:** Send urgent flash notifications and track updates across all participant devices.
* **Anomaly & Bias Engine:** Automated statistical outlier detection on judging scores.

---

### ⚖️ 3. Judge & Public Stage
* **Multi-Criteria Scoring Sliders:** Intuitive evaluation matrix (Innovation, Technical Execution, UI/UX, and Pitch Delivery).
* **Live Firestore Sync:** Submitted scores immediately update backend metrics and the leaderboard.
* **16:9 Big Screen Projector Stage:** Clean, high-contrast leaderboard view designed for live auditoriums and presentation stages.

---

## 🛠️ Architecture & Tech Stack

```
lib/
├── core/
│   ├── router/          # Declarative GoRouter routing & guards
│   ├── services/        # Firebase & Cloud Firestore initialization
│   ├── theme/           # Cyber-Noir custom theme & Rajdhani typography
│   └── utils/           # Matchmaker & Scoring Bias algorithms
├── features/
│   ├── auth/            # Multi-role authentication & session manager
│   ├── coupons/         # Digital meal coupon models
│   ├── events/          # Hackathon event & team state providers
│   ├── judging/         # Evaluation sheets & 16:9 stage projector
│   ├── organizer/       # Command center telemetry, scanner, & broadcast
│   ├── participant/     # Hacker OS dashboard, matchmaker, & profile
│   ├── scanner/         # QR scanner & geolocation audit logs
│   └── teams/           # Team formation, member state, & approvals
└── shared/              # Reusable GlassCard widgets & role overlays
```

* **Frontend:** Flutter (Web & Mobile Native)
* **State Management:** Riverpod 2.x (`StateNotifierProvider`)
* **Styling:** Custom Cyber-Noir Glassmorphism with `GoogleFonts.rajdhani` and `GoogleFonts.inter`
* **Database & Auth:** Firebase Cloud Firestore + Firebase Authentication (with offline-first `SharedPreferences` cache)
* **Hosting & CI/CD:** Vercel + GitHub Actions Automated CI/CD

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.24+ recommended)
* Dart SDK (3.5+)

### 1. Clone the Repository
```bash
git clone https://github.com/KesarPP/Vortex.git
cd Vortex
```

### 2. Configure Environment (.env)
Create a `.env` file in the project root:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project.firebasestorage.app
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID_WEB=your_web_app_id
FIREBASE_APP_ID_ANDROID=your_android_app_id
FIREBASE_APP_ID_IOS=your_ios_app_id
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run Locally
```bash
# Run on connected device or emulator
flutter run

# Run on Chrome / Web
flutter run -d chrome
```

---

## 🌐 Deployment to Vercel

Build and deploy the Flutter Web release to Vercel:

```bash
# 1. Build release bundle
flutter build web --release

# 2. Deploy with Vercel CLI
vercel build/web --prod
```

Or simply push to the `main` branch to trigger the automated **GitHub Actions pipeline**!

---

## 🔐 Master Access Codes (Demo / Offline Mode)

| Role | Access Route | Passcode |
|---|---|---|
| **Participant** | Direct Sign In / One-Click | Any email/pass |
| **Organizer** | Select Role: Organizer | `2026` |
| **Judge** | Select Role: Judge | `JUDGE2026` or `2026` |

---

<div align="center">
Built with ⚡ for fast-paced, high-impact hackathons.
</div>
