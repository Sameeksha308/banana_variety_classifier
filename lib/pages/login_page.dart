import 'package:flutter/material.dart';
import '../widgets/background_widget.dart';
import '../widgets/lottie_animation_widget.dart';
import 'banana_variety_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWidget(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Welcome to the Banana Variety Classifier',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const LottieAnimationWidget(animationPath: 'assets/lottie_animation.json'),
                  const SizedBox(height: 40),

                  // ✨ Start Button without Shadow
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const BananaVarietyScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50), // Green background
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Start',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
