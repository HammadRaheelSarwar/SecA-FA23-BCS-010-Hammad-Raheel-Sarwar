# 🎮 Number Guessing Game - Visual Guide

## App Screenshots & Layouts

### Screen 1: Game Screen (Initial State)

```
┌─────────────────────────────────┐
│ Number Guessing Game    [≡]     │
├─────────────────────────────────┤
│                                 │
│                                 │
│         Guess the Number        │
│                                 │
│  ┌─────────────────────────┐   │
│  │ I'm thinking of a       │   │
│  │ number between 1 and    │   │
│  │ 100. Can you guess it?  │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Guess a number between  │   │
│  │ 1 and 100              │   │
│  └─────────────────────────┘   │
│                                 │
│         Attempts: 0             │
│                                 │
│  ┌─────────────────────────┐   │
│  │📌 Enter your guess      │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │   ✓ Make Guess         │   │
│  └─────────────────────────┘   │
│                                 │
│                                 │
├─────────────────────────────────┤
│ [🎮 Play Game] [📚 History]     │
└─────────────────────────────────┘
```

### Screen 2: Game Screen (After Guess - Too Low)

```
┌─────────────────────────────────┐
│ Number Guessing Game    [≡]     │
├─────────────────────────────────┤
│                                 │
│      Guess the Number           │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Too low! Try again.     │   │
│  │ (Attempt: 1)            │   │
│  └─────────────────────────┘   │
│  (Orange with border)            │
│                                 │
│       Attempts: 1                │
│                                 │
│  ┌─────────────────────────┐   │
│  │📌 Enter your guess      │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │   ✓ Make Guess         │   │
│  └─────────────────────────┘   │
│                                 │
│                                 │
├─────────────────────────────────┤
│ [🎮 Play Game] [📚 History]     │
└─────────────────────────────────┘
```

### Screen 3: Game Screen (After Guess - Too High)

```
┌─────────────────────────────────┐
│ Number Guessing Game    [≡]     │
├─────────────────────────────────┤
│                                 │
│      Guess the Number           │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Too high! Try again.    │   │
│  │ (Attempt: 2)            │   │
│  └─────────────────────────┘   │
│  (Red with border)               │
│                                 │
│       Attempts: 2                │
│                                 │
│  ┌─────────────────────────┐   │
│  │📌 Enter your guess      │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │   ✓ Make Guess         │   │
│  └─────────────────────────┘   │
│                                 │
│                                 │
├─────────────────────────────────┤
│ [🎮 Play Game] [📚 History]     │
└─────────────────────────────────┘
```

### Screen 4: Game Screen (Winner)

```
┌─────────────────────────────────┐
│ Number Guessing Game    [≡]     │
├─────────────────────────────────┤
│                                 │
│      Guess the Number           │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Correct! You guessed    │   │
│  │ it in 5 attempt(s)! 🎉 │   │
│  └─────────────────────────┘   │
│  (Green with border)             │
│                                 │
│       Attempts: 5                │
│                                 │
│  ┌─────────────────────────┐   │
│  │  🔄 Start New Game      │   │
│  └─────────────────────────┘   │
│  (Green button)                  │
│                                 │
│                                 │
│                                 │
├─────────────────────────────────┤
│ [🎮 Play Game] [📚 History]     │
└─────────────────────────────────┘
```

### Screen 5: History Screen (With Records)

```
┌──────────────────────────────────┐
│ Game History     [↻] [🗑️]       │
├──────────────────────────────────┤
│                                  │
│  ┌────────────────────────────┐ │
│  │ ✓  Guess: 50               │ │
│  │    Correct Number: 50      │ │
│  │    Status: Correct         │ │
│  │    2024-12-03 02:45 PM     │ │
│  │                       [🗑️] │ │
│  └────────────────────────────┘ │
│  (Green border - Correct)        │
│                                  │
│  ┌────────────────────────────┐ │
│  │ ⬆️  Guess: 75               │ │
│  │    Correct Number: 50      │ │
│  │    Status: Too High        │ │
│  │    2024-12-03 02:40 PM     │ │
│  │                       [🗑️] │ │
│  └────────────────────────────┘ │
│  (Red border - Too High)         │
│                                  │
│  ┌────────────────────────────┐ │
│  │ ⬇️  Guess: 30               │ │
│  │    Correct Number: 50      │ │
│  │    Status: Too Low         │ │
│  │    2024-12-03 02:35 PM     │ │
│  │                       [🗑️] │ │
│  └────────────────────────────┘ │
│  (Orange border - Too Low)       │
│                                  │
├──────────────────────────────────┤
│ [🎮 Play Game] [📚 History]      │
└──────────────────────────────────┘
```

### Screen 6: History Screen (Empty State)

```
┌──────────────────────────────────┐
│ Game History     [↻] [🗑️]       │
├──────────────────────────────────┤
│                                  │
│                                  │
│                                  │
│              📚                  │
│                                  │
│      No game history yet         │
│                                  │
│  Start a new game to see         │
│      results here               │
│                                  │
│                                  │
│                                  │
│                                  │
│                                  │
├──────────────────────────────────┤
│ [🎮 Play Game] [📚 History]      │
└──────────────────────────────────┘
```

## User Flow Diagram

```
START APP
  ↓
MAIN SCREEN
  ├─→ [TAB: Play Game]
  │        ↓
  │   GAME SCREEN
  │   ├─→ View Instructions
  │   ├─→ Random Number Generated
  │   ├─→ Enter Guess
  │   ├─→ Click "Make Guess"
  │   ├─→ Validation
  │   ├─→ Show Feedback (Color)
  │   ├─→ Save to Database
  │   └─→ Loop or Win
  │
  └─→ [TAB: History]
           ↓
      HISTORY SCREEN
      ├─→ Load Records
      ├─→ Display List
      ├─→ View Details
      ├─→ Delete Record
      └─→ Return to Game
```

## Color Legend

```
🟢 GREEN - CORRECT ANSWER
   Background: Light green with border
   Text: Green
   Icon: ✓ Check circle
   Message: "Correct! You guessed it..."

🔴 RED - TOO HIGH
   Background: Light red with border
   Text: Red
   Icon: ⬇️ Arrow down
   Message: "Too high! Try again"

🟠 ORANGE - TOO LOW
   Background: Light orange with border
   Text: Orange
   Icon: ⬆️ Arrow up
   Message: "Too low! Try again"

🔵 BLUE - NEUTRAL/INITIAL
   Background: Light blue with border
   Text: Blue
   Icon: ❓ Info
   Message: "Guess a number..."
```

## Button States & Actions

### GameScreen Buttons

```
Initial State:
┌──────────────────┐
│ ✓ Make Guess     │ (Blue button)
└──────────────────┘
     ↓ Hover
┌──────────────────┐
│ ✓ Make Guess     │ (Darker blue)
└──────────────────┘
     ↓ Press
     (Request sent)

After Winning:
┌──────────────────┐
│ 🔄 Start New Game│ (Green button)
└──────────────────┘
```

### HistoryScreen Buttons

```
AppBar Actions:
┌─────────────────────────────────┐
│ 🔄 (Refresh)  |  🗑️ (Clear All) │
└─────────────────────────────────┘

Card Actions:
┌────────────────────────────┐
│ Record Details    [🗑️ Delete]│
└────────────────────────────┘
```

## Notification Examples

### SnackBar Messages

```
Success:
┌─────────────────────────────────┐
│ ✓ Record deleted successfully   │
└─────────────────────────────────┘

Error:
┌─────────────────────────────────┐
│ ✗ Please enter a number         │
└─────────────────────────────────┘

Info:
┌─────────────────────────────────┐
│ ℹ Game already won!             │
└─────────────────────────────────┘
```

### Confirmation Dialogs

```
Delete Record:
┌─────────────────────────────┐
│ Delete Record               │
├─────────────────────────────┤
│ Are you sure you want to    │
│ delete this record?         │
├─────────────────────────────┤
│ [Cancel]     [Delete]       │
└─────────────────────────────┘

Clear All:
┌─────────────────────────────┐
│ Clear All History           │
├─────────────────────────────┤
│ Are you sure? This cannot   │
│ be undone.                  │
├─────────────────────────────┤
│ [Cancel]  [Clear All]       │
└─────────────────────────────┘
```

## Responsive Design

### Portrait Mode (Typical)
```
┌─────────────────────┐
│        App          │
│    (Full Width)     │
│   (Phone/Tablet)    │
└─────────────────────┘
```

### Landscape Mode
```
┌──────────────────────────────────┐
│           App (Wide)              │
│    (Landscape orientation)        │
└──────────────────────────────────┘
```

### Tablet Mode
```
┌──────────────────────────────────┐
│                                  │
│         App (Large)              │
│    (Optimized for large screen)  │
│                                  │
└──────────────────────────────────┘
```

## Input Validation Visual Feedback

### Valid Input (50)
```
┌──────────────────┐
│ 📌 50            │ ✓ Green checkmark
└──────────────────┘
```

### Invalid Input (150)
```
┌──────────────────┐
│ 📌 150           │ ✗ Red X mark
└──────────────────┘
Error: "Please enter number 1-100"
```

### Empty Input
```
┌──────────────────┐
│ 📌 [placeholder] │ ✗ Red outline
└──────────────────┘
Error: "Please enter a number"
```

### Non-Numeric Input (abc)
```
┌──────────────────┐
│ 📌 abc           │ ✗ Red X mark
└──────────────────┘
Error: "Please enter a valid number"
```

## Game Session Example

### Sequence of Guesses:

```
Correct Number: 42 (hidden)

Guess 1: 50 → "Too High" 🔴
Guess 2: 30 → "Too Low" 🟠
Guess 3: 40 → "Too Low" 🟠
Guess 4: 45 → "Too High" 🔴
Guess 5: 42 → "Correct! ✓" 🟢

Game Won in 5 attempts!

Saved to Database:
┌─────────────────────────────────┐
│ ID | Guess | Correct | Status   │
├─────────────────────────────────┤
│ 1  │ 50    │ 42      │ Too High │
│ 2  │ 30    │ 42      │ Too Low  │
│ 3  │ 40    │ 42      │ Too Low  │
│ 4  │ 45    │ 42      │ Too High │
│ 5  │ 42    │ 42      │ Correct │
└─────────────────────────────────┘
```

## Feature Hierarchy

```
Level 1 - Core Functionality
  ├─ Random Number Generation ✓
  ├─ User Input ✓
  └─ Guess Comparison ✓

Level 2 - User Experience
  ├─ Feedback System ✓
  ├─ Color Coding ✓
  └─ Attempt Tracking ✓

Level 3 - Persistence
  ├─ Database Storage ✓
  ├─ History View ✓
  └─ Timestamp Recording ✓

Level 4 - Enhancement
  ├─ Multi-Screen Navigation ✓
  ├─ Record Deletion ✓
  └─ Clear All ✓

Level 5 - Polish
  ├─ Confirmation Dialogs ✓
  ├─ Empty States ✓
  ├─ Error Messages ✓
  └─ Responsive Design ✓
```

## Performance Visualization

```
App Startup
  0ms   ──────────────────── 2000ms
  ├──────────────────────────┤
  Initializing database

First Guess
  0ms   ───────────────────── 100ms
  ├─────┤
  Processing input & displaying result

History Load (100 records)
  0ms   ───────────────────── 500ms
  ├─────────────────────────┤
  Querying & rendering list

Delete Operation
  0ms   ──────────────────── 200ms
  ├──────────────┤
  Database delete & UI refresh
```

---

**This visual guide helps understand the app's UI/UX at a glance! 🎨**
