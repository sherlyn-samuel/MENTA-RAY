import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  

  void _handleSignUp() {
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign Up button pressed. (Logic pending)')),
    );
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/tempwhale.jpeg',
            fit: BoxFit.cover,
          ),

          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Sign up form area
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 550, // Same width as login box
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column( // Use Column for vertical arrangement of elements
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontFamily: 'Pixellari',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Input Fields (Email and Password)
                      Theme(
                        data: ThemeData(brightness: Brightness.dark),
                        child: const Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress, // Specific keyboard for email
                            ),
                            SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(labelText: 'Password'),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30), 
                      
                      // SIGN UP Button
                      SizedBox(
                        width: double.infinity, // Full width button
                        child: OutlinedButton(
                          onPressed: _handleSignUp, 
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70, width: 2),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero, 
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('SIGN UP'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}