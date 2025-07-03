import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationWidget extends StatelessWidget {
  final String animationPath;

  const LottieAnimationWidget({super.key, required this.animationPath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        animationPath,  // Path to your Lottie animation
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        repeat: true,  // Optionally make the animation repeat indefinitely
      ),
    );
  }
}
