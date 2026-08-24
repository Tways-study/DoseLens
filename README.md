<h1 align="center">DoseLens</h1>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.19+-02569B?logo=flutter&logoColor=white" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.3+-0175C2?logo=dart&logoColor=white" /></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-Backend-FF6F00?logo=firebase&logoColor=white" /></a>
  <a href="https://aistudio.google.com"><img src="https://img.shields.io/badge/Gemini_2.0-Flash-4285F4?logo=google&logoColor=white" /></a>
  <a href="https://pub.dev/packages/flutter_riverpod"><img src="https://img.shields.io/badge/Riverpod-2.x-00BCD4?logoColor=white" /></a>
  <img src="https://img.shields.io/badge/Design-Precision_Digital_Rx-0284C7?logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-6B7280" />
</p>

---

> *"Scan once, never miss a dose again."*

**DoseLens** is an AI-powered medication scanner, adherence tracker, and family health passport built in Flutter. Point your camera at any prescription bottle or blister pack — Gemini Flash Vision extracts the brand name, active generic ingredient, dosage strength, and frequency in seconds. Your 30-day adherence history exports into a 1-tap clinical PDF passport for doctor appointments, while caregivers receive real-time Cloud Firestore telemetry alerts when critical doses are missed.

<p align="center">
  <img src="https://skillicons.dev/icons?i=flutter,firebase,dart,androidstudio" />
</p>

---

## 🌟 Core Features

| Feature | Description |
|---|---|
| 📷 **Multimodal AI Vision Scanner** | Viewfinder reticle with glowing Cyan Laser corner brackets. Powered by **Gemini 2.0 Flash Vision** to extract brand, generic ingredient, dosage, frequency, and instructions directly from packaging bytes. |
| 💊 **Daily Prescription Timeline** | Morning, Afternoon, Evening, and As-Needed segmented schedule. Swipe right to mark **Taken** (Mint), swipe left to **Skip**. |
| 🛡️ **30-Day Clinical Passport** | Live 30-day adherence score index. Generates a one-tap clinical PDF passport summary ready for physician consultation. |
| 📡 **Caregiver Remote Heartbeat** | Real-time Cloud Firestore listeners stream patient telemetry. Caregivers receive instant alerts when a dose is missed. |
| 🔐 **Firebase Authentication** | Email/password login, registration, instant guest exploration mode, and role-tailored onboarding. |

---

## 🎨 Design System: Precision Digital Rx

DoseLens follows the **Precision Digital Rx** design architecture — combining high-precision medical optics with modern clinical minimalism.

| Token | Hex Value | Role |
|---|---|---|
| **Primary Action** | `#0284C7` | **Electric Cerulean** (Primary CTA buttons, active navigation, and FAB) |
| **Optic Scan Laser** | `#00D8F6` | **Cyan Laser** (Viewfinder brackets, camera optics, AI badges) |
| **Deep Contrast** | `#0B132B` | **Midnight Obsidian** (Headlines and primary typography) |
| **Canvas Background** | `#F8FAFC` | **Ice Paper** (Anti-glare clean canvas backdrop) |
| **Card Surface** | `#FFFFFF` | **Pure White** with `1px #E2E8F0` cool hairline borders |
| **Taken (Success)** | `#10B981` | **Clinical Mint** (`#ECFDF5` background, `#A7F3D0` border) |
| **Missed (Alert)** | `#EF4444` | **Crimson Alert** (`#FEF2F2` background, `#FCA5A5` border) |
| **Pending / Warning** | `#F59E0B` | **Amber Gold** (`#FFFBEB` background, `#FDE68A` border) |
| **Card Corner Radius** | `14.0px` | Smooth continuous curve with paper-quiet elevation |
| **Capsule Chips & Pills** | `9999px` | Fully rounded badges and extended action buttons |
| **Typography** | Plus Jakarta Sans | Humanist geometric scale with tight display tracking |

---

## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants/      # AppConstants (radii, 4px grid spacing, endpoints)
│   ├── network/        # DioClient, ApiException
│   ├── services/       # Firebase, Auth, Firestore, Gemini 2.0 Flash, PDF, Notifications
│   ├── theme/          # ColorTokens (Precision Rx), TextStyles, AppTheme
│   ├── widgets/        # NeoCard, PillChip, StatusBadge, PrimaryActionButton, SectionHeader
│   └── utils/          # DateFormatters, Validators
├── features/
│   ├── auth/           # Login, Register, RoleSelectionScreen (Patient vs Caregiver)
│   ├── scanner/        # ScannerScreen (Cyan Laser viewfinder), OcrVerificationSheet
│   ├── medications/    # HomeScreen (Today timeline), AddMedicationScreen, Detail view
│   ├── caregiver/      # CaregiverDashboardScreen (Monitored patients, remote telemetry feed)
│   └── passport/       # PassportScreen (Adherence charts, 1-tap PDF passport export)
├── firebase_options.dart # Generated Firebase configuration
└── main.dart           # App root, Auth gate, Bottom navigation & Extended Scan FAB
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter 3.19+](https://docs.flutter.dev/get-started/install) installed
- [Google AI Studio API Key](https://aistudio.google.com/app/apikey) for Gemini Flash Vision
- Firebase Project configured (Auth + Cloud Firestore)

### 1. Clone & Install Dependencies

```bash
git clone https://github.com/Tways-study/DoseLens.git
cd DoseLens
flutter pub get
```

### 2. Configure Environment Variables

Create a `.env` file in the project root:

```bash
GEMINI_API_KEY=your_gemini_api_key_here
```

### 3. Run the App

```bash
# Run on Web / Brave / Chrome
flutter run -d chrome

# Run on macOS Desktop
flutter run -d macos

# Run on iOS Simulator
flutter run -d ios

# Run on Android Emulator
flutter run -d android
```

---

## 🔒 Security & Privacy

![gitignored](https://img.shields.io/badge/.env-gitignored-22C55E?logo=gnuprivacyguard&logoColor=white)
![no hardcoded keys](https://img.shields.io/badge/API_keys-runtime_only-22C55E?logo=gnuprivacyguard&logoColor=white)
![firestore rules](https://img.shields.io/badge/Firestore-security_rules-FF6F00?logo=firebase&logoColor=white)

- `.env`, `google-services.json`, `GoogleService-Info.plist`, and `firebase_options.dart` are gitignored.
- Gemini OCR runs directly on image bytes without storing photos unnecessarily.
- Cloud Firestore Security Rules enforce strict user isolation (patients and authorized caregivers only).

---

## 📄 License

MIT © 2026 DoseLens
