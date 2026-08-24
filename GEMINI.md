# GEMINI.md - Project Specification & UI/UX Architecture

## 1. Project Overview

- **App Name:** DoseLens
- **Description:** An AI-powered medication scanner, adherence tracker, and family health passport built in Flutter.
- **Core Value Props:**
  - **Multimodal OCR:** Extract generic name, brand, dosage, and frequency from packaging via Gemini Flash Vision.
  - **Doctor's Visit PDF Passport:** Generates a one-tap clinical summary with a 30-day adherence rate.
  - **Caregiver Remote Heartbeat:** Real-time caregiver alerts via Cloud Firestore listeners if high-risk doses are missed.
  - **Free-Tier Stack:** Flutter, Google AI Studio (Gemini 2.0/1.5 Flash), Firebase (Auth, Cloud Firestore, Cloud Storage), OpenFDA API.

---

## 2. Design System & UI Architecture (Refero-Inspired Neo-Utility)

The visual design language balances clinical authority with modern, tactile minimalism: high-contrast typography, warm neutral surfaces, pill-shaped chips, subtle borders, and intentional accent color coding.

### 2.1 Color Palette & Semantic Tokens

- **Background Canvas:** Light cream/off-white (`#F8F9FA` / `#F4F5F7`) for a soft, glare-free backdrop.
- **Surface / Card Background:** Pure white (`#FFFFFF`) with subtle 1px border stroke (`#E5E7EB`).
- **Text Hierarchy:**
  - Primary / Headings: Deep obsidian slate (`#111827`) with heavy weights (`FontWeight.w700` / `FontWeight.w600`).
  - Secondary / Labels: Muted cool gray (`#6B7280`) with medium weights (`FontWeight.w500`).
  - Muted / Captions: Soft graphite (`#9CA3AF`).
- **Accents & Status Colors:**
  - **Primary Action:** Deep modern teal/indigo (`#0F172A` or `#0D9488`).
  - **Adherence / Success:** Fresh clinical mint (`#10B981` / background `#ECFDF5`).
  - **Missed / Urgent Alert:** Coral rose (`#F43F5E` / background `#FFF1F2`).
  - **Warning / Pending:** Amber gold (`#F59E0B` / background `#FEF3C7`).

### 2.2 Elevation, Radii & Layout Tokens

- **Card Corner Radius:** Smooth continuous curves using `BorderRadius.circular(18)` or `24`.
- **Chips & Badges:** Fully rounded capsule/pill shapes (`BorderRadius.circular(999)`).
- **Borders & Shadows:**
  - Avoid heavy drop shadows. Favor a **1px solid border** (`Border.all(color: Color(0xFFE5E7EB), width: 1.0)`).
  - Subtle elevation: `BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4))`.
- **Content Spacing:** Strict 8pt grid (`8`, `12`, `16`, `24`, `32`).

### 2.3 Micro-Components & UI Patterns

- **Tactile Metric Cards:** Metric numbers (e.g., adherence percentage `94%`) displayed large in bold tabular figures with a compact status badge next to it.
- **Time-Segmented Timeline:** Morning, Afternoon, Evening medication cards organized sequentially with visual pill icons and take/skip swipe actions.
- **Camera Scanner Frame:** Frosted acrylic overlay with high-contrast corner guide brackets and haptic feedback upon OCR lock.

---

## 3. Tech Stack & Dependencies

### Frontend (Flutter / Dart)

- **Framework:** Flutter (Targeting iOS & Android)
- **State Management:** `flutter_riverpod` (v2.x with code generation)
- **Design & Icons:** `lucide_icons` or `feather_icons`, Google Fonts (`Plus Jakarta Sans` or `Inter`)
- **Networking:** `dio`
- **Local Persistence & Cache:** `shared_preferences` / `flutter_secure_storage`
- **Camera & Image Handling:** `camera`, `image_picker`, `image_cropper`
- **PDF Generation & Export:** `pdf`, `printing`, `path_provider`
- **Notifications:** `flutter_local_notifications`, `timezone`

### Backend & AI

- **Backend / Database:** Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`)
- **AI Provider:** Google AI Studio REST API (`gemini-2.0-flash` or `gemini-1.5-flash`)
- **Public Drug Registry:** OpenFDA Drug Label API (Keyless public endpoints)

---

## 4. Architecture & Project Structure

Use a **Feature-First** architecture with strict separation between domain logic and Neo-Utility UI components.

```text
lib/
├── core/
│   ├── constants/          # API endpoints, design tokens, asset paths, Firebase collections
│   ├── network/            # Dio interceptors, error handling
│   ├── services/           # FirebaseService, GeminiService, OpenFdaService, NotificationService, PdfService
│   ├── theme/              # ColorTokens, TextStyles, ComponentThemes (Card, Button, Chip)
│   ├── widgets/            # NeoCard, PillChip, StatusBadge, PrimaryActionButton, SectionHeader
│   └── utils/              # Date formatters, validators
├── features/
│   ├── auth/               # Minimalist login, PIN setup, role selection
│   ├── scanner/            # Viewfinder with guide brackets, crop preview, OCR verification sheet
│   ├── medications/        # Daily dose timeline, drug detail sheet, log adherence
│   ├── caregiver/          # Caregiver heartbeat dashboard, remote missed dose feed
│   └── passport/           # Adherence charts, preview card, 1-tap PDF generator
└── main.dart
```
