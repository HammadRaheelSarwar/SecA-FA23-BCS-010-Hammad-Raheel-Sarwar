# 🚀 Setup & Build Guide

## System Requirements

### Windows System
- Windows 10 or higher
- Administrator privileges (for Flutter setup)
- At least 2GB RAM (recommended 4GB+)
- At least 3GB disk space

### Required Software
- **Flutter SDK**: Download from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
- **Dart SDK**: Included with Flutter
- **Android Studio**: For Android development (optional for web/Windows)
- **Visual Studio Code**: Recommended IDE
- **Git**: For version control

## Installation Steps

### 1. Install Flutter

**Download Flutter:**
```powershell
# Create directory for Flutter
mkdir C:\src
cd C:\src

# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
# Control Panel → System → Advanced System Settings → Environment Variables
# Add: C:\src\flutter\bin
```

**Verify Installation:**
```powershell
flutter --version
dart --version
flutter doctor
```

### 2. Install Dependencies

Navigate to project directory:
```powershell
cd "d:\Android IOs\Lab Assignment 2\game"

# Get all dependencies
flutter pub get

# Check dependencies
flutter pub list

# Analyze project
flutter analyze
```

### 3. Configure Project

The project is already configured with:
- ✅ pubspec.yaml with all dependencies
- ✅ All source files created
- ✅ Database setup automated

## Running the App

### Desktop/Web Development (Quickest)

#### Run on Windows Desktop
```powershell
cd "d:\Android IOs\Lab Assignment 2\game"
flutter run -d windows

# Or specific configuration
flutter run -d windows --debug
```

#### Run on Web
```powershell
flutter run -d chrome

# Or with specific port
flutter run -d web-server --web-port=5000
```

#### Run on Linux
```powershell
flutter run -d linux
```

### Mobile Development

#### Android
```powershell
# Connect Android device or start emulator
adb devices

# Run app
flutter run -d <device-id>

# Or run on all connected devices
flutter run
```

#### iOS (macOS only)
```zsh
flutter run -d ios
```

## Building for Production

### Android APK
```powershell
# Build APK
flutter build apk

# Or split APKs by ABI (smaller downloads)
flutter build apk --split-per-abi

# Location: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Google Play)
```powershell
flutter build appbundle

# Location: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS only)
```zsh
flutter build ios

# Location: build/ios/iphoneos/
```

### Windows Executable
```powershell
flutter build windows

# Location: build/windows/runner/Release/
```

### Web
```powershell
flutter build web

# Location: build/web/
```

## Development Workflow

### Hot Reload (Development)
```powershell
# While app is running, press 'r'
r          # Hot reload (fast, preserves state)
R          # Hot restart (complete restart)
q          # Quit app
```

### Development Mode
```powershell
flutter run --debug
```

### Release Mode
```powershell
flutter run --release
```

### Profile Mode
```powershell
flutter run --profile
```

## Testing

### Run Unit Tests
```powershell
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with verbose output
flutter test --verbose

# Run tests with coverage
flutter test --coverage
```

## Troubleshooting

### Issue: Flutter Command Not Found
```powershell
# Solution: Add Flutter to PATH
$env:Path += ";C:\src\flutter\bin"

# Or set permanently in System Environment Variables
```

### Issue: No Devices Available
```powershell
# Check connected devices
flutter devices

# Enable USB debugging on Android phone
# Device → Settings → Developer Options → USB Debugging

# Or start Android emulator
flutter emulators
flutter emulators launch <emulator-id>
```

### Issue: Build Fails
```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter pub upgrade
flutter run

# Or check for errors
flutter analyze
```

### Issue: Database Not Initializing
```powershell
# Solution: Clear app data
flutter clean

# Delete build artifacts
rm -r build/

# Rebuild
flutter pub get
flutter run

# Or use:
adb shell pm clear com.example.game
```

### Issue: Dependencies Mismatch
```powershell
# Update all dependencies
flutter pub upgrade

# Get latest versions
flutter pub get --upgrade

# Check for conflicts
flutter pub upgrade --major-versions
```

### Issue: Hot Reload Not Working
```powershell
# Use Hot Restart instead
R

# Or restart the app
flutter run
```

## Performance Optimization

### Build in Release Mode (Faster, Smaller)
```powershell
flutter run --release
```

### Reduce Build Time
```powershell
# Use only specific ABIs for Android
flutter build apk --target-platform android-arm64

# Skip tests
flutter build apk --no-analyze
```

### Code Optimization
```powershell
# Enable code shrinking
# (handled automatically by Flutter for release builds)

# Check code quality
dart analyze

# Format code
dart format lib/
```

## Deployment Checklist

Before deploying to production:

- [ ] Update version in `pubspec.yaml`
- [ ] Update app name (if needed)
- [ ] Test on multiple devices
- [ ] Run `flutter analyze` - no errors
- [ ] Check app performance in release mode
- [ ] Verify database operations
- [ ] Test on slow network
- [ ] Check battery usage
- [ ] Verify permissions
- [ ] Create release keystore (Android)
- [ ] Sign app (Android/iOS)
- [ ] Submit to stores

## Android Signing

### Generate Key (First Time Only)
```powershell
# Create keystore
keytool -genkey -v -keystore C:\game-key.keystore `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias game-key

# Will prompt for password and details
```

### Configure Gradle for Signing
Edit `android/app/build.gradle.kts`:
```kotlin
signingConfigs {
    release {
        keyAlias = "game-key"
        keyPassword = "your-key-password"
        storeFile = file("C:/game-key.keystore")
        storePassword = "your-keystore-password"
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.release
    }
}
```

### Build Signed APK
```powershell
flutter build apk --release
```

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Flutter Build
on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk
      - uses: actions/upload-artifact@v2
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/
```

## IDE Setup

### Visual Studio Code

**Install Extensions:**
1. Flutter (official) - DartCode
2. Dart - DartCode
3. SQLite - alexcvzz

**Edit settings.json:**
```json
{
  "dart.flutterSdkPath": "C:\\src\\flutter",
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "editor.defaultFormatter": "Dart-Code.dart-code"
  },
  "dart.lineLength": 100
}
```

### Android Studio

**Install Plugins:**
1. Flutter
2. Dart
3. SQLite

**Configure SDK:**
- File → Settings → Languages & Frameworks → Flutter
- Set Flutter SDK path: `C:\src\flutter`

## Command Reference

| Command | Purpose |
|---------|---------|
| `flutter run` | Run app on connected device |
| `flutter pub get` | Get dependencies |
| `flutter clean` | Clean build artifacts |
| `flutter analyze` | Check code quality |
| `flutter test` | Run unit tests |
| `flutter build apk` | Build for Android |
| `flutter build web` | Build for web |
| `flutter doctor` | Check environment setup |
| `flutter devices` | List connected devices |
| `flutter emulators` | List emulators |

## Database Backup & Recovery

### Backup Database
```powershell
# Database location varies by platform
# Android: /data/data/com.example.game/databases/game_history.db
# Get using adb:
adb pull /data/data/com.example.game/databases/game_history.db
```

### Restore Database
```powershell
adb push game_history.db /data/data/com.example.game/databases/
```

## Useful Resources

- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [sqflite Documentation](https://pub.dev/packages/sqflite)
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow - Flutter Tag](https://stackoverflow.com/questions/tagged/flutter)

## Next Steps

1. ✅ Install Flutter and dependencies
2. ✅ Run `flutter pub get`
3. ✅ Start developing with `flutter run`
4. ✅ Use hot reload for rapid development
5. ✅ Build for production when ready
6. ✅ Deploy to app stores

## Support

For issues or questions:
- Check Flutter [troubleshooting guide](https://flutter.dev/docs/testing/troubleshooting)
- Search [Flutter GitHub Issues](https://github.com/flutter/flutter/issues)
- Post on [Flutter Community](https://flutter.dev/community)
- Check [sqlflite documentation](https://pub.dev/packages/sqflite)

---

**Ready to build and deploy your Number Guessing Game! 🎮🚀**
