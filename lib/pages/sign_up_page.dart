import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import flutter_secure_storage
import '../widgets/background_widget.dart';
import '../widgets/lottie_animation_widget.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage(); // Initialize secure storage

  // Function to handle sign up logic and store credentials
  void _signUp() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _message = 'Username and password cannot be empty.');
      return;
    }

    // Check if username already exists
    String? existingPassword = await secureStorage.read(key: 'password_$username');

    if (existingPassword != null) {
      setState(() => _message = 'Username already exists.');
    } else {
      // Store username and password securely
      await secureStorage.write(key: 'password_$username', value: password);
      await secureStorage.write(key: 'last_logged_in', value: username); // optional
      setState(() => _message = 'Account created successfully!');
    }
  }

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
                    'Create a New Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      shadows: [Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(2, 2))],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const LottieAnimationWidget(animationPath: 'assets/lottie_animation.json'),
                  const SizedBox(height: 30),
                  Container(
                    width: 340,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          spreadRadius: 3,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField(_usernameController, 'Username', Icons.person_outline),
                        const SizedBox(height: 20),
                        _buildTextField(_passwordController, 'Password', Icons.lock_outline, obscureText: true),
                        const SizedBox(height: 20),
                        if (_message.isNotEmpty)
                          Text(
                            _message,
                            style: TextStyle(
                              color: _message.contains('successfully') ? Colors.green : Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent.shade400,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Already have an account? Sign In', style: TextStyle(color: Colors.blueAccent)),
                        ),
                      ],
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w500),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
