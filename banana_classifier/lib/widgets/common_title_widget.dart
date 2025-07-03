
import 'package:flutter/material.dart';

class CommonTitleWidget extends StatelessWidget {
  const CommonTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Banana Variety Classifier',
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 40, // Bigger Font
        fontWeight: FontWeight.w900, // Extra Bold
        color: Colors.white, // White text color
        fontFamily: 'Roboto',
        letterSpacing: 1.5, // Add spacing
        shadows: [
          Shadow(
            color: Colors.black45,
            blurRadius: 8,
            offset: Offset(2, 3),
          ),
        ],
      ),
    );
  }
}
