# Copilot instructions

## Project overview

This is a Flutter/Dart LMS app using Riverpod for state, Firebase Authentication and Cloud Firestore for user/course data, and a public GitHub Releases API for announcements. The application starts in `lib/main.dart`, initializes Firebase with `DefaultFirebaseOptions`, and wraps the app in a Riverpod `ProviderScope`.

The code is organized by feature and data responsibility:

- `lib/features/auth/` owns authentication screens, the auth provider/notifier, and its feature-local `AuthRepository`.
- `lib/features/courses/` owns the home and course-detail screens plus the providers those screens consume.
- `lib/features/quiz/` contains the quiz UI and scoring flow.
- `lib/data/models/` and `lib/data/repositories/` hold shared course, progress, and announcement models and their data access.

The home screen watches Firestore streams for courses and user progress and a `FutureProvider` for announcements. Selecting a course opens its video detail screen; completing its quiz saves progress for the signed-in user. Keep data access in repositories and expose it to UI through providers, following the existing feature ownership.

## Data and state conventions

- Providers are declared alongside their feature in `providers/`; repository providers construct repositories, and stream/future providers delegate to repository methods. UI reads reactive state with `ref.watch` and uses `AsyncValue.when` to render loading, data, and error states.
- The project currently uses Riverpod 2 APIs such as `Provider`, `StreamProvider`, `FutureProvider`, and `StateNotifierProvider`. Follow the existing style rather than introducing generated providers or a different state-management pattern.
- Course documents live in the Firestore `courses` collection and use `title`, `description`, `thumbnailUrl`, `videoUrl`, and `duration` fields.
- Quiz progress is stored at `users/{uid}/progress/{courseId}`. Keep the `Progress` model's serialized fields (`courseId`, `courseTitle`, `score`, `totalQuestions`, and `completedAt`) consistent with the repository and screens.
- Announcements come from the Flutter GitHub releases endpoint; `Announcement.fromJson` maps the release name/tag and first body line for display.
- Preserve the app's existing dark visual palette when modifying screens: navy `#0D1B2A` backgrounds and blue `#2979FF` accents.

## Firebase setup

Use a Firebase project with Email/Password Authentication and Cloud Firestore enabled. Follow the setup notes in `README.md` and configure the platform Firebase options for the environment being used. `android/app/google-services.json` is intentionally ignored; use a local project-specific file and do not commit it or other credentials.

## Build, test, and lint

Run these commands from the repository root:

```sh
flutter pub get
flutter run
flutter analyze
dart format lib test
flutter test
```

Run one test by name (replace the example name with the test's exact name):

```sh
flutter test test/widget_test.dart --plain-name "Counter increments smoke test"
```

The current `test/widget_test.dart` is still Flutter's counter-template smoke test rather than an LMS test; update it to match the app before relying on its assertions. There is no separate lint script; `flutter analyze` uses the `flutter_lints` rules in `analysis_options.yaml`.

Build a platform target when needed:

```sh
flutter build apk
flutter build web
```
