<div align="center">

<img src="https://img.shields.io/badge/Flutter-3.27+-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Dart-3.3+-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge" />
<img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" />
<img src="https://img.shields.io/badge/Version-1.0.0-blue?style=for-the-badge" />

<br /><br />

# 🌿 Aaroha

### *Rise, one day at a time.*

**A privacy-first, compassionate recovery support app for people overcoming addiction — built for India.**

[Features](#-features) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack) • [Getting Started](#-getting-started) • [Architecture](#-architecture) • [Privacy](#-privacy)

</div>

---

## 🌱 What is Aaroha?

Aaroha is a free, anonymous mobile application designed to support individuals on their de-addiction and sobriety journey. Built with a deep respect for privacy and the unique challenges faced by people in India, Aaroha combines AI-powered companionship, breathwork tools, a recovery tracker, and local resource discovery — all without requiring an account or storing any personally identifiable information on a server.

> *"Every moment sober is a victory worth celebrating."*

---

## ✨ Features

### 🚶 My Aaroha — Tracker
- **Sobriety streak counter** with animated hero display
- **Daily goal cards** — morning check-ins, breathwork, AI companion chat, meditation
- **Milestone badge system** — First Step, Bronze Seed, Gold Branch, Golden Year, and more
- **Progress stats** — hours sober, money saved, best streak, badges earned
- **Streak restart** with compassionate, non-judgmental UX
- **Smart notifications** — incomplete goal reminders, daily quotes, badge achievements, event reminders

### 🤖 Swasthi — AI Companion
- Conversational AI companion powered by **Groq (LLaMA 3.3 70B)**
- Scoped strictly to recovery and mental wellness topics
- **Mood check-in strip** — Anxious → Great with emoji feedback
- **Quick-action suggestion chips** — grounding, breathwork, craving help, hope
- **Anonymous by default** — no data stored, no history persisted
- Crisis escalation to national helplines (iCall, NIMHANS, Vandrevala Foundation)

### 🧘 Shanti Space — Calm & Breathwork
- **4-7-8 Breathing** and **Box Breathing** orb with animated expand/contract cycles
- **Voice guidance** via text-to-speech (toggle on/off)
- **Soothing soundscapes** — Rain, Forest, Ocean, Night (MP3 asset-based)
- **Craving Journal** — anonymous, in-memory, not persisted
- **Recovery Reads** — curated articles on cravings, mindfulness, neuroscience, and relationships

### ☀️ Ujjwal Feed — Inspiration
- **Daily affirmation card** with save-to-journal action
- **Featured recovery stories** with author attribution and read-time
- **Quote grid** with like/heart interactions
- **Hope Wall** — anonymous peer-shared messages of encouragement
- Filter by: All, Quotes, Stories, Videos, Hope Wall

### 🗺️ Sangam + Sahara — Community & Resources
- **OpenStreetMap integration** (flutter_map) — no Google Maps API key required
- **Live location detection** with graceful permission handling
- **Recovery centre cards** — hospitals, NGOs, rehab centres with open/closed status, one-tap call, and directions
- **Upcoming events** — online and in-person, with one-tap join registration
- **One-tap helplines** — Vandrevala Foundation (24/7 free), iCall, NIMHANS, NADA
- **SOS crisis modal** — accessible from every screen via floating button and app bar

### 📚 Awareness Hub
- Featured stories, tips, resources, programs
- Weekly reflection CTA
- Filterable content grid by category

### 👤 Profile & Settings
- Display name, quitting substance, sobriety start date
- Daily check-in time customization (morning/evening)
- Improvement goals (up to 3)
- Sobriety importance rating
- Full activity stats grid (12 tracked metrics)
- Reset stats / Sign out & reset with local data wipe

---

## 📱 Screenshots

### Onboarding

<p align="center">
  <img src="screenshots/01_welcome.jpg" width="180" alt="Welcome Screen"/>
  <img src="screenshots/02_user_type.jpg" width="180" alt="User Type Selection"/>
  <img src="screenshots/03_privacy.jpg" width="180" alt="Privacy Consent"/>
  <img src="screenshots/04_what_quitting.jpg" width="180" alt="What Are You Quitting"/>
</p>
<p align="center">
  <img src="screenshots/05_sober_date.jpg" width="180" alt="Sober Start Date"/>
  <img src="screenshots/06_onboarding_summary.jpg" width="180" alt="Onboarding Summary"/>
</p>

---

### 🚶 My Aaroha — Tracker

<p align="center">
  <img src="screenshots/07_tracker.jpg" width="180" alt="Tracker - Streak and Goals"/>
  <img src="screenshots/08_tracker_stats.jpg" width="180" alt="Tracker - Progress Stats"/>
</p>

---

### 🤖 Swasthi — AI Companion

<p align="center">
  <img src="screenshots/09_swasthi_chat.jpg" width="180" alt="Swasthi AI Chat"/>
  <img src="screenshots/10_sos_modal.jpg" width="180" alt="SOS Crisis Modal"/>
</p>

---

### 🧘 Shanti Space — Calm & Breathwork

<p align="center">
  <img src="screenshots/11_shanti_breathwork.jpg" width="180" alt="Shanti Breathwork Orb"/>
  <img src="screenshots/12_shanti_soundscapes.jpg" width="180" alt="Shanti Soundscapes and Journal"/>
</p>

---

### ☀️ Ujjwal Feed — Inspiration

<p align="center">
  <img src="screenshots/13_ujjwal_feed.jpg" width="180" alt="Ujjwal Feed"/>
  <img src="screenshots/14_ujjwal_quotes.jpg" width="180" alt="Daily Quotes"/>
  <img src="screenshots/15_hope_wall.jpg" width="180" alt="Hope Wall"/>
</p>

---

### 🗺️ Sangam + Sahara — Community & Resources

<p align="center">
  <img src="screenshots/16_sangam_map.jpg" width="180" alt="Sangam Map View"/>
  <img src="screenshots/17_sangam_centres.jpg" width="180" alt="Recovery Centres Near You"/>
  <img src="screenshots/18_sangam_events.jpg" width="180" alt="Upcoming Events and Helpline"/>
</p>

---

### 👤 Profile

<p align="center">
  <img src="screenshots/19_profile.jpg" width="180" alt="My Profile"/>
  <img src="screenshots/20_profile_preferences.jpg" width="180" alt="Profile Preferences"/>
  <img src="screenshots/21_drawer.jpg" width="180" alt="Navigation Drawer"/>
  <img src="screenshots/22_edit_profile.jpg" width="180" alt="Edit Profile"/>
</p>
```


## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.27+ / Dart 3.3+ |
| **State Management** | Riverpod 2.x (Notifier pattern) |
| **Navigation** | GoRouter 13 with StatefulShellRoute |
| **AI Companion** | Groq API — LLaMA 3.3 70B Versatile |
| **Local Storage** | Hive Flutter (typed boxes, Hive adapters) |
| **Maps** | flutter_map + OpenStreetMap tiles (no API key) |
| **Location** | Geolocator |
| **Notifications** | flutter_local_notifications + timezone |
| **TTS** | flutter_tts (voice guidance for breathwork) |
| **Audio** | audioplayers (soundscapes) |
| **Typography** | Manrope (display) + Inter (body) via Google Fonts |
| **Animations** | flutter_animate |
| **HTTP** | http package |
| **Environment** | flutter_dotenv |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.27.0
- Dart ≥ 3.3.0
- Android Studio / Xcode (for device builds)
- A [Groq API key](https://console.groq.com) (free tier available)

### 1. Clone the repository

```bash
git clone https://github.com/your-username/aaroha.git
cd aaroha/aaroha
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate Hive adapters

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Set up environment variables

Create a `.env` file in the root of the `aaroha/` project directory:

```env
GROQ_API_KEY=your_groq_api_key_here
```

> ⚠️ Never commit your `.env` file. It is already listed in `.gitignore`.

### 5. Add font assets

Download and place in `assets/fonts/`:

```
assets/fonts/
├── Manrope-Regular.ttf
├── Manrope-SemiBold.ttf
├── Manrope-Bold.ttf
└── Manrope-ExtraBold.ttf
```

> Fonts can be downloaded from [Google Fonts — Manrope](https://fonts.google.com/specimen/Manrope). Alternatively, remove the font block from `pubspec.yaml` to use the runtime Google Fonts loader.

### 6. Add audio assets (optional)

For soundscapes to work, add `.mp3` files to `assets/audio/`:

```
assets/audio/
├── rain.mp3
├── forest.mp3
├── ocean.mp3
└── night.mp3
```

### 7. Create required asset directories

```bash
mkdir -p assets/images assets/icons assets/animations assets/audio
```

### 8. Run the app

```bash
flutter run
```

---

## 🏗 Architecture

```
lib/
├── main.dart                          # Entry point — Hive init, notifications, routing
├── core/
│   ├── constants/app_constants.dart   # Spacing, radii, helplines, Hive keys
│   ├── services/notification_service.dart
│   ├── theme/
│   │   ├── app_colors.dart            # Full Material 3 color token set
│   │   ├── app_text_styles.dart       # Manrope + Inter typescale
│   │   └── app_theme.dart             # ThemeData
│   ├── utils/app_router.dart          # GoRouter + StatefulShellRoute
│   └── widgets/
│       ├── app_shell.dart             # Persistent shell (drawer, nav, FAB)
│       ├── aaroha_app_bar.dart
│       ├── aaroha_drawer.dart
│       ├── shared_widgets.dart        # GradientButton, TappableCard, chips
│       └── sos_bottom_sheet.dart      # Crisis modal
│
└── features/
    ├── tracker/                       # Streak + daily goals
    ├── swasthi/                       # AI chat companion
    ├── shanti/                        # Breathwork + calm tools
    ├── ujjwal/                        # Feed + quotes + Hope Wall
    ├── sangam/                        # Map + centres + events
    ├── hub/                           # Awareness hub
    ├── profile/                       # User model, stats, edit profile
    └── onboarding/                    # Welcome → user type → questionnaire → summary
```

### Design System — *The Living Sanctuary*

| Token | Value |
|-------|-------|
| Primary (Action) | `#005440` |
| Surface (Base) | `#FCF9F5` |
| Tertiary (Urgency / SOS) | `#832C0E` |
| Mint Accent | `#E1F5EE` |
| Ambient Shadow | 24px blur, 6% opacity |
| Border Radius (main) | 24pt (`radiusLg`) |

**Key design rules:**
- No 1px solid borders — depth via tonal surface shifts
- No pure black (`#000000`) — use `onSurface` `#1B1C1A`
- Glassmorphism for floating elements
- Gradient CTA buttons (135° primary → primaryContainer)
- `rounded-xl` (24pt) on all main containers

---

## 🔔 Notification Features

| Notification | Trigger |
|---|---|
| Daily affirmation quote | Scheduled 8:00 AM every day |
| Incomplete goal reminder | Noon if goals remain undone |
| Goal completed celebration | Fires immediately on completion |
| Badge earned | On streak milestone (1, 3, 7, 14, 21, 30, 60, 90, 180, 365 days) |
| Event reminder | 24 hours before registered events |

---

## 🔒 Privacy

Aaroha is built with privacy as a foundational principle, not an afterthought.

- **Anonymous by default** — no sign-up, no email, no phone number required
- **All data stays on device** — stored in Hive (local SQLite-like storage)
- **AI chats are not saved** — Swasthi's conversation history is in-memory only
- **Craving journal is not persisted** — released and gone when you close it
- **No analytics SDKs** — no Firebase Analytics, no Mixpanel, no Amplitude
- **No ads** — ever
- **Age gate** — users confirm they are 18+ during onboarding consent

---

## 🆘 Crisis Support

Aaroha provides immediate access to Indian mental health and de-addiction helplines:

| Organisation | Number | Availability |
|---|---|---|
| iCall (TISS) | 9152987821 | Weekdays |
| NIMHANS | 080-46110007 | Weekdays |
| Vandrevala Foundation | 1800-599-0019 | 24/7 · Free |
| NADA Helpline | 14446 | Business hours |

> The SOS button is always visible in the top bar and as a floating action button.

---

## 🗺 Roadmap

- [ ] Firestore backend for Ujjwal Feed (real content)
- [ ] Google Maps integration option for Sangam (alongside OSM)
- [ ] Multilingual support — Hindi, Malayalam, Tamil
- [ ] Push notifications via Firebase Cloud Messaging
- [ ] Family/supporter mode with shared progress view
- [ ] Offline-first data sync
- [ ] Community events RSVP backend
- [ ] Counsellor connect feature

---

## 🤝 Contributing

Contributions are welcome! This project exists to help people in one of the most vulnerable moments of their lives. Please open an issue before submitting a PR, and ensure your changes respect the privacy-first principles of the app.

```bash
# Fork the repo, then:
git checkout -b feature/your-feature-name
git commit -m "feat: describe your change"
git push origin feature/your-feature-name
# Open a Pull Request
```

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

<div align="center">

**Built with 💚 for recovery, resilience, and rising — one day at a time.**

*If you or someone you know is struggling, please reach out to a helpline. You are not alone.*

</div>
