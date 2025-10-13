import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';

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
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  bool _rememberMe = false; 

  @override
  void initState() {
    super.initState();
    
    _loadRememberMePreference(); 
  }

  
  void _loadRememberMePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false; 
    });
  }

  void _saveRememberMePreference(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', newValue);
  }

  void _handleLogin() {
    _saveRememberMePreference(_rememberMe);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login attempted. Remember Me: $_rememberMe')),
    );
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/tempwhale.jpeg',
            fit: BoxFit.cover,
          ),
          
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 550, 
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
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
                          color: Colors.white, 
                        ),
                      ),
                      const SizedBox(height: 20),
                      Theme(
                        data: ThemeData(brightness: Brightness.dark), 
                        child: const Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'Username'),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(labelText: 'Password'),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _rememberMe = newValue ?? false;
                                });
                                _saveRememberMePreference(_rememberMe);
                              },
                              activeColor: Colors.blue,
                            ),
                            const Text(
                              "Remember Me",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30), 
                      
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _handleLogin, 
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white70, width: 2),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero, 
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('LOGIN'),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
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