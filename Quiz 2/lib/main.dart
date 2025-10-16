/// The main entry point for the Student Info application.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

/// The entry point of the application.
void main() {
  runApp(const StudentInfoApp());
}

/// The root widget of the Student Info application.
///
/// This widget is a [StatefulWidget] that manages the theme of the application.
class StudentInfoApp extends StatefulWidget {
  /// Creates a new instance of [StudentInfoApp].
  const StudentInfoApp({super.key});

  @override
  State<StudentInfoApp> createState() => _StudentInfoAppState();
}

/// The state for [StudentInfoApp].
class _StudentInfoAppState extends State<StudentInfoApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  /// Loads the theme preference from [SharedPreferences].
  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDark') ?? false;
    });
  }

  /// Toggles the theme between light and dark mode.
  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _saveThemePreference(_isDarkMode);
  }

  /// Saves the theme preference to [SharedPreferences].
  void _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Info',
      debugShowCheckedModeBanner: false,
      color: Colors.teal,

      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: Colors.indigo,
        colorScheme: ColorScheme.light(
          primary: Colors.indigo,
          secondary: Colors.teal,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: Colors.black87,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: Colors.indigoAccent,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.indigoAccent,
          surface: const Color(0xFF121212),
          onPrimary: Colors.black,
          onSurface: Colors.white,
        ),
        textTheme:
          ThemeData(brightness: Brightness.dark).textTheme,
                appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.tealAccent,
          elevation: 6,
          shadowColor: Colors.teal,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            elevation: 4,
          ),
        ),
      ),

      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onThemeToggle: toggleTheme),
    );
  }
}
