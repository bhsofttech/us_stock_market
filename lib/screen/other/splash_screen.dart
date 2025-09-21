import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:us_stock_market/screen/other/home_setup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _logoAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller with longer duration for smoother effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Scale animation: from 0.5 to 1.0 for more dramatic effect
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Opacity animation: from 0.0 to 1.0 with softer curve
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Logo animation: subtle bounce effect
    _logoAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start animation
    _animationController.forward();

    // Navigate to HomeScreen after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!_hasNavigated) {
        _hasNavigated = true;
        Get.offAll(() => const HomeSetUpScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 400));
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1C2526),
              Color(0xFF0A0E0F),
              Color(0xFF000000),
            ],
            stops: [0.0, 0.7, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: _logoAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.trending_up,
                            size: 40,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "US Markets",
                        style: TextStyle(
                          fontFamily: 'SanFranciscoPro',
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Colors.white24,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Your Gateway to Financial Insights",
                        style: TextStyle(
                          fontFamily: 'SanFranciscoPro',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Opacity(
                        opacity: _opacityAnimation.value * 0.7,
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white54),
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
      ),
    );
  }
}
