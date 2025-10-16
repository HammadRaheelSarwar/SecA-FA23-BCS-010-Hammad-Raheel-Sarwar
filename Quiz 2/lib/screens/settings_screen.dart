import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  
  const SettingsScreen({super.key, this.onThemeToggle});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDark = false;

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListTile(
        title: Text('Dark Mode'),
        trailing: Switch(
          value: _isDark,
          onChanged: (val) {
            setState(() {
              _isDark = val;
            });
            // Call the theme toggle function from the main app
            if (widget.onThemeToggle != null) {
              widget.onThemeToggle!();
            }
          },
        ),
      ),
    );
  }
}
