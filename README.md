# Smart Assistant App

A Flutter-based Smart Assistant application featuring chat functionality, suggestions with pagination, and chat history with offline support. Built with **GetX** for state management, dependency injection, and routing.

## Features

- **Home Screen** - Browse AI assistant suggestions with infinite scroll pagination
- **Chat Screen** - Interactive chat UI with typing indicators, slide-in animations, and quick action chips
- **History Screen** - View and manage past chat conversations (persisted offline via Hive)
- **Dark Mode** - Full light/dark theme support with a toggle
- **Offline Storage** - Chat history saved locally using Hive for offline access
- **Animations** - Smooth chat bubble slide-in/fade animations, bouncing typing indicator

## Architecture

This project follows **Clean Architecture** with a feature-first folder structure and **GetX** for state management, DI, and routing.

```
lib/
├── core/
│   ├── di/                  # GetX Bindings (InitialBinding)
│   ├── error/               # Failures & exceptions
│   ├── routes/              # GetX routes (AppRoutes, AppPages)
│   └── theme/               # Light/dark themes & ThemeController
├── features/
│   ├── navigation/
│   │   └── presentation/    # NavigationController, NavigationShell (bottom nav)
│   ├── suggestions/
│   │   ├── domain/          # Entities, Repository (abstract)
│   │   ├── data/            # Models, DataSources, Repository implementation
│   │   └── presentation/    # SuggestionsController, Pages, Widgets
│   ├── chat/
│   │   ├── domain/          # Entities, Repository (abstract)
│   │   ├── data/            # Models, DataSources, Repository implementation
│   │   └── presentation/    # ChatController, Pages, Widgets
│   └── history/
│       └── presentation/    # HistoryController, Pages
└── main.dart
```

### Layers

| Layer | Responsibility |
|-------|---------------|
| **Domain** | Entities, abstract repositories (pure Dart, no framework dependencies) |
| **Data** | Models (JSON parsing), data sources (remote mock + local Hive), repository implementations |
| **Presentation** | GetX Controllers, UI screens, reusable widgets |

### State Management (GetX)

- `ThemeController` - Toggles light/dark mode via `Get.changeThemeMode()`
- `SuggestionsController` - Handles paginated suggestion loading with `.obs` reactive variables
- `ChatController` - Manages chat messages, sending, and local persistence
- `HistoryController` - Loads and clears offline chat history
- `NavigationController` - Manages bottom navigation tab switching

### Dependency Injection (GetX Bindings)

All dependencies are registered in `InitialBinding` using `Get.lazyPut()` with `fenix: true` for automatic recreation:
- Data Sources → Repositories → Controllers

## Tech Stack

| Package | Purpose |
|---------|---------|
| `get` | State management, DI, routing (GetX) |
| `dio` | HTTP client (ready for real API integration) |
| `hive` / `hive_flutter` | Offline local storage for chat history |
| `shimmer` | Loading skeleton animations |
| `intl` | Date/time formatting |

## Setup & Run

### Prerequisites
- Flutter SDK (3.7.x or compatible)
- Dart SDK (2.19.x)

### Steps

```bash
# Clone the repository
git clone <repo-url>
cd smart_assistant

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build

```bash
# Android APK
flutter build apk

# iOS
flutter build ios
```

## API Simulation

Since no real backend exists, the app uses **mock data sources** that simulate API behavior:

- **GET /suggestions** - Returns 50 suggestions with pagination (10 per page), with simulated network delay
- **POST /chat** - Returns context-aware responses based on keywords (Flutter, Dart, BLoC, etc.)
- **GET /chat/history** - Returns sample conversation history

The mock data sources can be easily swapped with real HTTP implementations by replacing the data source classes.

## Bonus Features Implemented

- [x] Offline chat history (Hive)
- [x] Dark mode support
- [x] Chat animations (bubble slide-in, typing indicator)
- [x] Shimmer loading skeletons
- [x] Pull-to-refresh on suggestions
- [x] Quick action chips in empty chat state
