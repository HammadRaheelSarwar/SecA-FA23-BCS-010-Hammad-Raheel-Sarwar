# 🎮 Number Guessing Game - Quick Start Guide

## ✅ Installation

```bash
# Navigate to the project directory
cd "d:\Android IOs\Lab Assignment 2\game"

# Get Flutter dependencies
flutter pub get
```

## 🚀 Run the App

```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

## 📁 Project Files Created/Modified

### New Files:
- ✅ `lib/database/db_helper.dart` - SQLite database management
- ✅ `lib/models/game_result.dart` - Data model for game records
- ✅ `lib/screens/game_screen.dart` - Main game interface
- ✅ `lib/screens/history_screen.dart` - Game history viewer
- ✅ `APP_DOCUMENTATION.md` - Full documentation

### Modified Files:
- 📝 `lib/main.dart` - Updated to implement navigation
- 📝 `pubspec.yaml` - Added dependencies (sqflite, path, intl)

## 🎯 How the App Works

### Game Flow:
1. **Start App** → Shows Game Screen by default
2. **Enter Guess** → Input a number between 1-100
3. **Get Feedback** → See if too high/low/correct
4. **View History** → Switch to History tab to see all attempts
5. **Manage Records** → Delete individual or all records

### Database:
- Automatically created on first run
- Stores all guess attempts with timestamps
- Persists even after app restart

## 🎨 Features at a Glance

| Feature | Location | Purpose |
|---------|----------|---------|
| Random Number | GameScreen | Core game logic |
| Input Validation | GameScreen | Ensure 1-100 range |
| Color Feedback | GameScreen | Visual result indication |
| Database Storage | DatabaseHelper | Persistent data |
| History View | HistoryScreen | Review past games |
| Delete Records | HistoryScreen | Manage data |

## 🔧 Technical Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart
- **Database**: SQLite (sqflite)
- **UI Pattern**: Material Design 3
- **State Management**: StatefulWidget

## 📱 Supported Platforms

- ✅ Android (API 16+)
- ✅ iOS (11.0+)
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🐛 Common Commands

```bash
# Clean build
flutter clean
flutter pub get

# Check for errors
flutter analyze

# Format code
dart format lib/

# Run tests (if available)
flutter test

# Build APK for Android
flutter build apk

# Build IPA for iOS
flutter build ios

# Build Web
flutter build web
```

## 📊 Database Details

**Table Name**: `game_results`

```sql
CREATE TABLE game_results(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  guess INTEGER NOT NULL,
  correct_number INTEGER NOT NULL,
  status TEXT NOT NULL,
  timestamp TEXT NOT NULL
)
```

## ✨ Key Highlights

✅ **Full SQLite Integration** - All game results are saved
✅ **Real-time Feedback** - Immediate response to guesses
✅ **Game History** - Complete record of all attempts
✅ **Beautiful UI** - Material Design with color coding
✅ **Data Persistence** - Data survives app restart
✅ **Delete Functionality** - Manage game records
✅ **Input Validation** - Prevents invalid entries
✅ **Responsive Design** - Works on all screen sizes

## 🎓 Learning Points

This project demonstrates:
- SQLite database implementation in Flutter
- State management with StatefulWidget
- Bottom navigation between screens
- Material Design UI patterns
- Date/time handling with intl package
- Dialog boxes for user confirmation
- FutureBuilder for async operations
- Input validation and error handling

## 📞 Troubleshooting

| Issue | Solution |
|-------|----------|
| Dependencies not found | Run `flutter pub get` |
| Database errors | Delete app and reinstall |
| UI not displaying | Run `flutter clean` then `flutter run` |
| Slow performance | Use release mode: `flutter run --release` |

## 🎮 Game Rules Summary

1. App generates random number 1-100
2. You have unlimited guesses
3. Get feedback: Correct, Too High, or Too Low
4. Each guess is saved with timestamp
5. View all history in History tab
6. Delete records as needed
7. Start new game to reset counter

---

**Ready to play? Run `flutter run` and enjoy! 🚀**
