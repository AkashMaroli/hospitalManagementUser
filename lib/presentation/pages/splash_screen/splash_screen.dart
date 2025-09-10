import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _showText = false;
  late AnimationController _logoController;
  late Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    // Logo bounce animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScale =
        Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Start logo animation immediately
    _logoController.forward();

    // Trigger text after 1.5s
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _showText = true;
        });
      }
    });

    // Navigate to next screen after 3s
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                widget.nextScreen,
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // your themeColor
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated logo with bounce
            ScaleTransition(
              scale: _logoScale,
              child: const Icon(Icons.local_hospital_rounded,
                  size: 75, color: Colors.white),
            ),

            // Animated text with fade + slide
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              width: _showText ? 180 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _showText ? 1.0 : 0.0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  offset: _showText ? Offset.zero : const Offset(0.3, 0),
                  child: const Text(
                    'MedValley',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white,
                    ),
                    softWrap: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
