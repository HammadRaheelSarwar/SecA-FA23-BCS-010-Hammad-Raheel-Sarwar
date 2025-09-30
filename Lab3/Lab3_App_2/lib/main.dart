import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F6FA)),
      home: const MainScreen(),
    );
  }
}

/// ---------- Main Screen with Bottom Navigation ----------
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Default to Profile
  String name = "Hammad Raheel Sarwar";
  String profession = "Student";
  String email = "hammadraheesarwar@gmail.com";

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return ProfileScreen(
          name: name,
          profession: profession,
          email: email,
        );
      case 2:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

/// ---------- Home Screen ----------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Welcome to Home!",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// ---------- Settings Screen ----------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Settings Page",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// ---------- Profile Screen ----------
class ProfileScreen extends StatelessWidget {
  final String name;
  final String profession;
  final String email;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.profession,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                      'assets/ProfilePicture.jpg', // Make sure to add this image in your pubspec.yaml
                    ),
                    // Fallback in case image is not found
                    //child: Icon(
                   //   Icons.person,
                     // size: 50,
                     // color: Colors.white,
                   // ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    profession,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              ProfileInfoCard(
                icon: Icons.email,
                title: "Email",
                value: email,
              ),
              const SizedBox(height: 15),
              const ProfileInfoCard(
                icon: Icons.phone,
                title: "Phone",
                value: "+92 300 1234561",
              ),
              const SizedBox(height: 15),
              const ProfileInfoCard(
                icon: Icons.location_on,
                title: "Address",
                value: "Khanewal, Punjab, Pakistan",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------- Profile Info Card ----------
class ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}