import 'package:flutter/material.dart';
import '../widgets/background_widget.dart';
import '../widgets/lottie_animation_widget.dart';
import '../widgets/common_title_widget.dart'; // For "Banana Classifier" title

class BananaVarietyScreen extends StatelessWidget {
  const BananaVarietyScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 👈 Removes the back button
        title: const CommonTitleWidget(),
        backgroundColor: const Color(0xFF8BC34A), // Greenish background
        elevation: 0,
        centerTitle: true,
      ),
      body: BackgroundWidget(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Row with logout button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.white.withOpacity(0.2),
                      shape: const CircleBorder(),
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () => _logout(context),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // "Choose Your Action" heading
                const Center(
                  child: Text(
                    'Choose Your Action',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Cards for actions
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 30,
                        runSpacing: 30,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildOptionCard(
                            context,
                            title: 'Upload Image',
                            animationPath: 'assets/upload.json',
                            onTap: () => Navigator.pushNamed(context, '/upload'),
                          ),
                          _buildOptionCard(
                            context,
                            title: 'Webcam Feed',
                            animationPath: 'assets/webcam.json',
                            onTap: () => Navigator.pushNamed(context, '/webcam'),
                          ),
                          _buildOptionCard(
                            context,
                            title: 'Capture Image',
                            animationPath: 'assets/capture.json',
                            onTap: () => Navigator.pushNamed(context, '/capture'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String animationPath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 320,
        height: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFAED581),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.green.shade700, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: LottieAnimationWidget(animationPath: animationPath),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
