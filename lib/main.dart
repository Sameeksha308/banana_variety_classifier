import 'package:flutter/material.dart';
import 'routing/app_router.dart'; // Import the AppRouter for centralized routing
import 'pages/login_page.dart'; // Import LoginPage
import 'pages/upload_page.dart'; // Import Upload Image page
import 'pages/webcam_page.dart'; // Import Webcam Feed page
import 'pages/capture_and_predict_page.dart'; // Import Capture and Predict page
import 'widgets/background_widget.dart'; // Import BackgroundWidget
import 'widgets/lottie_animation_widget.dart'; // Import LottieAnimationWidget

void main() {
  runApp(const BananaClassifierApp());
}

class BananaClassifierApp extends StatelessWidget {
  const BananaClassifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banana Classifier',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/login',  // Set the initial route to Login page
      onGenerateRoute: AppRouter.generateRoute, // Use AppRouter for handling routes
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}
