# Mini Multitask Manager

This is a small Flutter app implementing a Mini multitask Manager.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Features

### Main features

- Add, edit and delete tasks
- Mark tasks as completed
- Filter by All / Active / Completed
- Store tasks locally in a JSON file (using `path_provider`)
- Simple due date picker

### Extra features

- Prevent saving a task with a duplicate title (case-insensitive)
- Warning badge when a task is due in 1 day ("1 day left")
- Overdue marker shown when the due date has passed (red "Overdue" pill)
- Search tasks (quick in-list search)

## Files added/changed

- `lib/models/task.dart` — Task model with JSON serialization
- `lib/services/task_storage.dart` — local JSON storage using `getApplicationDocumentsDirectory()`
- `lib/task_manager_app.dart` — main UI (tasks list, add/edit dialog, filter)
- `lib/main.dart` — small launcher that runs the app
- `pubspec.yaml` — added `path_provider` dependency

## How to run

1. Ensure Flutter is installed and on your PATH.
2. From the project root run:

```powershell
flutter pub get
flutter run
```

If you cloned the repository elsewhere, or want to get it fresh from a remote repository, you can run:

```powershell
git clone https://github.com/yousefelsonbaty/multitask_manager.git  
cd multitask_manager
# then:
flutter pub get
flutter run
```

## Notes

- The app stores tasks in the app documents directory in a file named `tasks.json`.
- The widget test was updated to use `TaskManagerApp` and verifies the app bar title.
- To take screenshots, run the app on an emulator or device and capture the screen.

## Possible improvements (optional)

- Improve UI styling and animations
- Add unit tests for `TaskStorage` (mock filesystem or use integration tests)

If you want, I can also: add Hive or SQLite storage, add more tests, or polish the UI.

## Build APK (Android)

You can produce an Android APK for distribution or sideloading. The commands below are PowerShell-friendly and assume you have Flutter and the Android toolchain installed.

Build a release APK (optimized):

```powershell
flutter build apk --release
```

Build a debug APK (useful for quick testing):

```powershell
flutter build apk --debug
```

Where the APK is written (example path):

```
build\app\outputs\flutter-apk\app-release.apk
```

I built a release APK and placed a copy in the repository under `releases/` (so you can download it directly from this clone):

[Download MiniTask release APK](./releases/MiniTask-App-release.apk)

Install the APK onto a connected device or emulator:

```powershell
adb install -r build\app\outputs\flutter-apk\app-release.apk
# or using Flutter (installs a debug build by default):
flutter install
```

Notes on signing and Play Store releases:
- A release APK intended for Play Store must be signed with your keystore. Follow the Flutter docs to create a keystore and configure signing in `android/app/build.gradle` / `key.properties`: https://docs.flutter.dev/deployment/android
- For Play Store distribution you may prefer to build an Android App Bundle instead:

```powershell
flutter build appbundle --release
```

Replace the placeholder repository URL above with your own when cloning the repo. If you want, I can add a short paragraph describing how to generate a keystore and configure Gradle signing.

## Demo

A short demo video is included with this repository (if present):

<video controls width="640">
	<source src="./MiniTask%20Demo.mp4" type="video/mp4">
	Your browser does not support the video tag. You can download the demo here: [MiniTask Demo.mp4](./MiniTask%20Demo.mp4)
</video>

If the video file isn't in the repository, replace the `src` above with the correct relative path or upload `MiniTask Demo.mp4` to the repo.
