import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final Color primaryColor;
  final Color secondaryColor;

  const GradientBackground({
    super.key,
    required this.child,
    this.primaryColor = const Color(0xFF6366F1),
    this.secondaryColor = const Color(0xFF3B82F6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, secondaryColor],
        ),
      ),
      child: child,
    );
  }
}
