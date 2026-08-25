# GEMINI.md — Project Specification & UI/UX Architecture

## 1. Project Overview

- **App Name:** DoseLens
- **Description:** An AI-powered medication scanner, adherence tracker, and family health passport built in Flutter.
- **Core Value Props:**
  - **Multimodal AI Vision Scanner:** Extract brand name, active generic ingredient, dosage strength, and frequency directly from medication packaging via Gemini 2.0 Flash Vision.
  - **Doctor's Visit PDF Passport:** One-tap clinical summary with 30-day adherence indexing, medication schedules, and missed dose logs.
  - **Caregiver Remote Heartbeat:** Real-time patient telemetry via Cloud Firestore listeners with instant alerts for missed critical doses.
  - **Free-Tier Stack:** Flutter (3.19+), Google AI Studio (Gemini 2.0 Flash), Firebase (Auth, Firestore, Storage), OpenFDA Drug Label API.

---

## 2. Design System — 21n (Memotron)

**Source:** https://styles.refero.design/style/68d18deb-bb09-4258-8024-001af9c844c0

A whisper-quiet, flat, border-driven, near-monochrome light-mode workspace. Zero shadows. Zero gradients. Structure comes exclusively from 1px Silver hairline borders.

### 2.1 Color Palette & Semantic Tokens

#### Neutral Canvas Stack

| Token | Hex | Role |
|---|---|---|
| `ColorTokens.snow` | `#FFFFFF` | Card surfaces, modal backgrounds, AppBar |
| `ColorTokens.fog` | `#F9F9FB` | **Page scaffold background** — the base canvas |
| `ColorTokens.mist` | `#EFF0F6` | Inset panels, secondary cards, selected icon bg |
| `ColorTokens.silver` | `#E5E7EB` | **ALL borders and dividers** — the only structural line color |

#### Text Stack

| Token | Hex | Role |
|---|---|---|
| `ColorTokens.ink` | `#1A1A1A` | Primary headings, high-contrast labels |
| `ColorTokens.charcoal` | `#333333` | **Primary CTA button fill — the single dark anchor** |
| `ColorTokens.graphite` | `#545454` | Secondary text, metadata |
| `ColorTokens.smoke` | `#767676` | Supporting muted labels |
| `ColorTokens.ash` | `#808080` | Disabled states, placeholders, de-emphasized icons |

#### Accent Colors (punctuation only — never large fills or CTA backgrounds)

| Token | Hex | Rule |
|---|---|---|
| `ColorTokens.emeraldPulse` | `#24B26D` | **"Taken" success** — icon/text only; badge bg = `emeraldPulseBg` |
| `ColorTokens.cobaltSignal` | `#2C70DD` | **Links, active nav, AI scan icon, focused input border** |
| `ColorTokens.error` | `#DC2626` | Destructive / missed alerts |
| `ColorTokens.warning` | `#D97706` | Pending / rate-limit warnings |

#### Rules
- `charcoal` is the **only** color used as a filled button background.
- `cobaltSignal` appears on icons, link text, active underlines, and focused input borders — **never** as a button background or large fill.
- `emeraldPulse` appears only on "Taken" status icons and text — badge background is always `emeraldPulseBg` (pale green), never a saturated fill.
- Missed/skipped states use `graphite`/`ash` text on `fog`/`mist` backgrounds with `silver` borders — **no red fills**.

### 2.2 Typography — Sen

Font: **Sen** via `google_fonts` (already in `pubspec.yaml`).
Scale: Major Second (1.125) from 17px base.

| Step | Size | Weight | Line-height | Use |
|---|---|---|---|---|
| `TextStyles.displayLarge` | 56px | 700 | 1.07 | Hero / atlas-scale titles |
| `TextStyles.displayMedium` | 44px | 500 | 1.5 | Section display |
| `TextStyles.headingLarge` | 36px | 500 | 1.5 | Page headings |
| `TextStyles.headingMedium` | 22px | 400 | 1.5 | Card titles, screen titles |
| `TextStyles.subheading` | 19px | 600 | 1.5 | Subheadings, section labels |
| `TextStyles.bodyLarge` | 17px | 400 | 1.5 | Base body copy |
| `TextStyles.bodyMedium` | 16px | 400 | 1.5 | Compact body |
| `TextStyles.bodySecondary` | 16px | 400 | 1.5 | Graphite-colored secondary body |
| `TextStyles.labelLarge` | 15px | 500 | 1.5 | Labels, button text |
| `TextStyles.caption` | 13px | 400 | 1.5 | Captions, helper text |
| `TextStyles.micro` | 12px | 400 | 1.5 | Timestamps, micro labels |
| `TextStyles.metricNumber` | 44px | 700 | 1.0 | Adherence % tabular figures |

### 2.3 Geometry & Spacing

| Constant | Value | Use |
|---|---|---|
| `AppConstants.radiusCard` | `12.0px` | Cards, panels |
| `AppConstants.radiusButton` | `8.0px` | Buttons, inputs |
| `AppConstants.radiusLarge` | `16.0px` | Hero panels |
| `AppConstants.radiusPill` | `9999.0px` | Status badge chips only |

- **Borders:** `Border.all(color: ColorTokens.silver, width: 1.0)` — applied everywhere structural.
- **Shadows:** **None.** The `ColorTokens.cardShadow` stub has `Color(0x00000000)` — fully transparent.
- **Spacing grid:** Strict 8pt: `8, 12, 16, 20, 24, 32, 48, 64`.

### 2.4 Component Patterns

- **NeoCard:** `snow` bg, `silver` border, `12px` radius, zero elevation.
- **PrimaryActionButton (filled):** `charcoal` bg, white text, `8px` radius. The only filled button.
- **PrimaryActionButton (ghost):** `fog` bg, `silver` border, `ink` text.
- **StatusBadge — Taken:** `emeraldPulseBg` bg, `emeraldPulse` icon/text, `emeraldPulseBorder` border.
- **StatusBadge — Missed/Skipped/Pending:** `fog`/`mist` bg, `graphite`/`ash` text, `silver` border.
- **Scan FAB:** `charcoal` fill, `cobaltSignal` border — flat, no glow, no gradient.
- **Skeleton shimmer:** `fog` → `mist` animated gradient, Flutter-native (no packages).

---

## 3. Tech Stack & Dependencies

### Frontend (Flutter / Dart)

- **Framework:** Flutter 3.19+ / Dart 3.3+ (iOS, Android, macOS, Web)
- **State Management:** `flutter_riverpod` v2.x
- **Design & Icons:** `google_fonts` (**Sen** typeface), `lucide_icons`, `cupertino_icons`
- **Networking:** `dio`, `flutter_dotenv`
- **Camera & Hardware:** `camera`, `image_picker`, `image_cropper`
- **PDF Generation & Export:** `pdf`, `printing`, `path_provider`
- **Notifications:** `flutter_local_notifications`, `timezone`

### Backend & AI

- **Backend / Database:** Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`)
- **AI Provider:** Google AI Studio REST API (`gemini-2.0-flash` Vision) — rate-limited to 5 calls/60s
- **Public Drug Registry:** OpenFDA Drug Label API (keyless) — rate-limited to 10 calls/60s

---

## 4. Architecture & Project Structure

Feature-first modular architecture.

```text
lib/
├── core/
│   ├── constants/          # AppConstants (radii, spacing), ApiConstants, FirebaseConstants
│   ├── network/            # DioClient, ApiException
│   ├── services/           # GeminiService (rate-limited), OpenFdaService (rate-limited),
│   │                       # FirestoreService, AuthService, NotificationService, PdfService
│   ├── theme/              # ColorTokens (21n), TextStyles (Sen), AppTheme
│   ├── widgets/            # NeoCard, PillChip, StatusBadge, PrimaryActionButton,
│   │                       # SectionHeader, SkeletonWidgets
│   └── utils/              # DateFormatters, Validators, RateLimiter
├── features/
│   ├── auth/               # LoginScreen, RegisterScreen, RoleSelectionScreen, AuthProvider
│   ├── scanner/            # ScannerScreen, OcrVerificationSheet, ScannerProvider, OcrResult
│   ├── medications/        # HomeScreen, AddMedicationScreen, MedicationDetailScreen,
│   │                       # MedicationsProvider, Medication, AdherenceLog
│   ├── caregiver/          # CaregiverDashboardScreen, CaregiverProvider, CaregiverLink
│   └── passport/           # PassportScreen, PassportProvider, PassportData
├── firebase_options.dart
└── main.dart               # AuthGate, MainAppShell, Charcoal + Cobalt Scan FAB
```

---

## 5. Engineering & Development Rules

1. **State Management:** Always use Riverpod (v2.x). Use `AsyncValue.when(data:, loading:, error:)` for all async UI — the `loading:` callback must use a `SkeletonWidget`, never a bare `SizedBox` or `CircularProgressIndicator`.
2. **Design Fidelity:** Adhere strictly to the **21n design tokens** in `ColorTokens`, `TextStyles`, and `AppConstants`. Never hardcode hex colors or arbitrary padding values.
3. **No Shadows. No Gradients.** Any `boxShadow` or `LinearGradient` in UI code is a design violation. Remove it.
4. **One CTA Color.** Only `ColorTokens.charcoal` is used as a filled button background. Cobalt Signal is accent-only.
5. **Security:** Never commit API keys or secrets. Use `.env` with `flutter_dotenv`. Firebase security rules enforce role-based access.
6. **Rate Limiting:** `RateLimiter.instance.consume('gemini')` must be called before every Gemini Vision call. `consume('openFda')` before every OpenFDA call. Both are enforced in their respective service classes.
7. **Resilience & UX:** All async operations must have: skeleton loading state, error state with message, and offline fallback where applicable.
