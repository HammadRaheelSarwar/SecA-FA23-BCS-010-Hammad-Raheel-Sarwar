import 'package:flutter/material.dart';
import 'dart:math';
import 'package:game/database/db_helper.dart';
import 'package:game/models/game_result.dart';
import 'package:game/theme/gaming_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late int _correctNumber;
  late int _guessCount;
  final TextEditingController _guessController = TextEditingController();
  String _feedback = '';
  String _feedbackColor = '';
  bool _isGameWon = false;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Animation controllers
  late AnimationController _feedbackAnimationController;
  late AnimationController _bounceAnimationController;
  late AnimationController _pulseAnimationController;
  late AnimationController _shimmerController;
  late Animation<double> _feedbackAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeGame();
  }

  void _initializeAnimations() {
    // Feedback animation
    _feedbackAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _feedbackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _feedbackAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Bounce animation for winning
    _bounceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    // Pulse animation for attention
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _initializeGame() {
    _correctNumber = Random().nextInt(100) + 1;
    _guessCount = 0;
    _feedback = 'Ready to play?';
    _feedbackColor = 'neutral';
    _isGameWon = false;
    _guessController.clear();
    _feedbackAnimationController.reset();
    _bounceAnimationController.reset();
  }

  void _makeGuess() {
    if (_isGameWon) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 10),
              Text('Game already won! Start a new game.'),
            ],
          ),
          backgroundColor: GamingTheme.accentOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final String input = _guessController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Please enter a number'),
            ],
          ),
          backgroundColor: GamingTheme.accentPink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    try {
      final int guess = int.parse(input);

      if (guess < 1 || guess > 100) {
        setState(() {
          _feedback = 'Please enter a number between 1 and 100';
          _feedbackColor = 'error';
        });
        _feedbackAnimationController.forward(from: 0);
        return;
      }

      _guessCount++;

      String status;
      if (guess == _correctNumber) {
        status = 'Correct';
        _feedback = '🎉 VICTORY! 🎉\nYou guessed it in $_guessCount attempt(s)!';
        _feedbackColor = 'success';
        _isGameWon = true;
        _bounceAnimationController.forward();
      } else if (guess > _correctNumber) {
        status = 'Too High';
        _feedback = '📈 Too High!\nTry a lower number\n(Attempt: $_guessCount)';
        _feedbackColor = 'error';
      } else {
        status = 'Too Low';
        _feedback = '📉 Too Low!\nTry a higher number\n(Attempt: $_guessCount)';
        _feedbackColor = 'warning';
      }

      // Save to database
      final GameResult gameResult = GameResult(
        guess: guess,
        correctNumber: _correctNumber,
        status: status,
        timestamp: DateTime.now(),
      );
      _dbHelper.insertGameResult(gameResult);

      setState(() {});
      _feedbackAnimationController.forward(from: 0);
      _guessController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Text('Please enter a valid number'),
            ],
          ),
          backgroundColor: GamingTheme.accentPink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Color _getFeedbackColor() {
    switch (_feedbackColor) {
      case 'success':
        return GamingTheme.accentGreen;
      case 'error':
        return GamingTheme.accentPink;
      case 'warning':
        return GamingTheme.accentOrange;
      default:
        return GamingTheme.accentNeon;
    }
  }

  LinearGradient _getFeedbackGradient() {
    switch (_feedbackColor) {
      case 'success':
        return GamingTheme.successGradient;
      case 'error':
        return GamingTheme.errorGradient;
      case 'warning':
        return GamingTheme.warningGradient;
      default:
        return GamingTheme.neonGradient;
    }
  }

  @override
  void dispose() {
    _guessController.dispose();
    _feedbackAnimationController.dispose();
    _bounceAnimationController.dispose();
    _pulseAnimationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'NUMBER GUESSER',
          style: GamingTheme.gamingTitle(fontSize: 22),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: GamingTheme.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Animated Title
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            gradient: GamingTheme.neonGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: GamingTheme.neonGlow(
                              color: GamingTheme.accentNeon,
                              blurRadius: 30,
                            ),
                          ),
                          child: Text(
                            '🎯 GUESS THE NUMBER',
                            style: GamingTheme.gamingTitle(fontSize: 28),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // Instructions Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: GamingTheme.glassmorphism(
                      opacity: 0.2,
                      blur: 20,
                      borderRadius: 24,
                      borderColor: GamingTheme.accentNeon,
                      borderWidth: 2,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'I\'m thinking of a number...',
                          style: GamingTheme.gamingSubtitle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: GamingTheme.neonGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: GamingTheme.neonGlow(
                              color: GamingTheme.accentNeon,
                              blurRadius: 20,
                            ),
                          ),
                          child: Text(
                            'BETWEEN 1 AND 100',
                            style: GamingTheme.gamingTitle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Can you guess it?',
                          style: GamingTheme.gamingBody(
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Feedback Box with Animation
                  ScaleTransition(
                    scale: _feedbackAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: _getFeedbackGradient(),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: GamingTheme.neonGlow(
                          color: _getFeedbackColor(),
                          blurRadius: 25,
                        ),
                      ),
                      child: Text(
                        _feedback,
                        textAlign: TextAlign.center,
                        style: GamingTheme.gamingTitle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Attempt Counter
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: GamingTheme.glassmorphism(
                      opacity: 0.2,
                      blur: 15,
                      borderRadius: 20,
                      borderColor: GamingTheme.accentPurple,
                      borderWidth: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.track_changes,
                          color: GamingTheme.accentPurple,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'ATTEMPTS: ',
                          style: GamingTheme.gamingSubtitle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        Text(
                          '$_guessCount',
                          style: GamingTheme.gamingTitle(
                            fontSize: 32,
                            color: GamingTheme.accentPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Input Field
                  if (!_isGameWon)
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: GamingTheme.neonGlow(
                              color: GamingTheme.accentNeon,
                              blurRadius: 15,
                            ),
                          ),
                          child: TextField(
                            controller: _guessController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: GamingTheme.gamingTitle(
                              fontSize: 32,
                              color: GamingTheme.accentNeon,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your guess',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: GamingTheme.accentNeon.withOpacity(0.5),
                                  width: 3,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: GamingTheme.accentNeon.withOpacity(0.5),
                                  width: 3,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: GamingTheme.accentNeon,
                                  width: 4,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: const Icon(
                                Icons.pin,
                                color: GamingTheme.accentNeon,
                                size: 32,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 24,
                              ),
                            ),
                            onSubmitted: (_) => _makeGuess(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Guess Button
                        Container(
                          width: double.infinity,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: GamingTheme.neonGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: GamingTheme.neonGlow(
                              color: GamingTheme.accentNeon,
                              blurRadius: 25,
                            ),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: _makeGuess,
                            icon: const Icon(
                              Icons.check_circle,
                              size: 28,
                              color: Colors.white,
                            ),
                            label: Text(
                              'MAKE GUESS',
                              style: GamingTheme.gamingTitle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Victory Section
                  if (_isGameWon)
                    ScaleTransition(
                      scale: _bounceAnimation,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              gradient: GamingTheme.successGradient,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: GamingTheme.neonGlow(
                                color: GamingTheme.accentGreen,
                                blurRadius: 30,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '🏆 VICTORY! 🏆',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'The number was: $_correctNumber',
                                  style: GamingTheme.gamingSubtitle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Completed in $_guessCount attempt${_guessCount > 1 ? 's' : ''}',
                                  style: GamingTheme.gamingBody(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: GamingTheme.successGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: GamingTheme.neonGlow(
                                color: GamingTheme.accentGreen,
                                blurRadius: 25,
                              ),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _initializeGame();
                                });
                              },
                              icon: const Icon(
                                Icons.refresh,
                                size: 28,
                                color: Colors.white,
                              ),
                              label: Text(
                                'PLAY AGAIN',
                                style: GamingTheme.gamingTitle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
