import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unichat/signin_page.dart';

class splash_page extends StatefulWidget {
  const splash_page({super.key});

  @override
  State<splash_page> createState() => _splash_pageState();
}

class _splash_pageState extends State<splash_page> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Adjusted duration to 1 second
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 2), () {}); // Wait for 2 seconds, adjusted delay
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signin_page())); // Navigate to SignInPage
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward(); // Start the animation

    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/image/image_no_bg.png',
                fit: BoxFit.fitHeight,
                height: 250, // Adjusted the size to 250
                width: 250,  // Adjusted the size to 250
              ),
            ),
          ),
        ),
      ),
    );
  }
}
