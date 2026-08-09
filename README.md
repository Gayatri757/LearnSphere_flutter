<div align="center">

# 🎓 LearnSphere — Flutter App

**A modern Flutter-based educational platform that brings the learning journey into one connected experience.**

Video lectures · Notes & PDFs · MCQs · Study Plans · Premium Learning

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![Status](https://img.shields.io/badge/status-in--development-yellow)]()

</div>

---

## 📖 About LearnSphere

LearnSphere is a **full-stack educational platform** designed to bring different parts of the learning journey into a single mobile application.

Instead of switching between multiple platforms for lectures, notes, question practice, and study planning, students can access their learning resources through one structured Flutter application.

The current content library is **medical/MBBS-focused**, but LearnSphere itself is not limited to medical education. The application is designed to support additional academic domains through subjects and structured content.

This repository contains the **Flutter frontend/mobile application**.

For the complete backend architecture, APIs, database, authentication, subscriptions, and deployment details:

👉 **Backend Repository:**  
https://github.com/Gayatri757/THE-LEARNSPHERE

---

## ✨ Features

### 📱 Student Experience

- Browse available subjects
- View subject-specific learning content
- Watch embedded video lectures
- Access notes and PDF resources
- Practice subject-wise MCQs
- Access question banks
- Follow structured study plans
- View premium subscription status
- Access premium learning content based on subscription
- View profile and account information
- Light & Dark mode support
- Secure authentication and session handling

### 👩‍🏫 Teacher Experience

The Flutter application also provides a dedicated teacher workflow for managing educational content.

Teachers can:

- Manage video lectures
- Upload video content
- Manage notes and PDFs
- Upload learning resources
- Add MCQs individually
- Upload MCQs in bulk
- Create study plans
- Manage premium subscription plans
- Configure premium plans based on subject and duration
- Manage teacher-side educational content
- View teacher analytics

---

## 🔐 Authentication

LearnSphere includes a complete authentication flow in the Flutter application:

- User login
- User registration
- Email verification
- OTP verification
- Forgot password
- OTP-based password recovery
- New password setup
- Student/Teacher role-based navigation
- JWT-based authenticated API requests
- Secure local token storage
- Automatic handling of expired authentication sessions

Authentication and authorization are handled by the backend API.

For backend authentication implementation and API details, see:

👉 https://github.com/Gayatri757/THE-LEARNSPHERE

---

## 🎨 UI & Theme

The application uses Flutter's Material UI system with centralized theme management.

### Supported themes

- ☀️ Light Mode
- 🌙 Dark Mode

Theme state is managed centrally so that the appearance remains consistent across the application.

The user's theme preference is also persisted between app sessions.

---

## 🏗️ Flutter Application Structure

The project follows a feature-oriented structure:

```text
lib/
│
├── core/
│   └── theme/
│       └── app_theme.dart
│
├── features/
│   ├── auth/
│   │   └── ui/
│   │
│   ├── notes/
│   │   └── ui/
│   │
│   ├── plans/
│   │   └── ui/
│   │
│   ├── qbank/
│   │
│   ├── subjects/
│   │   └── ui/
│   │
│   ├── teacher/
│   │   └── ui/
│   │
│   └── videos/
│
├── models/
│
├── navigation/
│
├── screens/
│   ├── ai/
│   ├── home/
│   ├── profile/
│   ├── splash/
│   ├── student/
│   ├── teacher/
│   └── tests/
│
├── services/
│   ├── api_service.dart
│   ├── otp_service.dart
│   ├── razorpay_service.dart
│   └── theme_manager.dart
│
├── utils/
│
├── widgets/
│
└── main.dart

🛠️ Frontend Tech Stack
Technology	Purpose
Flutter	Cross-platform mobile application
Dart	Application programming language
Material UI	User interface components
flutter_secure_storage	Secure local storage for authentication data
HTTP	Communication with backend REST APIs
YouTube Embeds	Video lecture playback
Centralized Theme Management	Light/Dark mode

🔄 Application Flow
                    LearnSphere Flutter App
                             │
                             ▼
                    ┌─────────────────┐
                    │ Authentication  │
                    │ Login / Signup  │
                    │ OTP / Password  │
                    └────────┬────────┘
                             │
                             ▼
                     Role-based Access
                       /             \
                      /               \
                     ▼                 ▼
                👨‍🎓 Student        👩‍🏫 Teacher
                     │                 │
          ┌──────────┼─────────┐       │
          ▼          ▼         ▼       ▼
       Subjects   Videos     Notes   Manage Content
          │          │         │       │
          └──────────┼─────────┘       │
                     ▼                 ▼
                  MCQs            Study Plans
                     │                 │
                     └───────┬─────────┘
                             ▼
                     Premium Content
                             │
                             ▼
                       Subscriptions
💳 Premium Learning

LearnSphere supports subscription-based learning.

Teachers can create and manage premium plans according to:

Subject
Duration
Premium content access

Students can view their subscription status and access premium learning resources when their subscription is active.

The subscription logic and server-side validation are handled by the backend.

👉 Backend implementation:
https://github.com/Gayatri757/THE-LEARNSPHERE

📚 Current Content

The current content library is focused on medical/MBBS-oriented subjects as the initial domain.

However, the Flutter application is structured around generic concepts such as:

Subjects
Videos
Notes
MCQs
Study Plans
Premium Plans

This allows the platform to be extended to other academic domains without redesigning the entire application.

🚀 Getting Started
1. Clone the repository
git clone https://github.com/Gayatri757/LearnSphere_flutter.git
2. Enter the project
cd LearnSphere_flutter
3. Install dependencies
flutter pub get
4. Connect the backend

The Flutter application requires the LearnSphere backend API to be available.

Backend repository:

https://github.com/Gayatri757/THE-LEARNSPHERE

Make sure the API base URL configured in the Flutter application points to the running backend.

5. Run the application
flutter run
📱 Supported Platform

The project is primarily developed as a Flutter mobile application, with Flutter's generated platform structure also included in the repository.

🔗 Related Repository
Backend — LearnSphere

Python/Flask backend containing:

REST APIs
Authentication
JWT authorization
Database models
PostgreSQL/Neon integration
Subscription management
Content management
Email/OTP services
Cloud storage integration
Backend deployment

👉 https://github.com/Gayatri757/THE-LEARNSPHERE

🚧 Project Status

LearnSphere is currently in active development.

The core student and teacher workflows are implemented, including authentication, educational content, MCQs, study plans, premium plans, and subscription access.

Planned improvements
Deeper teacher analytics
More self-service content management
Additional academic domains
Expanded subscription functionality
Further UI/UX improvements
👩‍💻 Developer

Gayatri Adatiya

AI & Data Science student interested in building full-stack, ML-powered and scalable applications.

Open to opportunities
🤖 ML Engineer
📱 Flutter Developer
🐍 Python Developer

GitHub:
https://github.com/Gayatri757

<div align="center">
🎓 Learn. Practice. Organize. Grow.

LearnSphere — Bringing the learning journey together.

</div> ```
