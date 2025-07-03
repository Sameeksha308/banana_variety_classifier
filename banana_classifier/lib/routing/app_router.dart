import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'; // For web clean URLs
import 'package:banana_classifier/pages/login_page.dart';
import 'package:banana_classifier/pages/upload_page.dart';
import 'package:banana_classifier/pages/webcam_page.dart';
import 'package:banana_classifier/pages/capture_and_predict_page.dart';
import 'package:banana_classifier/pages/banana_variety_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage()); // Removed 'const'
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage()); // Removed 'const'
      case '/upload':
        return MaterialPageRoute(builder: (_) => UploadPage()); // Removed 'const'
      case '/webcam':
        return MaterialPageRoute(builder: (_) => WebcamPage()); // Removed 'const'
      case '/capture':
        return MaterialPageRoute(builder: (_) => CaptureAndPredictPage()); // Removed 'const'
      case '/home':
        return MaterialPageRoute(builder: (_) => BananaVarietyScreen()); // Removed 'const'
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }

  static void configureAppRoutes() {
    // For removing '#' in URLs
    setUrlStrategy(PathUrlStrategy());
  }
}
