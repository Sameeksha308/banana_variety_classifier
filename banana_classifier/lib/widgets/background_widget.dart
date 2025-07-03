// lib/widgets/background_widget.dart

import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Tropical Banana Plantation Bliss.png'), // Your tropical banana background
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

