# 📊 Architecture & Flow Diagrams

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Flutter App                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              MainScreen (Stateful)                   │   │
│  │         with BottomNavigationBar                     │   │
│  └──────────────────────────────────────────────────────┘   │
│           ↓                                    ↓             │
│  ┌─────────────────────────┐    ┌──────────────────────┐   │
│  │    GameScreen           │    │  HistoryScreen       │   │
│  ├─────────────────────────┤    ├──────────────────────┤   │
│  │ - Random Number Gen     │    │ - Load from Database │   │
│  │ - Input Validation      │    │ - Display Records    │   │
│  │ - Game Logic            │    │ - Delete Records     │   │
│  │ - Feedback System       │    │ - Clear All          │   │
│  │ - Save to Database      │    │ - Refresh            │   │
│  └─────────────────────────┘    └──────────────────────┘   │
│           ↓                              ↓                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │         DatabaseHelper (Singleton)                  │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │ - insertGameResult()                                │   │
│  │ - getAllGameResults()                               │   │
│  │ - deleteGameResult()                                │   │
│  │ - deleteAllGameResults()                            │   │
│  │ - _initializeDatabase()                             │   │
│  └─────────────────────────────────────────────────────┘   │
│           ↓                                                   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              SQLite Database                        │   │
│  │         (game_history.db)                           │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │  Table: game_results                                │   │
│  │  ├─ id (PRIMARY KEY)                                │   │
│  │  ├─ guess (INTEGER)                                 │   │
│  │  ├─ correct_number (INTEGER)                        │   │
│  │  ├─ status (TEXT)                                   │   │
│  │  └─ timestamp (TEXT)                                │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Data Model Relationships

```
┌──────────────────────┐
│    GameResult        │
├──────────────────────┤
│ - id: int?           │
│ - guess: int         │
│ - correctNumber: int │
│ - status: String     │
│ - timestamp: DateTime│
├──────────────────────┤
│ + toMap()            │
│ + fromMap()          │
│ + getFormattedTime() │
└──────────────────────┘
         ↓
   Converts to/from
         ↓
┌──────────────────────────────────────┐
│  Map<String, Object?>                │
│  Used by SQLite                      │
├──────────────────────────────────────┤
│ {                                    │
│   'id': 1                            │
│   'guess': 50                        │
│   'correct_number': 75               │
│   'status': 'Too Low'                │
│   'timestamp': '2024-12-03...'       │
│ }                                    │
└──────────────────────────────────────┘
```

## Game Flow

```
┌─────────────┐
│  App Start  │
└──────┬──────┘
       ↓
┌───────────────────┐
│  MainScreen Init  │
│ (Tab: 0 = Game)   │
└──────┬────────────┘
       ↓
┌──────────────────────────┐
│   GameScreen Displays    │
│  - Random number 1-100   │
│  - Input field           │
│  - "Make Guess" button   │
└──────┬───────────────────┘
       ↓
   User enters guess
       ↓
┌──────────────────────┐
│ Input Validation     │
├──────────────────────┤
│ Is numeric?    →YES→ Continue
│     │NO → ERROR message
│ Is 1-100?      →YES→ Continue
│     │NO → ERROR message
│ Is not empty?  →YES→ Continue
│     │NO → ERROR message
└──────┬───────────────────┘
       ↓
┌──────────────────────┐
│  Increment Counter   │
│   guess_count++      │
└──────┬───────────────┘
       ↓
┌───────────────────────────────┐
│  Compare Guess with Target    │
├───────────────────────────────┤
│ guess == target?    → "Correct!" (GREEN)
│ guess > target?     → "Too High" (RED)
│ guess < target?     → "Too Low" (ORANGE)
└──────┬────────────────────────┘
       ↓
┌──────────────────────────┐
│  Save to Database        │
│  DatabaseHelper insert() │
└──────┬───────────────────┘
       ↓
┌──────────────────────────┐
│  Update UI with Feedback │
│  - Color change          │
│  - Message display       │
│  - Counter update        │
└──────┬───────────────────┘
       ↓
   Guess == Target?
       ↓
   YES: Show "Start New Game" button
   NO:  Continue guessing (loop back)
       ↓
   User Views History
       ↓
┌──────────────────────────┐
│  HistoryScreen Loads     │
│  getAllGameResults()     │
└──────┬───────────────────┘
       ↓
   Display all previous attempts
```

## State Transitions

```
GameScreen States:

    ┌─────────────────────┐
    │  Initial State      │
    │ - correctNumber: ?? │
    │ - feedback: "Guess" │
    │ - guessCount: 0     │
    │ - isGameWon: false  │
    └──────────┬──────────┘
               ↓
    User makes valid guess
               ↓
    ┌─────────────────────┐
    │  Guessing State     │
    │ - guessCount: 1+    │
    │ - feedback: result  │
    │ - isGameWon: false  │
    └──────────┬──────────┘
               ↓
    Guess == Target?
               ↓
    YES        NO
    ↓          ↓
    ┌────────────────────────────┐
    │  Won State                 │
    │ - feedback: "Correct! ..."│
    │ - isGameWon: true         │
    │ - Show "New Game" button  │
    │ - Disable guess input     │
    └────────────┬───────────────┘
                 ↓
    User taps "Start New Game"
                 ↓
    Reset to Initial State (loop)
```

## Database Operations Flow

```
┌─────────────────────────────────────┐
│      App First Launch               │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  DatabaseHelper initialization      │
│  (Singleton instantiation)          │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  Check: Database exists?            │
└────────────┬────────────────────────┘
             ↓
    NO       YES
    ↓        ↓
    ┌─────────────────────┐
    │ CREATE database     │
    │ game_history.db     │
    └────────┬────────────┘
             ↓
┌─────────────────────────────────────┐
│  CREATE TABLE game_results          │
│  (if not exists)                    │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│  Database ready for CRUD operations │
└─────────────────────────────────────┘
             ↓
   ┌─────────────────────────────────┐
   │                                 │
   ├──────────────┬──────────┬───────┤
   ↓              ↓          ↓       ↓
CREATE        READ        UPDATE   DELETE
(Insert)    (Select)     (N/A)    (Remove)
  ↓            ↓                      ↓
Insert    getAllResults()       deleteResult()
Record    (SELECT *)           (DELETE BY ID)
          
          Refresh             deleteAllResults()
          History            (DELETE ALL)
```

## UI Navigation Flow

```
┌────────────────────────────────────────────┐
│        App Launch - MainScreen             │
│  ┌─────────────────────────────────────┐   │
│  │                                     │   │
│  │         GameScreen (Active)         │   │
│  │    [Games Icon] [History Icon]      │   │
│  │                                     │   │
│  └─────────────────────────────────────┘   │
│  [Games]      [History]  ← Bottom Nav Bar  │
└────────────────────────────────────────────┘
         │ Tap History Tab
         ↓
┌────────────────────────────────────────────┐
│        App - MainScreen (Updated)          │
│  ┌─────────────────────────────────────┐   │
│  │                                     │   │
│  │      HistoryScreen (Active)         │   │
│  │    Refresh | Clear History          │   │
│  │                                     │   │
│  │  ┌─────────────────────────────────┤   │
│  │  │ Record 1: Guess: 50 | Correct  │   │
│  │  │ Record 2: Guess: 75 | Too High │   │
│  │  │ Record 3: Guess: 30 | Too Low  │   │
│  │  └─────────────────────────────────┤   │
│  │                                     │   │
│  └─────────────────────────────────────┘   │
│  [Games]      [History]  ← Bottom Nav Bar  │
└────────────────────────────────────────────┘
         │ Tap Games Tab
         ↓
   (Returns to GameScreen)
```

## Input Validation Flow Chart

```
           ┌─ User Input ─┐
           │   "50"       │
           └──────┬───────┘
                  ↓
          ┌───────────────┐
          │ Trim whitespace│
          │ input.trim()  │
          └────────┬──────┘
                   ↓
          ┌──────────────────┐
          │ Is input empty?  │
          ├──────────────────┤
    YES → Show ERROR msg
    NO  ↓
          ┌──────────────────┐
          │ Parse to integer │
          │ int.parse()      │
          └────────┬─────────┘
                   ↓
      Try-Catch Block
          /        \
        YES         ERROR
        /             \
       ↓               ↓
  ┌──────────────┐  Show ERROR
  │ int value    │  "Invalid number"
  └────┬─────────┘
       ↓
  ┌─────────────────┐
  │ Is 1 <= ? <= 100│
  └────────┬────────┘
           ↓
    YES    NO
    ↓      └──→ Show ERROR "1-100 only"
    ↓
  ┌────────────────────┐
  │ VALID INPUT ✓      │
  │ Proceed with guess │
  └────────────────────┘
```

## Color Coding System

```
┌──────────────────────────────────────────┐
│         Guess Result Colors              │
├──────────────────────────────────────────┤
│                                          │
│  ✅ Correct Answer                       │
│  ├─ Color: Green (#4CAF50)              │
│  ├─ Icon: check_circle                  │
│  ├─ Message: "Correct! You got it!"     │
│  └─ Border: Green                       │
│                                          │
│  ⬆️ Too High                            │
│  ├─ Color: Red (#F44336)                │
│  ├─ Icon: arrow_downward                │
│  ├─ Message: "Too high! Try again"      │
│  └─ Border: Red                         │
│                                          │
│  ⬇️ Too Low                             │
│  ├─ Color: Orange (#FF9800)             │
│  ├─ Icon: arrow_upward                  │
│  ├─ Message: "Too low! Try again"       │
│  └─ Border: Orange                      │
│                                          │
│  ❓ Neutral/Initial                     │
│  ├─ Color: Blue (#2196F3)               │
│  ├─ Message: "Enter your guess"         │
│  └─ Border: Blue                        │
│                                          │
└──────────────────────────────────────────┘
```

## Database Query Examples

```
┌─────────────────────────────────┐
│  Common SQL Operations          │
├─────────────────────────────────┤
│                                 │
│ CREATE (Insert):                │
│ INSERT INTO game_results        │
│ VALUES (null, 50, 75, ..., time)│
│                                 │
│ READ (Select All):              │
│ SELECT * FROM game_results      │
│ ORDER BY timestamp DESC         │
│ (Newest records first)          │
│                                 │
│ READ (Select One):              │
│ SELECT * FROM game_results      │
│ WHERE id = 1                    │
│                                 │
│ DELETE (Single):                │
│ DELETE FROM game_results        │
│ WHERE id = 1                    │
│                                 │
│ DELETE (All):                   │
│ DELETE FROM game_results        │
│                                 │
│ COUNT:                          │
│ SELECT COUNT(*) FROM game_results
│                                 │
└─────────────────────────────────┘
```

## Memory Management

```
┌──────────────────────────────────────┐
│     GameScreen Lifecycle             │
├──────────────────────────────────────┤
│                                      │
│ initState()                          │
│ ├─ _guessController = TextEditing...│
│ ├─ _initializeGame()                │
│ └─ _correctNumber assigned          │
│                                      │
│ build()                              │
│ └─ UI built with current state      │
│                                      │
│ setState()                           │
│ ├─ Called after guess made          │
│ └─ UI re-rendered with new data     │
│                                      │
│ dispose()                            │
│ ├─ _guessController.dispose()       │
│ └─ Resources cleaned up             │
│                                      │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│     HistoryScreen Lifecycle          │
├──────────────────────────────────────┤
│                                      │
│ initState()                          │
│ └─ _refreshHistory() called          │
│                                      │
│ FutureBuilder watches                │
│ └─ _gameResults future               │
│                                      │
│ setState()                           │
│ ├─ Called on delete/clear            │
│ └─ UI updated with new data         │
│                                      │
└──────────────────────────────────────┘
```

## Error Handling Flow

```
┌─────────────────┐
│   Error Occurs  │
└────────┬────────┘
         ↓
    ┌─────────────────────────────┐
    │ What type of error?         │
    └────────┬────────────────────┘
             ├─────────────────────┐
             ↓                     ↓
        ┌────────────┐      ┌─────────────┐
        │ Try-Catch  │      │ Validation  │
        ├────────────┤      ├─────────────┤
        │ Parse Error│      │ Empty Input │
        │ IO Error   │      │ Out of Range│
        │ DB Error   │      │ Invalid Type│
        └──────┬─────┘      └──────┬──────┘
               ↓                    ↓
        ┌─────────────────┐  ┌──────────────┐
        │ Show SnackBar   │  │ Show Feedback│
        │ "Error occurred"│  │ in UI Box    │
        └─────────────────┘  └──────────────┘
               ↓                    ↓
        Continue app          Continue app
        (Try again)           (Try again)
```

---

**This comprehensive diagram documentation shows the complete architecture, data flow, and interactions within the Number Guessing Game app! 📊**
