import 'package:flutter/material.dart';
import 'dart:math';

/// Main entry point for the Premium Dice Roller application
void main() {
  runApp(DiceApp());
}

/// Root widget of the application
class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Premium Dice Roller",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: DiceScreen(),
    );
  }
}

// Dice styles enum
enum DiceStyle { classic, modern, neon, wood, metal }

/// Main screen containing enhanced dice rolling functionality
class DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> 
    with SingleTickerProviderStateMixin {
  int _currentDiceValue = 1;
  int _previousDiceValue = 1;
  final TextEditingController _guessController = TextEditingController();
  String _message = "Tap dice to roll";
  int _totalRolls = 0;
  int _correctGuesses = 0;
  int _streak = 0;
  int _bestStreak = 0;
  bool _isRolling = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showCelebration = false;
  
  // Game history
  List<RollHistory> _rollHistory = [];
  
  // Settings
  bool _enableHaptics = true;
  bool _enableSound = true;
  bool _darkMode = false;
  int _rollSpeed = 3;
  DiceStyle _diceStyle = DiceStyle.classic;
  
  final List<String> _fontOptions = ['Inter', 'Roboto', 'OpenSans', 'Montserrat', 'Poppins'];
  String _selectedFont = 'Inter';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(_animationController);
  }

  /// Enhanced dice roll with physics simulation
  Future<void> _rollDice() async {
    if (_isRolling) return;
    
    setState(() {
      _isRolling = true;
      _message = "Rolling...";
      _showCelebration = false;
    });

    _animationController.forward();

    // Simulate realistic rolling with variable speed
    int rolls = 8 + _rollSpeed * 2;
    for (int i = 0; i < rolls; i++) {
      await Future.delayed(Duration(milliseconds: 100 ~/ _rollSpeed));
      if (!mounted) return;
      setState(() {
        _currentDiceValue = Random().nextInt(6) + 1;
      });
    }

    // Final roll result
    final int newValue = Random().nextInt(6) + 1;
    final RollHistory history = RollHistory(
      value: newValue,
      guess: int.tryParse(_guessController.text),
      timestamp: DateTime.now(),
    );

    setState(() {
      _previousDiceValue = _currentDiceValue;
      _currentDiceValue = newValue;
      _totalRolls++;
      _rollHistory.insert(0, history);
      _isRolling = false;
      _evaluateGuess(newValue);
    });

    _animationController.reverse();
  }

  /// Enhanced guess evaluation with streak tracking
  void _evaluateGuess(int result) {
    if (_guessController.text.isEmpty) {
      _message = "Rolled: $result";
      _streak = 0;
      return;
    }

    final int? guess = int.tryParse(_guessController.text);
    if (guess == null || guess < 1 || guess > 6) {
      _message = "Invalid guess! Rolled: $result";
      _streak = 0;
      return;
    }

    if (guess == result) {
      _correctGuesses++;
      _streak++;
      _bestStreak = max(_bestStreak, _streak);
      _message = "🎯 Perfect! It's $result (Streak: $_streak)";
      _showCelebration = true;
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showCelebration = false;
          });
        }
      });
    } else {
      _message = "❌ Missed! It's $result";
      _streak = 0;
    }
  }

  /// Reset game state
  void _resetGame() {
    setState(() {
      _currentDiceValue = 1;
      _previousDiceValue = 1;
      _guessController.clear();
      _message = "Tap dice to roll";
      _totalRolls = 0;
      _correctGuesses = 0;
      _streak = 0;
      _rollHistory.clear();
      _showCelebration = false;
    });
  }

  /// Show settings dialog
  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text("Settings", style: TextStyle(fontFamily: _selectedFont)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSettingSwitch(
                  "Haptic Feedback",
                  _enableHaptics,
                  (value) => setDialogState(() => _enableHaptics = value),
                ),
                _buildSettingSwitch(
                  "Sound Effects",
                  _enableSound,
                  (value) => setDialogState(() => _enableSound = value),
                ),
                _buildSettingSwitch(
                  "Dark Mode",
                  _darkMode,
                  (value) => setDialogState(() => _darkMode = value),
                ),
                SizedBox(height: 16),
                Text("Roll Speed", style: TextStyle(fontFamily: _selectedFont)),
                Slider(
                  value: _rollSpeed.toDouble(),
                  min: 1,
                  max: 5,
                  divisions: 4,
                  onChanged: (value) => setDialogState(() => _rollSpeed = value.toInt()),
                ),
                SizedBox(height: 16),
                Text("Dice Style", style: TextStyle(fontFamily: _selectedFont)),
                DropdownButton<DiceStyle>(
                  value: _diceStyle,
                  onChanged: (DiceStyle? newValue) {
                    setDialogState(() {
                      _diceStyle = newValue!;
                    });
                  },
                  items: DiceStyle.values.map((style) {
                    return DropdownMenuItem<DiceStyle>(
                      value: style,
                      child: Text(
                        _getDiceStyleName(style),
                        style: TextStyle(fontFamily: _selectedFont),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(fontFamily: _selectedFont)),
            ),
          ],
        ),
      ),
    ).then((_) => setState(() {}));
  }

  /// Helper method to get display name for dice style
  String _getDiceStyleName(DiceStyle style) {
    switch (style) {
      case DiceStyle.classic:
        return "Classic";
      case DiceStyle.modern:
        return "Modern";
      case DiceStyle.neon:
        return "Neon";
      case DiceStyle.wood:
        return "Wood";
      case DiceStyle.metal:
        return "Metal";
    }
  }

  /// Helper method to get image path for dice style and value
  String _getDiceImagePath(DiceStyle style, int value) {
    String styleFolder;
    switch (style) {
      case DiceStyle.classic:
        styleFolder = "classic";
        break;
      case DiceStyle.modern:
        styleFolder = "modern";
        break;
      case DiceStyle.neon:
        styleFolder = "neon";
        break;
      case DiceStyle.wood:
        styleFolder = "wood";
        break;
      case DiceStyle.metal:
        styleFolder = "metal";
        break;
    }
    return "assets/images/dice/$styleFolder/dice_$value.png";
  }

  /// Build dice image widget with fallback
  Widget _buildDiceImage() {
    String imagePath = _getDiceImagePath(_diceStyle, _currentDiceValue);
    
    return Image.asset(
      imagePath,
      height: 140,
      width: 140,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to generated dice if image fails to load
        return _buildGeneratedDice();
      },
    );
  }

  /// Fallback method to generate dice visually if images are not available
  Widget _buildGeneratedDice() {
    return Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        color: _getDiceColor(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: _getDiceBorderColor(),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          _currentDiceValue.toString(),
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: _getDotColor(),
          ),
        ),
      ),
    );
  }

  Color _getDiceColor() {
    switch (_diceStyle) {
      case DiceStyle.classic:
        return Colors.white;
      case DiceStyle.modern:
        return Colors.blueGrey[50]!;
      case DiceStyle.neon:
        return Colors.black;
      case DiceStyle.wood:
        return Color(0xFF8B4513);
      case DiceStyle.metal:
        return Color(0xFFB0B0B0);
      default:
        return Colors.white;
    }
  }

  Color _getDiceBorderColor() {
    switch (_diceStyle) {
      case DiceStyle.neon:
        return Colors.cyan;
      case DiceStyle.metal:
        return Colors.grey[700]!;
      default:
        return Colors.black12;
    }
  }

  Color _getDotColor() {
    switch (_diceStyle) {
      case DiceStyle.neon:
        return Colors.cyan;
      case DiceStyle.wood:
        return Colors.amber[100]!;
      default:
        return Colors.black;
    }
  }

  Widget _buildSettingSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(fontFamily: _selectedFont)),
      value: value,
      onChanged: onChanged,
    );
  }

  /// Show roll history
  void _showHistory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Roll History", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: _selectedFont,
            )),
            SizedBox(height: 10),
            Expanded(
              child: _rollHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            "No rolls yet",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontFamily: _selectedFont,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _rollHistory.length,
                      itemBuilder: (context, index) {
                        final history = _rollHistory[index];
                        return _buildHistoryItem(history);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(RollHistory history) {
    final bool isCorrect = history.guess == history.value;
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: isCorrect ? Colors.green.withOpacity(0.1) : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCorrect ? Colors.green : Colors.deepPurple,
          child: Text(
            history.value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          "Rolled: ${history.value}",
          style: TextStyle(
            fontFamily: _selectedFont,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          history.guess != null 
              ? "Guessed: ${history.guess} ${isCorrect ? '✓' : '✗'}"
              : "No guess",
          style: TextStyle(fontFamily: _selectedFont),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(history.timestamp),
              style: TextStyle(
                fontFamily: _selectedFont,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            if (isCorrect)
              Icon(Icons.emoji_events, color: Colors.amber, size: 16),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes}m ago";
    if (difference.inHours < 24) return "${difference.inHours}h ago";
    return "${difference.inDays}d ago";
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _darkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            "🎲 Premium Dice Roller",
            style: TextStyle(
              fontFamily: _selectedFont,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 2,
          actions: [
            IconButton(
              icon: Icon(Icons.history),
              onPressed: _showHistory,
              tooltip: "Roll History",
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: _showSettings,
              tooltip: "Settings",
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetGame,
              tooltip: "Reset Game",
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Statistics Section
                    _buildEnhancedStatsCard(context),
                    SizedBox(height: 24),

                    // Dice Display Section
                    _buildEnhancedDiceSection(context),
                    SizedBox(height: 24),

                    // Input Section
                    _buildEnhancedInputSection(context),
                    SizedBox(height: 20),

                    // Result Section
                    _buildEnhancedResultSection(context),
                  ],
                ),
              ),
            ),
            
            // Celebration Effect
            if (_showCelebration)
              _buildCelebrationEffect(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _rollDice,
          icon: _isRolling 
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(Icons.casino),
          label: Text(_isRolling ? "Rolling..." : "Quick Roll"),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
    );
  }

  /// Celebration effect widget
  Widget _buildCelebrationEffect() {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Colors.yellow.withOpacity(0.3),
              Colors.orange.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.celebration,
                size: 80,
                color: Colors.amber,
              ),
              SizedBox(height: 16),
              Text(
                "STREAK: $_streak!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                  fontFamily: _selectedFont,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Enhanced statistics card with more metrics
  Widget _buildEnhancedStatsCard(BuildContext context) {
    // Calculate accuracy percentage
    final double accuracyPercent = _totalRolls == 0 
        ? 0 
        : (_correctGuesses / _totalRolls * 100);
    final String accuracyText = "${accuracyPercent.toStringAsFixed(1)}%";
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Rolls", _totalRolls.toString(), Icons.casino),
                _buildStatItem("Accuracy", accuracyText, Icons.track_changes),
                _buildStatItem("Streak", _streak.toString(), Icons.local_fire_department),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("Best Streak", _bestStreak.toString(), Icons.emoji_events),
                _buildStatItem("Correct", _correctGuesses.toString(), Icons.check_circle),
                _buildStatItem("History", _rollHistory.length.toString(), Icons.history),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.deepPurple),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
            fontFamily: _selectedFont,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
            fontFamily: _selectedFont,
          ),
        ),
      ],
    );
  }

  /// Enhanced dice section with animations
  Widget _buildEnhancedDiceSection(BuildContext context) {
    return Column(
      children: [
        // Font and Style Selector
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFont,
                    isExpanded: true,
                    items: _fontOptions.map((font) {
                      return DropdownMenuItem<String>(
                        value: font,
                        child: Text(
                          "Font: $font",
                          style: TextStyle(fontFamily: font, fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() => _selectedFont = newValue!);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<DiceStyle>(
                  value: _diceStyle,
                  onChanged: (DiceStyle? newValue) {
                    setState(() => _diceStyle = newValue!);
                  },
                  items: DiceStyle.values.map((style) {
                    return DropdownMenuItem<DiceStyle>(
                      value: style,
                      child: Text(
                        _getDiceStyleName(style),
                        style: TextStyle(fontFamily: _selectedFont),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        // Animated Dice
        GestureDetector(
          onTap: _rollDice,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(_isRolling ? 16 : 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: _isRolling 
                    ? LinearGradient(
                        colors: [
                          Colors.deepPurple.withOpacity(0.2),
                          Colors.purple.withOpacity(0.1)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: Offset(0, 6),
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color: Colors.deepPurple.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: _buildDiceImage(), // Updated to use the new image method
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Tap dice or use Quick Roll button",
          style: TextStyle(
            color: Colors.grey[600],
            fontFamily: _selectedFont,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Enhanced input section
  Widget _buildEnhancedInputSection(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _guessController,
          decoration: InputDecoration(
            labelText: "Enter your guess (1-6)",
            hintText: "Try to predict the next roll!",
            prefixIcon: Icon(Icons.psychology_outlined),
            suffixIcon: IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Guess Help"),
                  content: Text("Enter a number between 1 and 6. Get it right to build your streak and unlock achievements!"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("GOT IT"),
                    ),
                  ],
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          keyboardType: TextInputType.number,
          style: TextStyle(fontFamily: _selectedFont, fontSize: 16),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _rollDice,
                icon: _isRolling 
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(Icons.casino),
                label: Text(
                  _isRolling ? "Rolling..." : "Roll Dice", 
                  style: TextStyle(
                    fontFamily: _selectedFont,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Enhanced result section with animations
  Widget _buildEnhancedResultSection(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getMessageGradient(),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getMessageColor().withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: Icon(
              _getMessageIcon(),
              key: ValueKey(_message),
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getMessageTitle(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: _selectedFont,
                  ),
                ),
                if (_message.contains("Streak"))
                  Text(
                    "Current streak: $_streak • Best: $_bestStreak",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      fontFamily: _selectedFont,
                    ),
                  ),
              ],
            ),
          ),
          if (_streak > 2)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_fire_department, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    "$_streak",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Color> _getMessageGradient() {
    if (_message.contains("🎯")) return [Colors.green, Colors.lightGreen];
    if (_message.contains("❌")) return [Colors.red, Colors.orange];
    if (_message.contains("Invalid")) return [Colors.orange, Colors.amber];
    return [Colors.deepPurple, Colors.purple];
  }

  Color _getMessageColor() {
    if (_message.contains("🎯")) return Colors.green;
    if (_message.contains("❌")) return Colors.red;
    if (_message.contains("Invalid")) return Colors.orange;
    return Colors.deepPurple;
  }

  IconData _getMessageIcon() {
    if (_message.contains("🎯")) return Icons.celebration;
    if (_message.contains("❌")) return Icons.error_outline;
    if (_message.contains("Invalid")) return Icons.warning;
    return Icons.info_outline;
  }

  String _getMessageTitle() {
    if (_message.contains("🎯")) return "Perfect Guess! 🎯";
    if (_message.contains("❌")) return "Wrong Guess";
    if (_message.contains("Invalid")) return "Invalid Input";
    return "Dice Rolled";
  }

  @override
  void dispose() {
    _animationController.dispose();
    _guessController.dispose();
    super.dispose();
  }
}

/// Model for roll history
class RollHistory {
  final int value;
  final int? guess;
  final DateTime timestamp;

  RollHistory({
    required this.value,
    required this.guess,
    required this.timestamp,
  });
}