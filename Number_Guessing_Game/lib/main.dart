import 'package:flutter/material.dart';
import 'package:game/screens/game_screen.dart';
import 'package:game/screens/history_screen.dart';
import 'package:game/screens/login_screen.dart';
import 'package:game/theme/gaming_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Guessing Game',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: GamingTheme.accentNeon,
          secondary: GamingTheme.accentPurple,
          surface: GamingTheme.secondaryDark,
          background: GamingTheme.primaryDark,
          error: GamingTheme.accentPink,
          onPrimary: GamingTheme.primaryDark,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: GamingTheme.primaryDark,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GamingTheme.gamingTitle(fontSize: 24),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: GamingTheme.gamingButton(),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: GamingTheme.accentNeon.withOpacity(0.3),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: GamingTheme.accentNeon.withOpacity(0.3),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: GamingTheme.accentNeon,
              width: 3,
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [GameScreen(), HistoryScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              GamingTheme.primaryDark.withOpacity(0.95),
              GamingTheme.secondaryDark.withOpacity(0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: GamingTheme.accentNeon.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: GamingTheme.accentNeon,
          unselectedItemColor: Colors.white60,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 1.0,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _selectedIndex == 0
                    ? BoxDecoration(
                        color: GamingTheme.accentNeon.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: GamingTheme.accentNeon,
                          width: 2,
                        ),
                      )
                    : null,
                child: const Icon(Icons.sports_esports, size: 28),
              ),
              label: 'PLAY',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _selectedIndex == 1
                    ? BoxDecoration(
                        color: GamingTheme.accentPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: GamingTheme.accentPurple,
                          width: 2,
                        ),
                      )
                    : null,
                child: const Icon(Icons.history, size: 28),
              ),
              label: 'HISTORY',
            ),
          ],
        ),
      ),
    );
  }
}
