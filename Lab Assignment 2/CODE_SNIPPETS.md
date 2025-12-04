# 🔍 Code Snippets & Examples

## Key Implementation Highlights

### 1. Database Helper - Singleton Pattern

```dart
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;  // Always returns same instance
  }

  DatabaseHelper._internal();
  
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }
}
```

**Why Singleton?** - Ensures only one database connection exists, improving performance and preventing conflicts.

---

### 2. Random Number Generation

```dart
void _initializeGame() {
  _correctNumber = Random().nextInt(100) + 1;  // Generates 1-100
  _guessCount = 0;
  _feedback = 'Guess a number between 1 and 100';
  _isGameWon = false;
}
```

**How it works:**
- `Random().nextInt(100)` generates 0-99
- Adding 1 makes it 1-100

---

### 3. Input Validation & Guess Logic

```dart
void _makeGuess() {
  final String input = _guessController.text.trim();
  
  if (input.isEmpty) {
    // Show error
    return;
  }

  try {
    final int guess = int.parse(input);

    if (guess < 1 || guess > 100) {
      setState(() {
        _feedback = 'Please enter a number between 1 and 100';
        _feedbackColor = 'error';
      });
      return;
    }

    _guessCount++;

    // Compare guess with target
    if (guess == _correctNumber) {
      status = 'Correct';
    } else if (guess > _correctNumber) {
      status = 'Too High';
    } else {
      status = 'Too Low';
    }

    // Save to database
    final GameResult gameResult = GameResult(
      guess: guess,
      correctNumber: _correctNumber,
      status: status,
      timestamp: DateTime.now(),
    );
    _dbHelper.insertGameResult(gameResult);

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid number')),
    );
  }
}
```

**Key Points:**
- ✅ Input trim() removes whitespace
- ✅ Try-catch handles parsing errors
- ✅ Range validation (1-100)
- ✅ Three-way comparison (==, >, <)
- ✅ Saves after validation

---

### 4. GameResult Model - Mapping

```dart
class GameResult {
  final int? id;
  final int guess;
  final int correctNumber;
  final String status;
  final DateTime timestamp;

  // Convert object to database format
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'guess': guess,
      'correct_number': correctNumber,
      'status': status,
      'timestamp': timestamp.toIso8601String(),  // Converts DateTime to string
    };
  }

  // Convert database format to object
  factory GameResult.fromMap(Map<String, Object?> map) {
    return GameResult(
      id: map['id'] as int?,
      guess: map['guess'] as int,
      correctNumber: map['correct_number'] as int,
      status: map['status'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),  // Parse string back to DateTime
    );
  }
}
```

**Why needed?**
- Database stores data as strings/basic types
- Objects need conversion to/from database format

---

### 5. Database Table Creation

```dart
Future<void> _createDatabase(Database db, int version) async {
  await db.execute('''
    CREATE TABLE game_results(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      guess INTEGER NOT NULL,
      correct_number INTEGER NOT NULL,
      status TEXT NOT NULL,
      timestamp TEXT NOT NULL
    )
  ''');
}
```

**Schema Details:**
- `id` - Auto-increments, unique for each record
- `NOT NULL` - Fields must have values
- `TEXT` - Stores timestamp as ISO 8601 string

---

### 6. Database CRUD Operations

```dart
// CREATE - Insert new record
Future<int> insertGameResult(GameResult gameResult) async {
  final Database db = await database;
  return await db.insert(
    _tableName,
    gameResult.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// READ - Get all records
Future<List<GameResult>> getAllGameResults() async {
  final Database db = await database;
  final List<Map<String, Object?>> maps = await db.query(
    _tableName,
    orderBy: '$columnTimestamp DESC',  // Newest first
  );
  return List.generate(maps.length, (i) {
    return GameResult.fromMap(maps[i]);
  });
}

// DELETE - Remove specific record
Future<void> deleteGameResult(int id) async {
  final Database db = await database;
  await db.delete(
    _tableName,
    where: '$columnId = ?',  // WHERE clause
    whereArgs: [id],         // Parameter binding
  );
}

// DELETE - Clear all records
Future<void> deleteAllGameResults() async {
  final Database db = await database;
  await db.delete(_tableName);  // No WHERE = delete all
}
```

---

### 7. Color-Coded Feedback System

```dart
Color _getFeedbackColor() {
  switch (_feedbackColor) {
    case 'success':
      return Colors.green;      // Correct
    case 'error':
      return Colors.red;        // Too high
    case 'warning':
      return Colors.orange;     // Too low
    default:
      return Colors.blue;       // Neutral
  }
}

// Usage in UI
Container(
  decoration: BoxDecoration(
    color: _getFeedbackColor().withOpacity(0.2),
    border: Border.all(color: _getFeedbackColor(), width: 2),
  ),
  child: Text(
    _feedback,
    style: TextStyle(color: _getFeedbackColor()),
  ),
)
```

---

### 8. FutureBuilder for Async Database

```dart
FutureBuilder<List<GameResult>>(
  future: _gameResults,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final List<GameResult> results = snapshot.data ?? [];

    if (results.isEmpty) {
      return Center(child: Text('No game history yet'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final GameResult result = results[index];
        return ListTile(
          title: Text('Guess: ${result.guess}'),
          subtitle: Text('Status: ${result.status}'),
        );
      },
    );
  },
)
```

**Flow:**
1. `waiting` - Show loading spinner
2. `error` - Display error message
3. `done` - Show data or empty state

---

### 9. Bottom Navigation Implementation

```dart
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    GameScreen(),
    HistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Update selected tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],  // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Play Game'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
```

---

### 10. Confirmation Dialog

```dart
void _deleteResult(int id) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete Record'),
      content: const Text('Are you sure you want to delete this record?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),  // Cancel
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _dbHelper.deleteGameResult(id);  // Execute delete
            _refreshHistory();                 // Refresh UI
            Navigator.pop(context);            // Close dialog
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
```

---

### 11. Timestamp Formatting with intl

```dart
String getFormattedTimestamp() {
  return DateFormat('yyyy-MM-dd hh:mm a').format(timestamp);
}

// Example output: 2024-12-03 02:30 PM
```

---

### 12. Status Indicator Icons & Colors

```dart
Color _getStatusColor(String status) {
  switch (status) {
    case 'Correct':
      return Colors.green;
    case 'Too High':
      return Colors.red;
    case 'Too Low':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

IconData _getStatusIcon(String status) {
  switch (status) {
    case 'Correct':
      return Icons.check_circle;
    case 'Too High':
      return Icons.arrow_downward;
    case 'Too Low':
      return Icons.arrow_upward;
    default:
      return Icons.info;
  }
}
```

---

## Common Patterns Used

### State Management
```dart
setState(() {
  _feedback = 'Your feedback here';
  _feedbackColor = 'success';
  _isGameWon = true;
});
```

### TextField with Validation
```dart
TextField(
  controller: _guessController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    hintText: 'Enter your guess',
    border: OutlineInputBorder(),
    prefixIcon: const Icon(Icons.pin),
  ),
  onSubmitted: (_) => _makeGuess(),  // Submit on Enter
)
```

### Material Button Styling
```dart
ElevatedButton.icon(
  onPressed: _makeGuess,
  icon: const Icon(Icons.check),
  label: const Text('Make Guess'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blueAccent,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
)
```

### SnackBar Notification
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Game already won!')),
);
```

---

## Data Flow Examples

### When User Makes a Guess:

```
User enters "50" → _guessController.text = "50"
↓
User taps "Make Guess"
↓
_makeGuess() called
↓
Input validation: isNumeric? inRange? notEmpty?
↓
int guess = int.parse("50") = 50
↓
Compare: 50 vs _correctNumber (let's say 75)
↓
guess < correctNumber → "Too Low"
↓
_guessCount++ (1)
↓
Create GameResult object
↓
_dbHelper.insertGameResult(gameResult)
↓
INSERT into game_results table
↓
setState() updates UI
↓
_feedback = "Too low! Try again. (Attempt: 1)"
↓
_feedbackColor = "warning" (orange)
↓
Display updated to user
```

### When User Views History:

```
User navigates to History tab
↓
HistoryScreen state initializes
↓
FutureBuilder requests _gameResults
↓
_dbHelper.getAllGameResults() called
↓
SELECT * FROM game_results ORDER BY timestamp DESC
↓
Database returns List<Map>
↓
Convert Map to GameResult objects
↓
FutureBuilder receives data
↓
ListView builds cards for each result
↓
User sees all past guesses with colors & icons
```

---

## Debugging Tips

### Check Database:
```dart
// Print all records
final results = await _dbHelper.getAllGameResults();
print('Total records: ${results.length}');
for (var result in results) {
  print('Guess: ${result.guess}, Status: ${result.status}');
}
```

### Verify Timestamps:
```dart
// Check if timestamp is saving correctly
print('Timestamp: ${gameResult.getFormattedTimestamp()}');
```

### Test Input Validation:
```dart
// Try various inputs to test validation
// Valid: "50", "1", "100"
// Invalid: "0", "101", "abc", ""
```

---

This completes the Number Guessing Game implementation with full documentation and code examples! 🎮
