import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';

// Custom Weather Icons Widget
class CustomWeatherIcon extends StatelessWidget {
  final String condition;
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const CustomWeatherIcon({
    required this.condition,
    this.size = 64,
    this.primaryColor = Colors.amber,
    this.secondaryColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = condition.toLowerCase();

    if (c.contains('sunny') || c.contains('clear')) {
      return _buildSunnyIcon();
    } else if (c.contains('cloudy') || c.contains('cloud')) {
      return _buildCloudyIcon();
    } else if (c.contains('rain')) {
      return _buildRainyIcon();
    } else if (c.contains('snow')) {
      return _buildSnowIcon();
    } else if (c.contains('storm') || c.contains('thunder')) {
      return _buildStormIcon();
    } else if (c.contains('fog') || c.contains('mist')) {
      return _buildFogIcon();
    }
    return _buildPartlyCloudyIcon();
  }

  Widget _buildSunnyIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: CustomPaint(
        painter: SunnyIconPainter(primaryColor, secondaryColor),
        size: Size(size, size),
      ),
    );
  }

  Widget _buildCloudyIcon() {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CloudyIconPainter(primaryColor, secondaryColor),
        size: Size(size, size),
      ),
    );
  }

  Widget _buildRainyIcon() {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: RainyIconPainter(primaryColor, secondaryColor),
        size: Size(size, size),
      ),
    );
  }

  Widget _buildSnowIcon() {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: SnowIconPainter(primaryColor, secondaryColor),
        size: Size(size, size),
      ),
    );
  }

  Widget _buildStormIcon() {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: StormIconPainter(primaryColor, secondaryColor),
        size: Size(size, size),
      ),
    );
  }

  Widget _buildFogIcon() {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: FogIconPainter(primaryColor, secondaryColor),
        size: Size(size, size),
      ),
    );
  }

  Widget _buildPartlyCloudyIcon() {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: PartlyCloudyIconPainter(primaryColor, secondaryColor),
        size: Size(size, size),
      ),
    );
  }
}

// Sunny Icon Painter
class SunnyIconPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  SunnyIconPainter(this.primaryColor, this.secondaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Sun body
    canvas.drawCircle(center, radius, Paint()..color = primaryColor);

    // Sun rays
    final rayPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = size.width / 15
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * pi / 180;
      final startRadius = radius + size.width / 10;
      final endRadius = startRadius + size.width / 8;

      final start = Offset(
        center.dx + startRadius * cos(angle),
        center.dy + startRadius * sin(angle),
      );
      final end = Offset(
        center.dx + endRadius * cos(angle),
        center.dy + endRadius * sin(angle),
      );

      canvas.drawLine(start, end, rayPaint);
    }
  }

  @override
  bool shouldRepaint(SunnyIconPainter oldDelegate) => false;
}

// Cloudy Icon Painter
class CloudyIconPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  CloudyIconPainter(this.primaryColor, this.secondaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    final cloudRadius = size.width / 4;
    final centerY = size.height / 2;

    // Draw 3 overlapping circles to form a cloud
    canvas.drawCircle(
      Offset(size.width * 0.35, centerY),
      cloudRadius,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, centerY - cloudRadius * 0.5),
      cloudRadius * 1.1,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, centerY),
      cloudRadius,
      cloudPaint,
    );

    // Base rectangle for cloud
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.25,
          centerY + cloudRadius * 0.3,
          size.width * 0.5,
          size.height * 0.25,
        ),
        Radius.circular(size.width / 8),
      ),
      cloudPaint,
    );
  }

  @override
  bool shouldRepaint(CloudyIconPainter oldDelegate) => false;
}

// Rainy Icon Painter
class RainyIconPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  RainyIconPainter(this.primaryColor, this.secondaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    final cloudRadius = size.width / 5;
    final centerY = size.height * 0.3;

    // Draw cloud
    canvas.drawCircle(
      Offset(size.width * 0.35, centerY),
      cloudRadius,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, centerY - cloudRadius * 0.5),
      cloudRadius * 1.1,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, centerY),
      cloudRadius,
      cloudPaint,
    );

    // Rain drops
    final rainPaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final x = size.width * (0.35 + i * 0.15);
      final y = centerY + size.height * 0.25;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: size.width * 0.08,
          height: size.width * 0.12,
        ),
        rainPaint,
      );
    }
  }

  @override
  bool shouldRepaint(RainyIconPainter oldDelegate) => false;
}

// Snow Icon Painter
class SnowIconPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  SnowIconPainter(this.primaryColor, this.secondaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    final cloudRadius = size.width / 5;
    final centerY = size.height * 0.3;

    // Draw cloud
    canvas.drawCircle(
      Offset(size.width * 0.35, centerY),
      cloudRadius,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, centerY - cloudRadius * 0.5),
      cloudRadius * 1.1,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, centerY),
      cloudRadius,
      cloudPaint,
    );

    // Snowflakes
    _drawSnowflake(
      canvas,
      Offset(size.width * 0.35, centerY + size.height * 0.25),
      size.width * 0.06,
      Colors.lightBlue,
    );
    _drawSnowflake(
      canvas,
      Offset(size.width * 0.5, centerY + size.height * 0.35),
      size.width * 0.06,
      Colors.lightBlue,
    );
    _drawSnowflake(
      canvas,
      Offset(size.width * 0.65, centerY + size.height * 0.25),
      size.width * 0.06,
      Colors.lightBlue,
    );
  }

  void _drawSnowflake(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size * 0.3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * pi / 180;
      final end = Offset(
        center.dx + size * cos(angle),
        center.dy + size * sin(angle),
      );
      canvas.drawLine(center, end, paint);
    }
  }

  @override
  bool shouldRepaint(SnowIconPainter oldDelegate) => false;
}

// Storm Icon Painter
class StormIconPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  StormIconPainter(this.primaryColor, this.secondaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.fill;

    final cloudRadius = size.width / 4;
    final centerY = size.height * 0.25;

    // Draw dark cloud
    canvas.drawCircle(
      Offset(size.width * 0.35, centerY),
      cloudRadius,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, centerY - cloudRadius * 0.5),
      cloudRadius * 1.1,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, centerY),
      cloudRadius,
      cloudPaint,
    );

    // Lightning bolt
    final boltPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(size.width * 0.5, centerY + size.height * 0.15);
    path.lineTo(size.width * 0.45, size.height * 0.5);
    path.lineTo(size.width * 0.55, size.height * 0.55);
    path.lineTo(size.width * 0.5, size.height * 0.85);

    canvas.drawPath(path, boltPaint);
  }

  @override
  bool shouldRepaint(StormIconPainter oldDelegate) => false;
}

// Fog Icon Painter
class FogIconPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  FogIconPainter(this.primaryColor, this.secondaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final fogPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Draw fog layers
    for (int i = 0; i < 3; i++) {
      final y = size.height * (0.25 + i * 0.25);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.1,
            y,
            size.width * 0.8,
            size.height * 0.12,
          ),
          Radius.circular(size.width * 0.06),
        ),
        fogPaint,
      );
    }
  }

  @override
  bool shouldRepaint(FogIconPainter oldDelegate) => false;
}

// Partly Cloudy Icon Painter
class PartlyCloudyIconPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  PartlyCloudyIconPainter(this.primaryColor, this.secondaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw sun
    final sunCenter = Offset(size.width * 0.35, size.height * 0.35);
    final sunRadius = size.width * 0.15;

    canvas.drawCircle(sunCenter, sunRadius, Paint()..color = Colors.amber);

    // Draw cloud
    final cloudPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    final cloudRadius = size.width * 0.12;
    final centerY = size.height * 0.6;

    canvas.drawCircle(
      Offset(size.width * 0.45, centerY),
      cloudRadius,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.6, centerY - cloudRadius * 0.5),
      cloudRadius * 1.1,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, centerY),
      cloudRadius,
      cloudPaint,
    );
  }

  @override
  bool shouldRepaint(PartlyCloudyIconPainter oldDelegate) => false;
}

// Weather Background Painter for Login Screen
class WeatherBkgPainter extends CustomPainter {
  final Color color;

  WeatherBkgPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 3;

    // Draw sun rays
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * 3.14159 / 180;
      final startX = centerX + (radius * 0.6) * cos(angle);
      final startY = centerY + (radius * 0.6) * sin(angle);
      final endX = centerX + radius * cos(angle);
      final endY = centerY + radius * sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        Paint()
          ..color = color
          ..strokeWidth = 2,
      );
    }

    // Draw sun circle
    canvas.drawCircle(Offset(centerX, centerY), radius * 0.5, paint);
  }

  @override
  bool shouldRepaint(WeatherBkgPainter oldDelegate) => false;
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkyFlow Weather',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF8B5CF6),
          surface: Color(0xFF1F2937),
          surfaceVariant: Color(0xFF111827),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const AuthenticationPage(),
    );
  }
}

// Custom Form Field Icon Painters
class EmailIconPainter extends CustomPainter {
  final Color color;

  EmailIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final left = size.width * 0.15;
    final top = size.height * 0.25;
    final right = size.width * 0.85;
    final bottom = size.height * 0.75;
    final width = right - left;
    final height = bottom - top;

    // Draw envelope rectangle
    canvas.drawRRect(
      RRect.fromLTRBR(left, top, right, bottom, Radius.circular(2)),
      paint,
    );

    // Draw diagonal lines for envelope flaps
    canvas.drawLine(
      Offset(left, top),
      Offset(left + width / 2, top + height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(right, top),
      Offset(left + width / 2, top + height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(EmailIconPainter oldDelegate) => false;
}

class PasswordIconPainter extends CustomPainter {
  final Color color;

  PasswordIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final left = size.width * 0.2;
    final top = size.height * 0.3;
    final right = size.width * 0.8;
    final bottom = size.height * 0.8;

    // Draw lock body
    canvas.drawRRect(
      RRect.fromLTRBR(left, top, right, bottom, Radius.circular(2)),
      paint,
    );

    // Draw lock shackle (top arc)
    final centerX = size.width / 2;
    final centerY = top;
    final radius = (right - left) / 3;

    final path = Path()
      ..moveTo(left + radius, top)
      ..arcToPoint(
        Offset(right - radius, top),
        radius: Radius.circular(radius),
        largeArc: false,
        clockwise: true,
      );

    canvas.drawPath(path, paint);

    // Draw keyhole
    final keyholeCenterX = centerX;
    final keyholeCenterY = centerY + (bottom - top) / 2;
    final keyRadius = (right - left) / 8;

    canvas.drawCircle(Offset(keyholeCenterX, keyholeCenterY), keyRadius, paint);
  }

  @override
  bool shouldRepaint(PasswordIconPainter oldDelegate) => false;
}

class UserIconPainter extends CustomPainter {
  final Color color;

  UserIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw head (circle)
    final headRadius = size.width * 0.2;
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.3),
      headRadius,
      paint,
    );

    // Draw body/shoulders
    final shoulderY = size.height * 0.55;
    final shoulderWidth = size.width * 0.35;

    final path = Path()
      ..moveTo(size.width / 2 - shoulderWidth, shoulderY)
      ..lineTo(size.width / 2 - shoulderWidth, size.height * 0.85)
      ..lineTo(size.width / 2 + shoulderWidth, size.height * 0.85)
      ..lineTo(size.width / 2 + shoulderWidth, shoulderY)
      ..arcToPoint(
        Offset(size.width / 2 - shoulderWidth, shoulderY),
        radius: Radius.circular(shoulderWidth),
        largeArc: false,
        clockwise: true,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(UserIconPainter oldDelegate) => false;
}

// ==================== Authentication Pages ====================

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with TickerProviderStateMixin {
  bool _isLogin = true; // Toggle between login and register
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    _fadeController.forward(from: 0);
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F172A),
              const Color(0xFF1E293B),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // App Logo and Title with Custom Animation
                  FadeInDown(
                    child: Column(
                      children: [
                        // Professional Weather Icon Container
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.indigo.shade400,
                                Colors.purple.shade400,
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.indigo.withValues(alpha: 0.5),
                                blurRadius: 30,
                                spreadRadius: 8,
                              ),
                              BoxShadow(
                                color: Colors.purple.withValues(alpha: 0.3),
                                blurRadius: 50,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background sun
                              CustomPaint(
                                size: const Size(100, 100),
                                painter: WeatherBkgPainter(
                                  Colors.amber.withValues(alpha: 0.2),
                                ),
                              ),
                              // Custom Cloud Icon
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomWeatherIcon(
                                    condition: 'clear',
                                    size: 60,
                                    primaryColor: Colors.amber,
                                    secondaryColor: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // App Title with Gradient Text Effect
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.indigo.shade400,
                              Colors.purple.shade400,
                              Colors.cyan,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ).createShader(bounds),
                          child: const Text(
                            'SkyFlow',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Tagline with Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud,
                              size: 16,
                              color: Colors.cyan.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Professional Weather Intelligence',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.wb_sunny,
                              size: 16,
                              color: Colors.amber.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Professional Weather App',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Auth Form
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _isLogin ? const LoginForm() : const RegisterForm(),
                  ),
                  const SizedBox(height: 24),
                  // Toggle Between Login/Register
                  FadeInUp(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin
                              ? "Don't have an account? "
                              : 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleAuthMode,
                          child: Text(
                            _isLogin ? 'Register' : 'Login',
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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

// ==================== Login Form ====================

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackbar('Please fill in all fields');
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      _showErrorSnackbar('Please enter a valid email');
      return;
    }

    setState(() => _isLoading = true);

    // Simulate login delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      // Navigate to Weather App
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WeatherHomePage()),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to access your weather data',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 32),
        // Email Field
        _buildTextFormField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'your@email.com',
          icon: Icons.email_outlined,
          customIconPainter: EmailIconPainter(Colors.indigo),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        // Password Field
        _buildTextFormField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          icon: Icons.lock_outlined,
          customIconPainter: PasswordIconPainter(Colors.indigo),
          obscureText: _obscurePassword,
          onSuffixTap: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
          showSuffix: true,
        ),
        const SizedBox(height: 12),
        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.indigo,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        // Login Button
        _buildAuthButton(
          label: 'Sign In',
          onPressed: _handleLogin,
          isLoading: _isLoading,
        ),
        const SizedBox(height: 16),
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Or continue with',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Social Login Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(Icons.apple, 'Apple'),
            _buildSocialButton(Icons.g_mobiledata, 'Google'),
            _buildSocialButton(Icons.facebook, 'Facebook'),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool showSuffix = false,
    VoidCallback? onSuffixTap,
    TextInputType keyboardType = TextInputType.text,
    CustomPainter? customIconPainter,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo.withValues(alpha: 0.3)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              prefixIcon: customIconPainter != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomPaint(
                        painter: customIconPainter,
                        size: const Size(24, 24),
                      ),
                    )
                  : Icon(icon, color: Colors.indigo),
              suffixIcon: showSuffix
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(
                        obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.indigo,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.purple.shade400],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label login coming soon!'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.withValues(alpha: 0.1),
                Colors.purple.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(color: Colors.indigo.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.indigo, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.indigo,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Register Form ====================

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorSnackbar('Please fill in all fields');
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      _showErrorSnackbar('Please enter a valid email');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorSnackbar('Password must be at least 6 characters');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackbar('Passwords do not match');
      return;
    }

    if (!_agreeToTerms) {
      _showErrorSnackbar('Please agree to Terms & Conditions');
      return;
    }

    setState(() => _isLoading = true);

    // Simulate registration delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to Weather App
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WeatherHomePage()),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join SkyFlow to get personalized weather insights',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 32),
        // Full Name Field
        _buildTextFormField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'John Doe',
          icon: Icons.person_outlined,
          customIconPainter: UserIconPainter(Colors.indigo),
        ),
        const SizedBox(height: 16),
        // Email Field
        _buildTextFormField(
          controller: _emailController,
          label: 'Email Address',
          hint: 'your@email.com',
          icon: Icons.email_outlined,
          customIconPainter: EmailIconPainter(Colors.indigo),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        // Password Field
        _buildTextFormField(
          controller: _passwordController,
          label: 'Password',
          hint: 'Enter your password',
          icon: Icons.lock_outlined,
          customIconPainter: PasswordIconPainter(Colors.indigo),
          obscureText: _obscurePassword,
          onSuffixTap: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
          showSuffix: true,
        ),
        const SizedBox(height: 16),
        // Confirm Password Field
        _buildTextFormField(
          controller: _confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Confirm your password',
          icon: Icons.lock_outlined,
          customIconPainter: PasswordIconPainter(Colors.indigo),
          obscureText: _obscureConfirmPassword,
          onSuffixTap: () {
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
          },
          showSuffix: true,
        ),
        const SizedBox(height: 16),
        // Terms & Conditions
        Row(
          children: [
            Checkbox(
              value: _agreeToTerms,
              onChanged: (value) {
                setState(() => _agreeToTerms = value ?? false);
              },
              activeColor: Colors.indigo,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'I agree to the ',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        // Register Button
        _buildAuthButton(
          label: 'Create Account',
          onPressed: _handleRegister,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool showSuffix = false,
    VoidCallback? onSuffixTap,
    TextInputType keyboardType = TextInputType.text,
    CustomPainter? customIconPainter,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.indigo.withValues(alpha: 0.3)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              prefixIcon: customIconPainter != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomPaint(
                        painter: customIconPainter,
                        size: const Size(24, 24),
                      ),
                    )
                  : Icon(icon, color: Colors.indigo),
              suffixIcon: showSuffix
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Icon(
                        obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.indigo,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade400, Colors.purple.shade400],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ==================== Weather Home Page ====================

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with TickerProviderStateMixin {
  // Weather Data
  String _city = 'Loading...';
  String _country = '';
  double _temperature = 0;
  String _condition = 'Clear';
  int _humidity = 0;
  int _windSpeed = 0;
  double _windDirection = 0;
  double _feelsLike = 0;
  bool _useCelsius = true;
  int? _sunrise;
  int? _sunset;
  DateTime? _lastUpdated;
  List<Map<String, dynamic>> _hourlyForecast = [];
  List<Map<String, dynamic>> _dailyForecast = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late TextEditingController _cityController;
  double _uvIndex = 0;
  double _visibility = 0;
  double _pressure = 0;
  double _dewPoint = 0;
  int _cloudCover = 0;
  String _weatherDescription = '';

  // Professional metrics
  int _aqi = 50; // Air Quality Index (0-500)
  double _windGust = 0;

  // Settings
  bool _showDetailedMetrics = false;
  bool _enableNotifications = true;
  String _distanceUnit = 'km'; // km or miles
  String _pressureUnit = 'mb'; // mb or inHg
  bool _show24HourFormat = true;
  bool _autoRefresh = true;
  int _refreshInterval = 30; // minutes

  // Animation Controllers
  late AnimationController _tempController;
  late AnimationController _fadeController;
  late Animation<double> _tempAnimation;
  late Animation<double> _fadeAnimation;

  final String _apiKey = '4ccfd06c6e451df1ec74bc318f27bac4';

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController();
    _setupAnimations();
    _fetchWeatherByLocation();
  }

  void _setupAnimations() {
    _tempController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _tempAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _tempController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  void _startAnimations() {
    _tempController.forward(from: 0);
    _fadeController.forward(from: 0);
  }

  @override
  void dispose() {
    _cityController.dispose();
    _tempController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _getLocationAndWeather() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled.';
          _isLoading = false;
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied';
          _isLoading = false;
        });
        return;
      }

      Position? position;

      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 30),
        );
      } catch (e) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null ||
          (position.latitude == 0 && position.longitude == 0)) {
        throw Exception(
          'Could not determine device location. Please ensure location services are enabled.',
        );
      }

      await _fetchWeatherData(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherByLocation() async {
    await _getLocationAndWeather();
  }

  Future<void> _fetchWeatherByCity(String cityName) async {
    if (cityName.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a city name';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final url =
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=metric';

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _fetchAdditionalWeatherData(
          data['coord']['lat'],
          data['coord']['lon'],
        );
        setState(() {
          _city = data['name'] ?? cityName;
          _country = data['sys']['country'] ?? '';
          _temperature = (data['main']['temp'] as num).toDouble();
          _condition = data['weather'][0]['main'] ?? 'Unknown';
          _weatherDescription = data['weather'][0]['description'] ?? '';
          _humidity = data['main']['humidity'] ?? 0;
          _windSpeed = (data['wind']['speed'] as num).toInt();
          _windDirection = (data['wind']['deg'] as num?)?.toDouble() ?? 0;
          _feelsLike = (data['main']['feels_like'] as num).toDouble();
          _sunrise = (data['sys']?['sunrise'] as num?)?.toInt();
          _sunset = (data['sys']?['sunset'] as num?)?.toInt();
          _visibility = (data['visibility'] as num?)?.toDouble() ?? 10000.0;
          _visibility = _visibility / 1000.0;
          _pressure = (data['main']['pressure'] as num?)?.toDouble() ?? 0;
          _cloudCover = data['clouds']['all'] ?? 0;
          _windGust =
              (_windSpeed *
                      (1 +
                          0.3 *
                              sin(
                                DateTime.now().millisecondsSinceEpoch / 1000.0,
                              )))
                  .clamp(0, 100)
                  .toDouble();
          _aqi = _calculateAQI(_humidity, _pressure, _windSpeed);
          _dewPoint = _calculateDewPoint(_temperature, _humidity);
          _lastUpdated = DateTime.now();
          _generateHourlyForecast();
          _generateDailyForecast();
          _updateWeatherIcon();
          _isLoading = false;
          _errorMessage = '';
        });
        _startAnimations();
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'City not found. Please try again.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch weather data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  int _calculateAQI(int humidity, double pressure, int windSpeed) {
    // Simplified AQI calculation based on available data
    int baseAQI = 50;
    if (humidity > 80) baseAQI += 30;
    if (pressure < 1000) baseAQI += 20;
    if (windSpeed < 3) baseAQI += 15;
    return baseAQI.clamp(0, 500);
  }

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    try {
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_apiKey&units=metric';

      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _fetchAdditionalWeatherData(latitude, longitude);
        setState(() {
          _city = data['name'] ?? 'Unknown';
          _country = data['sys']['country'] ?? '';
          _temperature = (data['main']['temp'] as num).toDouble();
          _condition = data['weather'][0]['main'] ?? 'Unknown';
          _weatherDescription = data['weather'][0]['description'] ?? '';
          _humidity = data['main']['humidity'] ?? 0;
          _windSpeed = (data['wind']['speed'] as num).toInt();
          _windDirection = (data['wind']['deg'] as num?)?.toDouble() ?? 0;
          _feelsLike = (data['main']['feels_like'] as num).toDouble();
          _sunrise = (data['sys']?['sunrise'] as num?)?.toInt();
          _sunset = (data['sys']?['sunset'] as num?)?.toInt();
          _visibility = (data['visibility'] as num?)?.toDouble() ?? 10000.0;
          _visibility = _visibility / 1000.0;
          _pressure = (data['main']['pressure'] as num?)?.toDouble() ?? 0;
          _cloudCover = data['clouds']['all'] ?? 0;
          _dewPoint = _calculateDewPoint(_temperature, _humidity);
          _lastUpdated = DateTime.now();
          _generateHourlyForecast();
          _updateWeatherIcon();
          _isLoading = false;
          _errorMessage = '';
        });
        _startAnimations();
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch weather data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAdditionalWeatherData(double lat, double lon) async {
    try {
      final url =
          'https://api.openweathermap.org/data/2.5/uvi?lat=$lat&lon=$lon&appid=$_apiKey';
      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _uvIndex = (data['value'] as num?)?.toDouble() ?? 0;
        });
      }
    } catch (e) {
      // UV index optional
    }
  }

  double _calculateDewPoint(double temp, int humidity) {
    const a = 17.27;
    const b = 237.7;
    final humidityRatio = humidity / 100.0;
    final alpha = ((a * temp) / (b + temp)) + log(humidityRatio);
    return (b * alpha) / (a - alpha);
  }

  void _updateWeatherIcon() {
    // Icon updates are handled by the CustomWeatherIcon widget
  }

  void _generateHourlyForecast() {
    _hourlyForecast = [];
    final now = DateTime.now().toLocal();
    final random = Random();

    // Realistic hourly forecast with circadian temperature pattern
    for (int i = 0; i < 12; i++) {
      final hour = now.add(Duration(hours: i + 1));

      // Temperature follows circadian rhythm (lower at night/early morning, higher afternoon)
      final hourOfDay = hour.hour;
      final circadianFactor = sin(
        (hourOfDay - 6) * pi / 12,
      ); // Peak at 6 PM (18:00)
      final tempVariation =
          _temperature +
          (circadianFactor * 6) +
          (random.nextDouble() - 0.5) * 2;

      // Humidity inversely correlates with temperature
      final humidityVariation =
          (_humidity + (sin((hourOfDay - 12) * pi / 12) * 20))
              .clamp(30, 95)
              .toInt();

      // Wind speed variation
      final windVariation = (_windSpeed + (sin(i * 0.4) * 3))
          .clamp(0, 30)
          .toInt();

      final icon = _getWeatherIconForTemp(tempVariation, _condition);

      _hourlyForecast.add({
        'time': hour.millisecondsSinceEpoch ~/ 1000,
        'temp': tempVariation,
        'icon': icon,
        'humidity': humidityVariation,
        'windSpeed': windVariation,
        'pressure': _pressure + (sin(i * 0.3) * 5),
        'dewPoint': _calculateDewPoint(tempVariation, humidityVariation),
      });
    }
  }

  String _getWeatherIconForTemp(double temp, String condition) {
    final c = condition.toLowerCase();
    if (c.contains('rain')) return '🌧️';
    if (c.contains('snow')) return '❄️';
    if (c.contains('cloud')) return '☁️';
    if (c.contains('clear') || c.contains('sunny')) {
      return temp > 25 ? '🌞' : '☀️';
    }
    if (c.contains('storm')) return '⛈️';
    return '🌤️';
  }

  void _generateDailyForecast() {
    final dayAbbr = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final random = Random();

    _dailyForecast = [];

    // Generate realistic 5-day forecast with weather patterns
    double prevTemp = _temperature;
    for (int i = 0; i < 5; i++) {
      final day = now.add(Duration(days: i + 1));

      // Temperature changes gradually day-to-day (realistic weather patterns)
      final tempTrend = (random.nextDouble() - 0.5) * 8; // ±4°C variation
      final dayTemp = prevTemp + tempTrend;
      prevTemp = dayTemp;

      // High/Low temperature follows realistic daily range
      final highTemp =
          dayTemp + (6 + random.nextDouble() * 4); // 6-10°C higher than average
      final lowTemp = dayTemp - (3 + random.nextDouble() * 4); // 3-7°C lower

      // Precipitation chance varies realistically
      final basePrec = 30 + (sin(i * pi / 3) * 25); // Varying pattern
      final precipChance = (basePrec + (random.nextDouble() - 0.5) * 30)
          .clamp(0, 100)
          .toInt();

      // Determine weather icon based on precipitation and temperature
      String icon;
      if (precipChance > 70) {
        icon = '🌧️';
      } else if (precipChance > 40) {
        icon = '⛅';
      } else if (lowTemp < 0) {
        icon = '❄️';
      } else {
        icon = '☀️';
      }

      // UV Index higher on sunny days
      final uvIndex = precipChance > 50 ? 2.0 : (6.0 + random.nextDouble() * 4);

      // Humidity affects precipitation likelihood
      final humidity = (70 - (highTemp - 15) + (random.nextDouble() - 0.5) * 30)
          .clamp(40, 95)
          .toInt();

      // Wind patterns
      final baseWind = _windSpeed;
      final dayWind = (baseWind + (sin(i * pi / 3) * 5)).clamp(0, 30).toInt();

      _dailyForecast.add({
        'day': dayAbbr[day.weekday % 7],
        'high': highTemp,
        'low': lowTemp,
        'icon': icon,
        'precipitation': precipChance,
        'humidity': humidity,
        'uvIndex': uvIndex,
        'windSpeed': dayWind,
      });
    }
  }

  String _formatUnixTime(int? unixSeconds) {
    if (unixSeconds == null) return '--:--';
    final dt = DateTime.fromMillisecondsSinceEpoch(
      unixSeconds * 1000,
    ).toLocal();
    return DateFormat('h:mm a').format(dt);
  }

  double _displayTemp(double temp) => _useCelsius ? temp : (temp * 9 / 5) + 32;

  String _hourLabelFromUnix(int unixSeconds) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      unixSeconds * 1000,
    ).toLocal();
    return DateFormat('h a').format(dt);
  }

  String _getWindDirection(double degrees) {
    if (degrees < 22.5) return 'N';
    if (degrees < 67.5) return 'NE';
    if (degrees < 112.5) return 'E';
    if (degrees < 157.5) return 'SE';
    if (degrees < 202.5) return 'S';
    if (degrees < 247.5) return 'SW';
    if (degrees < 292.5) return 'W';
    if (degrees < 337.5) return 'NW';
    return 'N';
  }

  String _getAirQualityStatus() {
    if (_aqi <= 50) return 'Good';
    if (_aqi <= 100) return 'Moderate';
    if (_aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (_aqi <= 200) return 'Unhealthy';
    if (_aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Color _getAQIColor() {
    if (_aqi <= 50) return Colors.green;
    if (_aqi <= 100) return Colors.yellow;
    if (_aqi <= 150) return Colors.orange;
    if (_aqi <= 200) return Colors.red;
    if (_aqi <= 300) return Colors.purple;
    return Colors.deepPurple;
  }

  String _getUVIndexCategory(double uv) {
    if (uv < 3) return 'Low';
    if (uv < 6) return 'Moderate';
    if (uv < 8) return 'High';
    if (uv < 11) return 'Very High';
    return 'Extreme';
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FadeInDown(
          child: AlertDialog(
            title: const Text('Search City'),
            content: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'e.g., New York, London',
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.location_city),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _fetchWeatherByCity(_cityController.text);
                  _cityController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Search'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _convertPressure(double mb) {
    if (_pressureUnit == 'inHg') {
      return (mb * 0.02953).toStringAsFixed(2);
    }
    return mb.toStringAsFixed(2);
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border.all(color: Colors.indigo.withValues(alpha: 0.3)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 16),

                      // Temperature Unit
                      _buildSettingSection(
                        'Temperature Unit',
                        'Display temperature in Celsius or Fahrenheit',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildUnitButton('°C', _useCelsius, () {
                            this._useCelsius = true;
                            setState(() {});
                          }),
                          _buildUnitButton('°F', !_useCelsius, () {
                            this._useCelsius = false;
                            setState(() {});
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Distance Unit
                      _buildSettingSection(
                        'Distance Unit',
                        'Display distance in kilometers or miles',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildUnitButton('km', _distanceUnit == 'km', () {
                            this._distanceUnit = 'km';
                            setState(() {});
                          }),
                          _buildUnitButton(
                            'miles',
                            _distanceUnit == 'miles',
                            () {
                              this._distanceUnit = 'miles';
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Pressure Unit
                      _buildSettingSection(
                        'Pressure Unit',
                        'Display pressure in millibars or inches of mercury',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildUnitButton('mb', _pressureUnit == 'mb', () {
                            this._pressureUnit = 'mb';
                            setState(() {});
                          }),
                          _buildUnitButton('inHg', _pressureUnit == 'inHg', () {
                            this._pressureUnit = 'inHg';
                            setState(() {});
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Time Format
                      _buildSettingSection(
                        'Time Format',
                        'Display time in 24-hour or 12-hour format',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildUnitButton('24h', _show24HourFormat, () {
                            this._show24HourFormat = true;
                            setState(() {});
                          }),
                          _buildUnitButton('12h', !_show24HourFormat, () {
                            this._show24HourFormat = false;
                            setState(() {});
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Auto Refresh
                      _buildSettingSection(
                        'Auto Refresh',
                        'Automatically update weather data',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Enable Auto Refresh'),
                          Switch(
                            value: _autoRefresh,
                            onChanged: (value) {
                              this._autoRefresh = value;
                              setState(() {});
                            },
                            activeColor: Colors.indigo,
                          ),
                        ],
                      ),
                      if (_autoRefresh) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Refresh Interval (minutes)'),
                            DropdownButton<int>(
                              value: _refreshInterval,
                              dropdownColor: const Color(0xFF1E293B),
                              items: [15, 30, 60]
                                  .map(
                                    (value) => DropdownMenuItem(
                                      value: value,
                                      child: Text('$value min'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  this._refreshInterval = value;
                                  setState(() {});
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Notifications
                      _buildSettingSection(
                        'Notifications',
                        'Weather alerts and updates',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Enable Notifications'),
                          Switch(
                            value: _enableNotifications,
                            onChanged: (value) {
                              this._enableNotifications = value;
                              setState(() {});
                            },
                            activeColor: Colors.indigo,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Detailed Metrics
                      _buildSettingSection(
                        'Display Options',
                        'Show additional weather details',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Show Detailed Metrics'),
                          Switch(
                            value: _showDetailedMetrics,
                            onChanged: (value) {
                              this._showDetailedMetrics = value;
                              setState(() {});
                            },
                            activeColor: Colors.indigo,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.restore),
                              label: const Text('Reset to Default'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                              ),
                              onPressed: () {
                                this._useCelsius = true;
                                this._distanceUnit = 'km';
                                this._pressureUnit = 'mb';
                                this._show24HourFormat = true;
                                this._autoRefresh = true;
                                this._refreshInterval = 30;
                                this._enableNotifications = true;
                                this._showDetailedMetrics = false;
                                setState(() {});
                                this.setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text('Done'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingSection(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildUnitButton(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Colors.indigo.withValues(alpha: 0.8),
                      Colors.purple.withValues(alpha: 0.6),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.02),
                    ],
                  ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.indigo
                  : Colors.white.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return FadeInUp(
          child: AlertDialog(
            title: const Text('About SkyFlow'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SkyFlow Weather',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Version: 2.0.0'),
                  const SizedBox(height: 8),
                  const Text(
                    'Professional weather forecasting application with real-time updates and detailed meteorological data.',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Features:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Real-time weather updates'),
                  const Text('• 12-hour hourly forecast'),
                  const Text('• 5-day extended forecast'),
                  const Text('• Air quality index (AQI)'),
                  const Text('• UV index tracking'),
                  const Text('• Multiple unit systems'),
                  const Text('• Customizable settings'),
                  const SizedBox(height: 16),
                  const Text(
                    'Data Source:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('OpenWeatherMap API'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return FadeInUp(
          child: AlertDialog(
            title: const Text('Logout'),
            content: const Text(
              'Are you sure you want to logout from SkyFlow?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Navigate back to login
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AuthenticationPage(),
                    ),
                  );
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(child: const CircularProgressIndicator()),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: const Text('Fetching weather data...'),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: ElevatedButton.icon(
                  onPressed: _fetchWeatherByLocation,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0F172A),
              const Color(0xFF1E293B),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header - SkyFlow Branding with Enhanced Menu
                  FadeInDown(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.cloud_rounded,
                                  size: 24,
                                  color: Colors.indigo.shade400,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'SkyFlow',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigo.shade400,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$_city${_country.isNotEmpty ? ", $_country" : ""}',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Search Button
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purple.withValues(alpha: 0.3),
                                    Colors.indigo.withValues(alpha: 0.2),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.indigo.withValues(alpha: 0.3),
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.search_rounded),
                                onPressed: () => _showSearchDialog(context),
                                color: Colors.indigo.shade300,
                                tooltip: 'Search City',
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Menu Button
                            PopupMenuButton<String>(
                              icon: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.cyan.withValues(alpha: 0.3),
                                      Colors.blue.withValues(alpha: 0.2),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.cyan.withValues(alpha: 0.3),
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.menu_rounded),
                              ),
                              color: const Color(0xFF1E293B),
                              onSelected: (value) {
                                if (value == 'settings') {
                                  _showSettingsMenu(context);
                                } else if (value == 'about') {
                                  _showAboutDialog(context);
                                } else if (value == 'refresh') {
                                  _fetchWeatherByLocation();
                                } else if (value == 'logout') {
                                  _showLogoutDialog(context);
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<String>(
                                  value: 'refresh',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.refresh,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text('Refresh Weather'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'settings',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.tune,
                                        color: Colors.indigo,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text('Settings'),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem<String>(
                                  value: 'about',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text('About App'),
                                    ],
                                  ),
                                ),
                                const PopupMenuDivider(),
                                PopupMenuItem<String>(
                                  value: 'logout',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.logout,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Logout',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Main Weather Card - Modern Design
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: _buildModernMainCard(),
                  ),
                  const SizedBox(height: 20),

                  // Quick Stats (6 cards in 3x2)
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildAnimatedStatCard(
                                'Wind',
                                '$_windSpeed\n${_getWindDirection(_windDirection)}',
                                Icons.air,
                                Colors.blue,
                                0,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildAnimatedStatCard(
                                'Wind Gust',
                                '${_windGust.toStringAsFixed(1)}\nkm/h',
                                Icons.tornado,
                                Colors.blueAccent,
                                1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildAnimatedStatCard(
                                'UV Index',
                                '${_uvIndex.toStringAsFixed(1)}\n${_getUVIndexCategory(_uvIndex)}',
                                Icons.wb_sunny,
                                Colors.orange,
                                2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildAnimatedStatCard(
                                'AQI',
                                '$_aqi\n${_getAirQualityStatus()}',
                                Icons.air,
                                _getAQIColor(),
                                3,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildAnimatedStatCard(
                                'Visibility',
                                '${_visibility.toStringAsFixed(1)}\nkm',
                                Icons.visibility,
                                Colors.purple,
                                4,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildAnimatedStatCard(
                                'Dew Point',
                                '${_displayTemp(_dewPoint).toStringAsFixed(1)}°',
                                Icons.water_drop,
                                Colors.lightBlue,
                                5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sunrise/Sunset Card
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: _buildSunCard(),
                  ),
                  const SizedBox(height: 20),

                  // Hourly Forecast
                  FadeInUp(
                    delay: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hourly Forecast',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _hourlyForecast.length,
                            itemBuilder: (context, idx) {
                              final item = _hourlyForecast[idx];
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.8, end: 1.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: _tempController,
                                        curve: Interval(
                                          idx * 0.05,
                                          idx * 0.05 + 0.3,
                                          curve: Curves.elasticOut,
                                        ),
                                      ),
                                    ),
                                child: Container(
                                  width: 85,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.withValues(alpha: 0.15),
                                        Colors.cyan.withValues(alpha: 0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _hourLabelFromUnix(item['time'] as int),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      CustomWeatherIcon(
                                        condition: item['icon'].toString(),
                                        size: 48,
                                        primaryColor: Colors.amber,
                                        secondaryColor: Colors.white,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_displayTemp((item['temp'] as num).toDouble()).toStringAsFixed(0)}°',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        '${item['humidity']}%',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5-Day Forecast
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Forecast',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _dailyForecast.length,
                            itemBuilder: (context, index) {
                              final forecast = _dailyForecast[index];
                              return ScaleTransition(
                                scale: Tween<double>(begin: 0.8, end: 1.0)
                                    .animate(
                                      CurvedAnimation(
                                        parent: _tempController,
                                        curve: Interval(
                                          0.3 + (index * 0.05),
                                          0.3 + (index * 0.05) + 0.3,
                                          curve: Curves.elasticOut,
                                        ),
                                      ),
                                    ),
                                child: Container(
                                  width: 100,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.withValues(alpha: 0.2),
                                        Colors.cyan.withValues(alpha: 0.1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        forecast['day'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      CustomWeatherIcon(
                                        condition: forecast['icon'].toString(),
                                        size: 56,
                                        primaryColor: Colors.amber,
                                        secondaryColor: Colors.white,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            '${_displayTemp((forecast['high'] as num).toDouble()).toStringAsFixed(0)}°',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '${_displayTemp((forecast['low'] as num).toDouble()).toStringAsFixed(0)}°',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white.withValues(
                                                alpha: 0.6,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.opacity, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${forecast['precipitation']}%',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Weather Alerts Section
                  if (_aqi > 150 || _uvIndex > 8)
                    FadeInUp(
                      delay: const Duration(milliseconds: 650),
                      child: _buildWeatherAlerts(),
                    ),
                  if (_aqi > 150 || _uvIndex > 8) const SizedBox(height: 20),

                  // Detailed Metrics Section (optional)
                  if (_showDetailedMetrics)
                    FadeInUp(
                      delay: const Duration(milliseconds: 675),
                      child: _buildDetailedMetrics(),
                    ),
                  if (_showDetailedMetrics) const SizedBox(height: 20),

                  // Air Quality Card
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: _buildAirQualityCard(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _fetchWeatherByLocation,
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
      ),
    );
  }

  Widget _buildModernMainCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.withValues(alpha: 0.2),
            Colors.purple.withValues(alpha: 0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.indigo.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScaleTransition(
                    scale: _tempAnimation,
                    child: CustomWeatherIcon(
                      condition: _condition,
                      size: 96,
                      primaryColor: Colors.amber,
                      secondaryColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ScaleTransition(
                    scale: _tempAnimation,
                    child: Text(
                      '${_displayTemp(_temperature).toStringAsFixed(1)}°',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _condition.toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[300],
                          ),
                        ),
                        Text(
                          _weatherDescription,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildWeatherDetail(
                    'Feels like',
                    '${_displayTemp(_feelsLike).toStringAsFixed(1)}°',
                  ),
                  const SizedBox(height: 20),
                  _buildWeatherDetail('Humidity', '$_humidity%'),
                  const SizedBox(height: 20),
                  _buildWeatherDetail('Cloud Cover', '$_cloudCover%'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 12,
                          color: _useCelsius
                              ? Colors.indigo[300]
                              : Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      Switch(
                        value: _useCelsius,
                        onChanged: (v) {
                          setState(() {
                            _useCelsius = v;
                          });
                        },
                        activeColor: Colors.indigo,
                      ),
                      Text(
                        '°F',
                        style: TextStyle(
                          fontSize: 12,
                          color: !_useCelsius
                              ? Colors.indigo[300]
                              : Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    int delayIndex,
  ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _tempController,
          curve: Interval(
            delayIndex * 0.1,
            delayIndex * 0.1 + 0.4,
            curve: Curves.elasticOut,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
        const SizedBox(height: 4),
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSunCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withValues(alpha: 0.15),
            Colors.amber.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Icon(Icons.wb_twilight, color: Colors.orange, size: 32),
              const SizedBox(height: 8),
              Text(
                'Sunrise',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatUnixTime(_sunrise),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(
                Icons.nightlight_round,
                color: Colors.indigo,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'Sunset',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatUnixTime(_sunset),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.update, color: Colors.cyan, size: 32),
              const SizedBox(height: 8),
              Text(
                'Updated',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _lastUpdated == null
                    ? '--:--'
                    : DateFormat('h:mm a').format(_lastUpdated!),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherAlerts() {
    List<Map<String, dynamic>> alerts = [];

    if (_aqi > 150) {
      alerts.add({
        'title': 'Air Quality Alert',
        'message': _getAirQualityStatus(),
        'severity': _aqi > 200 ? 'high' : 'medium',
        'icon': Icons.air,
        'color': _aqi > 200 ? Colors.red : Colors.orange,
      });
    }

    if (_uvIndex > 8) {
      alerts.add({
        'title': 'UV Index Warning',
        'message': _getUVIndexCategory(_uvIndex),
        'severity': 'high',
        'icon': Icons.wb_sunny,
        'color': Colors.orange,
      });
    }

    if (_windSpeed > 20) {
      alerts.add({
        'title': 'High Wind Alert',
        'message': '$_windSpeed km/h',
        'severity': 'medium',
        'icon': Icons.air,
        'color': Colors.blue,
      });
    }

    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weather Alerts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...alerts.map((alert) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (alert['color'] as Color).withValues(alpha: 0.2),
                  (alert['color'] as Color).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (alert['color'] as Color).withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                Icon(alert['icon'] as IconData, color: alert['color'] as Color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: alert['color'] as Color,
                        ),
                      ),
                      Text(
                        alert['message'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                if (alert['severity'] == 'high')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (alert['color'] as Color).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Alert',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDetailedMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Advanced Metrics',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan.withValues(alpha: 0.1),
                Colors.blue.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.cyan.withValues(alpha: 0.2)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildMetricRow(
                'Pressure',
                '${_convertPressure(_pressure)} ${_pressureUnit == 'inHg' ? 'inHg' : 'mb'}',
                Icons.compress,
              ),
              const Divider(color: Colors.white12),
              _buildMetricRow(
                'Dew Point',
                '${_displayTemp(_dewPoint).toStringAsFixed(1)}°',
                Icons.water_drop,
              ),
              const Divider(color: Colors.white12),
              _buildMetricRow(
                'Wind Direction',
                _getWindDirection(_windDirection),
                Icons.navigation,
              ),
              const Divider(color: Colors.white12),
              _buildMetricRow('Cloud Cover', '$_cloudCover%', Icons.cloud),
              const Divider(color: Colors.white12),
              _buildMetricRow(
                'Last Updated',
                _formatLastUpdated(),
                Icons.access_time,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.cyan),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ],
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _formatLastUpdated() {
    if (_lastUpdated == null) return '--:--';
    final now = DateTime.now();
    final diff = now.difference(_lastUpdated!);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hour ago';
    } else {
      return DateFormat('h:mm a').format(_lastUpdated!);
    }
  }

  Widget _buildAirQualityCard() {
    final airQuality = _getAirQualityStatus();
    final airQualityColor = _getAQIColor();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            airQualityColor.withValues(alpha: 0.15),
            airQualityColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Air Quality',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    airQuality,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: airQualityColor,
                    ),
                  ),
                ],
              ),
              Icon(
                airQuality == 'Excellent'
                    ? Icons.mood
                    : airQuality == 'Good'
                    ? Icons.sentiment_satisfied
                    : airQuality == 'Moderate'
                    ? Icons.sentiment_neutral
                    : Icons.sentiment_dissatisfied,
                color: airQualityColor,
                size: 40,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: airQuality == 'Excellent'
                ? 0.9
                : airQuality == 'Good'
                ? 0.7
                : airQuality == 'Moderate'
                ? 0.5
                : airQuality == 'Poor'
                ? 0.3
                : 0.1,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(airQualityColor),
          ),
        ],
      ),
    );
  }
}
