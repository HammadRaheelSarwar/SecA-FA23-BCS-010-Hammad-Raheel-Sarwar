import 'package:flutter/material.dart';
import 'package:game/screens/registration_screen.dart';
import 'package:game/main.dart';
import 'package:game/database/db_helper.dart';
import 'package:game/theme/gaming_theme.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final db = DatabaseHelper();
      final userMap = await db.getUserByEmail(_emailController.text.trim());
      if (userMap == null) {
        if (mounted) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(child: Text('User not found. Please register.')),
                ],
              ),
              backgroundColor: GamingTheme.accentPink,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }
      final storedHash = userMap['password_hash'] as String;
      final enteredHash = _hashPassword(_passwordController.text);
      if (storedHash == enteredHash) {
        if (mounted) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Login successful!'),
                ],
              ),
              backgroundColor: GamingTheme.accentGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 1),
            ),
          );
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainScreen()),
            );
          }
        }
      } else {
        if (mounted) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Invalid email or password'),
                ],
              ),
              backgroundColor: GamingTheme.accentPink,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: GamingTheme.accentPink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: GamingTheme.primaryGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        height: size.height - MediaQuery.of(context).padding.top,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated Logo/Header
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.elasticOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: GamingTheme.neonGradient,
                                      boxShadow: GamingTheme.neonGlow(
                                        color: GamingTheme.accentNeon,
                                        blurRadius: 30,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.sports_esports,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'WELCOME BACK',
                              style: GamingTheme.gamingTitle(fontSize: 36),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Login to continue your gaming journey',
                              style: GamingTheme.gamingSubtitle(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 50),
                            // Glassmorphism Form Card
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: GamingTheme.glassmorphism(
                                opacity: 0.15,
                                blur: 20,
                                borderRadius: 24,
                                borderColor: GamingTheme.accentNeon,
                                borderWidth: 2,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Email Field
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: GamingTheme.gamingInput(
                                        hintText: 'Email Address',
                                        prefixIcon: Icons.email_outlined,
                                        iconColor: GamingTheme.accentNeon,
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        if (!v.contains('@')) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    // Password Field
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 16,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: GamingTheme.accentNeon,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: GamingTheme.accentNeon,
                                          ),
                                          onPressed: () {
                                            setState(
                                              () =>
                                                  _obscurePassword =
                                                      !_obscurePassword,
                                            );
                                          },
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.1),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: GamingTheme.accentNeon
                                                .withOpacity(0.3),
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide(
                                            color: GamingTheme.accentNeon
                                                .withOpacity(0.3),
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 18,
                                        ),
                                      ),
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 32),
                                    // Login Button
                                    Container(
                                      width: double.infinity,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: GamingTheme.neonGradient,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: GamingTheme.neonGlow(
                                          color: GamingTheme.accentNeon,
                                          blurRadius: 20,
                                        ),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: _loading ? null : _login,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: _loading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                    Colors.white,
                                                  ),
                                                ),
                                              )
                                            : Text(
                                                'LOGIN',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18,
                                                  letterSpacing: 2.0,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Register Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'New to the game? ',
                                  style: GamingTheme.gamingBody(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const RegistrationScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: GamingTheme.accentPurple,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'REGISTER',
                                      style: TextStyle(
                                        color: GamingTheme.accentPurple,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
