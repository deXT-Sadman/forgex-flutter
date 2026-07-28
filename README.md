# ForgeX Task Manager App (CLIENT SIDE)📝

A modern, offline-first To-Do app built with Flutter — featuring authentication, a MongoDB-backed REST API layer, full task CRUD, light/dark theming, and profile management.

![Flutter](https://img.shields.io/badge/Flutter-3.44.1-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.12.1-0175C2?logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

- **Splash Screen** with animated logo placeholder and session-aware routing
- **Authentication** — sign in, sign up, and forgot password, all backed by a REST API
- **Bottom Navigation** — Home, In Progress, Completed, and Cancel tabs
- **Modern Home Dashboard** — status summary, light/dark theme toggle, tap-to-open profile avatar
- **Profile Management** — update username, password, and profile picture
- **Full Task CRUD** — create, read, update, delete, with priority levels and due dates
- **Offline-First Support** — optimistic UI, SharedPreferences caching, and background sync once reconnected

## 📱 Screenshots

| Splash | Login | Forgot Password | Sign Up |
|--------|------|---------------|-----------------|
| ![](screenshots/splash.png) | ![](screenshots/login.png) | ![](screenshots/forgotPassword.png) | ![](screenshots/SignUp.png) |

| Home Dark | Home Light | Home Features | Progress Screen |
|--------|---------------|--------------|--------------|
| ![](screenshots/home.png) | ![](screenshots/Home2.png) | ![](screenshots/Home3.png) | ![](screenshots/progress.png) |

| Completed Screen | Cancelled Screen | Add Task Screen | Edit Task Screen |
|--------|---------------|--------------|--------------|
| ![](screenshots/completed.png) | ![](screenshots/cancel.png) | ![](screenshots/addTask.png) | ![](screenshots/edit.png) |

| Edit Profile Screen1 | Edit Profile Screen2 | Log Out Screen |
|---------------|--------------|--------------|
| ![](screenshots/edit1.png) | ![](screenshots/edit2.png) | ![](screenshots/logout.png) |

---

## 🏗️ Architecture

```
lib/
├── main.dart                     # App entry point, provider wiring, theming
├── models/                       # Task & User models with MongoDB-shaped JSON (de)serialization
├── services/                     # HTTP calls (auth, tasks) + SharedPreferences wrapper
├── providers/                    # App state: AuthProvider, TaskProvider, ThemeProvider
├── screens/
│   ├── auth/                     # Login, Signup, Forgot Password
│   ├── home/                     # Home (bottom nav) + filtered task list
│   ├── profile/                  # Profile view + edit
│   └── tasks/                    # Add/Edit task
├── widgets/                      # Reusable UI: text field, button, task card
└── utils/                        # Theme (color system + typography) & app-wide constants
```

This follows a layered architecture: **models** are pure data shapes, **services** talk to the network/disk and know nothing about UI, **providers** hold state and decide what the UI shows, and **screens/widgets** only read providers and call their methods. Swapping the backend later only touches `services/`.

## 🔧 Tech Stack

| Layer | Package |
|---|---|
| State management | `provider` |
| Networking | `http` |
| Offline cache | `shared_preferences` |
| Profile picture | `image_picker` |
| Typography | `google_fonts` |
| Date formatting | `intl` |
| Offline task IDs | `uuid` |

## ⚙️ Backend requirement

Flutter can't talk to MongoDB directly — there's no safe client-side driver. This app expects a small REST API in front of MongoDB (e.g. **Node.js + Express + Mongoose**) exposing:

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/auth/login` | returns `{ user, token }` |
| POST | `/auth/signup` | returns `{ user, token }` |
| POST | `/auth/forgot-password` | sends a reset email |
| PATCH | `/users/me/:userId` | update username/password/avatar |
| GET | `/tasks` | list the current user's tasks |
| POST | `/tasks` | create a task |
| PUT | `/tasks/:id` | update a task |
| DELETE | `/tasks/:id` | delete a task |

Point the app at your deployed API in one place:
```dart
// lib/utils/constants.dart
class ApiConfig {
  static const String baseUrl = 'https://your-api-domain.com/api';
  ...
}
```

## 🚀 Getting Started

```bash
git clone https://github.com/deXT-Sadman/forgex.git
cd forgex
flutter pub get
flutter run
```

### iOS: photo picker permission
Add to `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Doify needs access to your photos to set a profile picture.</string>
```

## 📴 Offline Support

`TaskProvider` is offline-first:
1. On load, cached tasks from `SharedPreferences` render immediately.
2. It then tries the network; on success, the cache refreshes.
3. Creating/editing/deleting a task updates the cache instantly (optimistic UI) and flags the task `isSynced: false` if the network call fails.
4. Pull-to-refresh calls `TaskProvider.syncPending()`, which retries any unsynced tasks.

## 🎨 Design

The color palette is an analogous + accent scheme: indigo (primary, focused/productive), teal (secondary, progress), and amber (accent, warmth/contrast) — defined once in `lib/utils/app_theme.dart` and applied globally via `ThemeData`, so light/dark mode requires no per-widget conditionals.

## 📌 Roadmap / Next Steps

- [x] Deploy a real Node.js/Express + MongoDB backend
- [ ] `connectivity_plus` for automatic reconnect-triggered syncing
- [ ] Real image upload (S3/Cloudinary) instead of local-only profile pictures
- [ ] Push notifications for due-date reminders
- [ ] `flutter_launcher_icons` for a real app icon

## 📄 License

MIT — feel free to use this project as a learning reference or a starting point for your own app.

---

Built as a 5-day guided learning project — see the commit history for a day-by-day build log.
