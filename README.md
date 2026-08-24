<h1 align="center">DoseLens</h1>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.19+-02569B?logo=flutter&logoColor=white" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.3+-0175C2?logo=dart&logoColor=white" /></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-Backend-FF6F00?logo=firebase&logoColor=white" /></a>
  <a href="https://aistudio.google.com"><img src="https://img.shields.io/badge/Gemini_2.0-Flash-4285F4?logo=google&logoColor=white" /></a>
  <a href="https://pub.dev/packages/flutter_riverpod"><img src="https://img.shields.io/badge/Riverpod-2.x-00BCD4" /></a>
  <img src="https://img.shields.io/badge/License-MIT-6B7280" />
</p>

---

> *"Scan once, never miss a dose again."*

AI-powered medication scanner, adherence tracker, and family health passport — built in Flutter. Point your camera at any medication label and Gemini Flash Vision extracts the drug name, dosage, and frequency in seconds. Your 30-day adherence history exports as a one-tap PDF passport for doctor visits, and caregivers receive real-time Firestore alerts when a high-risk dose is missed.

<p align="center">
  <img src="https://img.shields.io/badge/-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/-Firebase-FF6F00?style=for-the-badge&logo=firebase&logoColor=white" />
  <img src="https://img.shields.io/badge/-Gemini_AI-4285F4?style=for-the-badge&logo=google&logoColor=white" />
  <img src="https://img.shields.io/badge/-Riverpod-00BCD4?style=for-the-badge&logoColor=white" />
</p>

---

## Features

| Feature | Description |
|---|---|
| 📷 **Multimodal OCR Scanner** | Camera viewfinder with corner-bracket guide frame. Gemini 2.0 Flash Vision extracts brand name, generic name, dosage, frequency, and instructions from packaging. |
| 💊 **Daily Dose Timeline** | Morning / Afternoon / Evening segmented view. Swipe right to mark a dose **Taken**, swipe left to **Skip**. |
| 📊 **30-Day Adherence Passport** | Live donut chart showing your adherence rate. One tap generates a clinical PDF summary ready for your doctor. |
| 🤝 **Caregiver Remote Heartbeat** | Real-time Cloud Firestore listeners. Caregivers see missed dose alerts within seconds. Patients manage caregiver access by email. |
| 🔐 **Firebase Auth** | Email/password, anonymous guest mode, and patient/caregiver role selection. |

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.19+ / Dart 3.3+ |
| **State Management** | `flutter_riverpod` v2.x + code generation |
| **Backend / Auth / DB** | Firebase (Auth · Cloud Firestore · Cloud Storage) |
| **AI Vision** | Google Gemini 2.0 Flash via REST API |
| **Drug Registry** | OpenFDA Public Drug Label API (keyless) |
| **PDF Export** | `pdf` + `printing` packages |
| **Notifications** | `flutter_local_notifications` + `timezone` |
| **Design System** | Refero-Inspired Neo-Utility · `google_fonts` · `lucide_icons` |

---

## Project Structure

```text
lib/
├── core/
│   ├── constants/      # API endpoints, Firebase collections, spacing tokens
│   ├── network/        # DioClient, ApiException
│   ├── services/       # Firebase, Auth, Firestore, Storage, Gemini, PDF, Notifications
│   ├── theme/          # ColorTokens, TextStyles, AppTheme (light + dark)
│   ├── widgets/        # NeoCard, PillChip, StatusBadge, PrimaryActionButton, SectionHeader
│   └── utils/          # DateFormatters, Validators
├── features/
│   ├── auth/           # Login, Register, Role Selection
│   ├── scanner/        # Camera viewfinder, OCR verification sheet
│   ├── medications/    # Daily timeline, Add medication, Detail view
│   ├── caregiver/      # Patient monitor feed + caregiver invite management
│   └── passport/       # Adherence chart, PDF export
└── main.dart           # Firebase init, auth gate, bottom nav shell
```

---

## Getting Started

### Prerequisites

- Flutter 3.19+ (`flutter --version`)
- Xcode 15+ (iOS) or Android Studio (Android)
- A Firebase project with **Auth**, **Firestore**, and **Storage** enabled
- A [Google AI Studio](https://aistudio.google.com/app/apikey) API key

### 1. Clone and install dependencies

```bash
git clone https://github.com/yourname/doselens.git
cd doselens
flutter pub get
```

### 2. Add Firebase config files

Download from your [Firebase Console](https://console.firebase.google.com) → Project Settings → Your apps:

```bash
# Android
cp ~/Downloads/google-services.json android/app/google-services.json

# iOS
cp ~/Downloads/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist
```

### 3. Configure environment variables

```bash
cp .env.example .env
# Edit .env and set your GEMINI_API_KEY
```

### 4. Run

```bash
# iOS Simulator
flutter run -d "iPhone 15 Pro"

# Android Emulator
flutter run -d emulator-5554

# Quick browser preview (no Firebase)
flutter run -d chrome
```

---

## Design System

DoseLens uses a **Refero-Inspired Neo-Utility** visual language — clinical authority meets tactile minimalism.

| Token | Value |
|---|---|
| Background | `#F8F9FA` warm off-white |
| Surface / Card | `#FFFFFF` with `1px #E5E7EB` border |
| Primary Text | `#111827` obsidian slate |
| Primary Action | `#0D9488` modern teal |
| Success / Taken | `#10B981` clinical mint |
| Alert / Missed | `#F43F5E` coral rose |
| Warning / Pending | `#F59E0B` amber gold |
| Card Radius | `18px` continuous curve |
| Chip Shape | `BorderRadius.circular(999)` capsule |
| Spacing Grid | 8pt (`8 · 12 · 16 · 24 · 32`) |
| Font | Plus Jakarta Sans |

---

## Security

- `.env`, `google-services.json`, `GoogleService-Info.plist`, and `firebase_options.dart` are all gitignored
- API keys are loaded at runtime via `flutter_dotenv` — never hardcoded
- Firestore Security Rules restrict each user to their own data

---

## License

MIT © 2025 DoseLens
