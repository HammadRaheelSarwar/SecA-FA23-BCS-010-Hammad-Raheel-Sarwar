import 'package:flutter/material.dart';
import 'package:game/database/db_helper.dart';
import 'package:game/models/game_result.dart';
import 'package:game/theme/gaming_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<GameResult>> _gameResults;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _refreshHistory();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _refreshHistory() {
    setState(() {
      _gameResults = _dbHelper.getAllGameResults();
    });
  }

  void _deleteResult(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: GamingTheme.secondaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: GamingTheme.accentPink,
            width: 2,
          ),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: GamingTheme.accentPink,
            ),
            const SizedBox(width: 12),
            Text(
              'Delete Record',
              style: GamingTheme.gamingTitle(fontSize: 20),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this record?',
          style: GamingTheme.gamingBody(fontSize: 16, color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: GamingTheme.errorGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                _dbHelper.deleteGameResult(id);
                _refreshHistory();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Record deleted successfully'),
                      ],
                    ),
                    backgroundColor: GamingTheme.accentGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: GamingTheme.secondaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: GamingTheme.accentPink,
            width: 2,
          ),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.dangerous,
              color: GamingTheme.accentPink,
              size: 32,
            ),
            const SizedBox(width: 12),
            Text(
              'Clear All History',
              style: GamingTheme.gamingTitle(fontSize: 20),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete all records? This cannot be undone.',
          style: GamingTheme.gamingBody(fontSize: 16, color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: GamingTheme.errorGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () {
                _dbHelper.deleteAllGameResults();
                _refreshHistory();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text('All records cleared'),
                      ],
                    ),
                    backgroundColor: GamingTheme.accentGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                'CLEAR ALL',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Correct':
        return GamingTheme.accentGreen;
      case 'Too High':
        return GamingTheme.accentPink;
      case 'Too Low':
        return GamingTheme.accentOrange;
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

  LinearGradient _getStatusGradient(String status) {
    switch (status) {
      case 'Correct':
        return GamingTheme.successGradient;
      case 'Too High':
        return GamingTheme.errorGradient;
      case 'Too Low':
        return GamingTheme.warningGradient;
      default:
        return const LinearGradient(
          colors: [Colors.grey, Colors.grey],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'GAME HISTORY',
          style: GamingTheme.gamingTitle(fontSize: 22),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: GamingTheme.accentNeon.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GamingTheme.accentNeon,
                width: 2,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, size: 24),
              onPressed: _refreshHistory,
              tooltip: 'Refresh',
              color: GamingTheme.accentNeon,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: GamingTheme.accentPink.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: GamingTheme.accentPink,
                width: 2,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.delete_sweep, size: 24),
              onPressed: _clearAllHistory,
              tooltip: 'Clear All',
              color: GamingTheme.accentPink,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: GamingTheme.primaryGradient,
        ),
        child: SafeArea(
          child: FutureBuilder<List<GameResult>>(
            future: _gameResults,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          GamingTheme.accentNeon,
                        ),
                        strokeWidth: 4,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Loading history...',
                        style: GamingTheme.gamingSubtitle(),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: GamingTheme.accentPink.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: GamingTheme.accentPink,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.error_outline,
                          color: GamingTheme.accentPink,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Error: ${snapshot.error}',
                        style: GamingTheme.gamingBody(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final List<GameResult> results = snapshot.data ?? [];

              if (results.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'NO GAME HISTORY YET',
                        style: GamingTheme.gamingTitle(fontSize: 24),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Start a new game to see results here',
                        style: GamingTheme.gamingBody(
                          fontSize: 16,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final GameResult result = results[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getStatusColor(result.status)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getStatusColor(result.status)
                                      .withOpacity(0.5),
                                  width: 2,
                                ),
                                boxShadow: GamingTheme.neonGlow(
                                  color: _getStatusColor(result.status),
                                  blurRadius: 15,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Status Icon
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            gradient: _getStatusGradient(
                                              result.status,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: GamingTheme.neonGlow(
                                              color:
                                                  _getStatusColor(result.status),
                                              blurRadius: 15,
                                            ),
                                          ),
                                          child: Icon(
                                            _getStatusIcon(result.status),
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Game Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'GUESS: ',
                                                    style: GamingTheme
                                                        .gamingBody(
                                                      fontSize: 12,
                                                      color: Colors.white60,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${result.guess}',
                                                    style: GamingTheme
                                                        .gamingTitle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Text(
                                                    'CORRECT: ',
                                                    style: GamingTheme
                                                        .gamingBody(
                                                      fontSize: 12,
                                                      color: Colors.white60,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${result.correctNumber}',
                                                    style: GamingTheme
                                                        .gamingBody(
                                                      fontSize: 16,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: _getStatusGradient(
                                                    result.status,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  result.status.toUpperCase(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                result.getFormattedTimestamp(),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Delete Button
                                        Container(
                                          decoration: BoxDecoration(
                                            color: GamingTheme.accentPink
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: GamingTheme.accentPink,
                                              width: 2,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: GamingTheme.accentPink,
                                            ),
                                            onPressed: () =>
                                                _deleteResult(result.id!),
                                            tooltip: 'Delete',
                                            splashRadius: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
