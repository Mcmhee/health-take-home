# 🩺 Health Tracker – Take-Home Project

A lightweight health tracking app built with **Flutter**, **Riverpod**, **Hive**, and **Supabase**.

It’s designed to be offline-first, snappy, and simple — you can jot down how you’re feeling each day, keep it on your device, and sync with the cloud whenever you’re online.

---

## ✨ Features

- **Add daily health entries**
  - Date (defaults to today, but editable)
  - Mood (radio options)
  - Optional note
- **View your history**
  - Clean list view
  - Newest entries at the top
- **Offline-first persistence**
  - Data stored locally in Hive
  - Survives app restarts
- **Cloud sync with Supabase**
  1. On startup → fetch new entries from backend, merge with local
  2. On new entry → save locally **and** push to backend
  3. If offline → keep locally, sync later when back online
- **Extras**
  - Weekly mood summary screen
  - Simple bar chart visualization (powered by `fl_chart`)

## 🤔 Why this stack?

- **Riverpod 2 (Notifiers)**
  - Clean, testable state management (no messy singletons)
  - Async-friendly, scales with app complexity
  - Works great with immutable state
- **Hive for local storage**
  - Fast and type-safe
  - Runs on mobile **and** web
  - Perfect fit for key/value entry storage
- **Supabase for backend**
  - Hosted Postgres + REST out of the box
  - Quick to set up for this take-home scenario

## 🏗️ Architecture at a glance

- **Models**
  - `UserModel`
  - `HealthEntryModel` (with Hive adapters in `models/`)
- **Persistence**
  - `HiveService` → handles opening boxes, upserts, bulk saves, marking entries as synced
- **Network/Sync**
  - `SupabaseService` → CRUD wrappers + `syncEntries()` to reconcile local/remote
- **Connectivity**
  - `NetworkService` → uses `connectivity_plus` + DNS ping to check online status
- **Screens**
  - `WelcomeView` → capture/restore user and move to Dashboard
  - `Dashboard` → list entries, add/delete, trigger sync on load
  - `AddView` → input form (date, mood, note)
  - `SummaryView` → weekly mood counts + chart

## Running the project

Prereqs: Flutter SDK, iOS/Android tooling, and optionally Supabase project keys.

1. Set Supabase keys

Add your Supabase URL and anon key to `lib/util/secret.dart`:

```dart
const supabaseUrl = 'https://YOUR-PROJECT.supabase.co';
const supabaseKey = 'YOUR-ANON-KEY';
```

Create tables:

```
users(id uuid primary key, name text, device_id text unique);
health_entries(id uuid primary key, user_id uuid references users(id), date timestamptz, mood text, note text, synced boolean);
```

2. Get packages and run

```bash
flutter pub get
flutter run
```

## Platform Supported

Ios
Android
Web
PWA

## Error handling and offline behavior

- If no internet at app start, Dashboard shows locally stored entries only.
- New entry while offline is saved locally with `isSynced=false`. On next connectivity, sync attempts run from Dashboard; successful server creates are marked locally as synced.
- Basic Snackbar messages are shown on important actions.

## Time spent

~8–10 hours across setup, modeling, UI, sync, and polish.

## What I like

- Clear separation of concerns (services vs. views/view models).
- Riverpod Notifiers make state transitions easy to follow.
- Offline‑first flow with later sync keeps UX responsive.

## What I’d change with more time

- Add integration/unit tests and e2e tests.
- Conflict resolution for edits/deletes across devices.
- Background sync with connectivity listener and debounce.
- More robust error/exception mapping and logging.
- i18n and a11y improvements; theming polish; dark mode charts.

## How I’d test

- Unit tests: `mergeEntries`, `HiveService.markEntriesSynced`, `SupabaseService.syncEntries` happy/edge cases.
- Widget tests: AddView save button enable/disable, Dashboard list ordering, delete confirmation flow.
- Integration: Mock Supabase client and connectivity to validate offline/online transitions and sync marking.

## Notes

- Ordering: entries are stored and displayed newest first via sorting in `HiveService.getAllEntries()`; avoid extra reversals.
- Data model: `HealthEntryModel` includes `isSynced` to support offline-first behavior.

## Tests

This repo includes lightweight, fast unit tests focused on pure logic (no Hive or Supabase), so they run quickly and deterministically.

What’s covered:

- `test/helper_test.dart`
  - `mergeEntries` deduplicates by `id`, prefers the latest record, and sorts results in reverse chronological order (newest first).
  - `countWeeklyMoods` normalizes mood text (trim/lowercase) and counts only entries within the last 7 days.
- `test/summary_view_model_test.dart`
  - Sanity check for weekly mood counts using the same counting helper.

Run all tests:

```bash
flutter test
```

Run a single file:

```bash
flutter test test/helper_test.dart
```

Run a single test by name (useful when iterating):

```bash
flutter test --plain-name "deduplicates by id and keeps newest first"
```

Notes:

- These tests import `flutter_test` only; no device/emulator is required.
- They validate core business logic independent of UI and storage layers.

## Gallery (Updated Screenshots)

These are the latest screenshots you added under `assets/`:

<div>

![Screen 1](/assets/1.png)

![Screen 2](/assets/2.png)

![Screen 3](/assets/3.png)

![Screen 4](/assets/4.png)

</div>
