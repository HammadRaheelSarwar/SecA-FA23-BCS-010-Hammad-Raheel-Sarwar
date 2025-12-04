# Number Guessing Game App

A fully functional Flutter application that implements a Number Guessing Game with SQLite database integration for storing game results.

## Features

### 1. **Game Screen**
- Generate a random number between 1 and 100
- User can input guesses and receive real-time feedback
- Display whether the guess is:
  - ✅ **Correct** - User guessed the number
  - 📈 **Too Low** - Guess is lower than the target number
  - 📉 **Too High** - Guess is higher than the target number
- Track the number of attempts
- Start a new game with a new random number

### 2. **History Screen**
- View all previous game attempts with:
  - Guess number
  - Correct number
  - Status (Correct/Too High/Too Low)
  - Timestamp of each guess
- Delete individual records
- Clear all history with confirmation dialog
- Refresh history to see latest records
- Color-coded status indicators for quick visual reference

### 3. **SQLite Database Integration**
- Persistent storage of all game results
- Automatic database initialization on first run
- CRUD operations (Create, Read, Delete)
- Timestamps for each game attempt

## Project Structure

```
lib/
├── main.dart                 # App entry point with bottom navigation
├── database/
│   └── db_helper.dart       # SQLite database operations
├── models/
│   └── game_result.dart     # GameResult data model
└── screens/
    ├── game_screen.dart     # Main guessing game interface
    └── history_screen.dart  # Game history display
```

## Technologies Used

- **Flutter**: UI framework for cross-platform development
- **sqflite**: SQLite database plugin for Flutter
- **path**: File system path utilities
- **intl**: Internationalization for date/time formatting

## Installation & Setup

### Prerequisites
- Flutter SDK (version 3.10.0 or higher)
- Dart SDK

### Steps to Run

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the application:**
   ```bash
   flutter run
   ```

3. **Build for specific platform:**
   - **Android:**
     ```bash
     flutter build apk
     ```
   - **iOS:**
     ```bash
     flutter build ios
     ```

## How to Use

### Playing the Game
1. Start the app and navigate to the "Play Game" tab
2. Read the instructions: "Guess a number between 1 and 100"
3. Enter your guess in the input field
4. Press "Make Guess" button
5. Receive feedback:
   - Green feedback for correct guess
   - Red feedback for "Too High"
   - Orange feedback for "Too Low"
6. Continue guessing until you find the correct number
7. Once correct, press "Start New Game" to play again

### Viewing History
1. Navigate to the "History" tab using the bottom navigation
2. View all previous game attempts with details:
   - Guess number
   - Correct number
   - Status indicator
   - Date and time
3. **Delete single record:** Tap the trash icon on any record
4. **Clear all history:** Tap the trash icon in the AppBar
5. **Refresh:** Tap the refresh icon to reload the history

## Database Schema

### Table: `game_results`

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PRIMARY KEY | Unique identifier |
| guess | INTEGER | User's guessed number |
| correct_number | INTEGER | The correct number |
| status | TEXT | Result status (Correct/Too High/Too Low) |
| timestamp | TEXT | ISO 8601 formatted date/time |

## Key Implementation Details

### GameResult Model
- Stores individual game attempt data
- Includes conversion methods (toMap/fromMap) for database operations
- Provides formatted timestamp display

### DatabaseHelper (Singleton Pattern)
- Manages all SQLite operations
- Creates database on first run
- Provides methods:
  - `insertGameResult()` - Add new game record
  - `getAllGameResults()` - Retrieve all records
  - `deleteGameResult()` - Delete specific record
  - `deleteAllGameResults()` - Clear all records
  - `getGameResultCount()` - Get total records

### GameScreen Features
- Random number generation using Dart's Random class
- Input validation (checks for valid integers 1-100)
- Real-time feedback with color-coded responses
- Attempt counter
- Auto-insert to database after each guess

### HistoryScreen Features
- FutureBuilder for async database operations
- ListView for displaying game records
- Swipe and delete functionality
- Color-coded status indicators
- Empty state UI when no records exist

## UI/UX Design

### Color Scheme
- **Blue** - Primary actions and game flow
- **Green** - Correct answer feedback
- **Red** - Too high feedback and delete actions
- **Orange** - Too low feedback

### Visual Indicators
- ✅ Check circle icon - Correct
- 📉 Arrow down icon - Too high
- 📈 Arrow up icon - Too low
- 🎉 Celebration emoji - Win message

## Game Rules

1. The game generates a random number from 1 to 100
2. User must guess the number
3. Feedback indicates if the guess is correct, too high, or too low
4. User can make unlimited guesses
5. Game ends when the correct number is guessed
6. Each guess is recorded in the database with timestamp
7. User can start a new game anytime

## Future Enhancements

- Difficulty levels (1-50, 1-500, 1-1000)
- Leaderboard/statistics screen
- Best guess analytics
- Sound effects and haptic feedback
- Multiplayer mode
- Undo/redo functionality
- Export game history

## Troubleshooting

### Database not initializing?
- Clear app data and restart
- Check device storage permissions

### History not updating?
- Tap the refresh button in History screen
- Restart the app

### Input not accepting numbers?
- Ensure keyboard is properly displayed
- Check if number is between 1-100

## License

This project is created for educational purposes as part of a Flutter learning assignment.

## Author

Created as Lab Assignment 2 - Number Guessing Game App

---

**Enjoy playing the Number Guessing Game! 🎮**
