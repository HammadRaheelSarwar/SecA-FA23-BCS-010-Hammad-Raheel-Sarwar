import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart' as app;

//TODO: Replace with your Supabase URL and Anon Key
const String supabaseUrl = 'https://ovgkmrzwffuthpvbrxpv.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im92Z2ttcnp3ZmZ1dGhwdmJyeHB2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0Njc4NjAsImV4cCI6MjA4MTA0Mzg2MH0.DYwyJWFg-k4DCgIPeNtZyW950CRBi-01z_iXQq6L-qY';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: undefined_method
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Registration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;

        if (session != null) {
          return const app.HomeScreen();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}
