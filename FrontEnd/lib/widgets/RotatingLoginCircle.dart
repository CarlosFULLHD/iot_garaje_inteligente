import 'package:flutter/material.dart';
import 'package:smartpark/style/colors.dart';

class RotatingLoginCircle extends StatefulWidget {
  @override
  _RotatingLoginCircleState createState() => _RotatingLoginCircleState();
}

class _RotatingLoginCircleState extends State<RotatingLoginCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 6.3, // Rotación completa (2*π radianes)
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.login, color: AppColors.white, size: 50),
          ),
        );
      },
    );
  }
}
