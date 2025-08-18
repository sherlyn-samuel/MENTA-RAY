import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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

         
          Container(
            
            color: Colors.black.withOpacity(0.5),
          ),
          // Login form from here
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "LOGIN",
                      style: TextStyle(
                        fontFamily: 'Pixellari',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Login logic here
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
