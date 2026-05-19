import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gaming/math_directive.dart';
import 'services/auth_provider.dart';
import 'services/player_provider.dart';
import 'services/progress_provider.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initAudio() async {
    if (_isAudioInitialized) return;
    try {
      await _audioPlayer.setSource(AssetSource('audio/bubble.mp3'));
      _isAudioInitialized = true;
      debugPrint('Audio Initialized');
    } catch (e) {
      debugPrint('Init Error: $e');
    }
  }

  Future<void> _playTapSound() async {
    try {
      if (!_isAudioInitialized) await _initAudio();
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/bubble.mp3'));
    } catch (e) {
      debugPrint('Tap Error: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _playTapSound(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Login App',
          routes: {
            '/': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/math': (context) => const MathDirective(),
          },
        ),
      ),
    );
  }
}

const double _panelLeft = 0.07;
const double _panelRight = 0.57;
const double _cardFraction = 0.55;
const double _bottomOffset = 60.0;

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
    );

const TextStyle _titleStyle = TextStyle(
  fontFamily: 'Pixellari',
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

OutlinedButton _actionButton({
  required String label,
  required VoidCallback onPressed,
}) =>
    OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white70, width: 2),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(label),
    );

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRememberMePreference();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loadRememberMePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  void _saveRememberMePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', value);
  }

  void _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(username, password);

    if (success && mounted) {
      _saveRememberMePreference(_rememberMe);
      Navigator.pushNamed(context, '/math');
    } else if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(auth.errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final panelWidth = sw * (_panelRight - _panelLeft);
    final panelCenter = sw * _panelLeft + panelWidth / 2;
    final cardWidth = panelWidth * _cardFraction;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Login.png', fit: BoxFit.cover),
          Positioned(
            left: panelCenter - cardWidth / 2,
            width: cardWidth,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: _bottomOffset),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: _cardDecoration(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("LOGIN",
                            textAlign: TextAlign.center,
                            style: _titleStyle),
                        const SizedBox(height: 16),
                        Theme(
                          data: ThemeData(brightness: Brightness.dark),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle:
                                      TextStyle(color: Colors.white70),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  labelStyle:
                                      TextStyle(color: Colors.white70),
                                ),
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (v) {
                                setState(() => _rememberMe = v ?? false);
                                _saveRememberMePreference(_rememberMe);
                              },
                              activeColor: Colors.blue,
                            ),
                            const Text("Remember Me",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => auth.isLoading
                              ? const Center(
                                  child: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                ))
                              : const SizedBox.shrink(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _actionButton(
                                label: 'LOGIN',
                                onPressed: _handleLogin,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _actionButton(
                                label: 'SIGN UP',
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/signup'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(username, email, password, 'USER');

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created! Please log in.')),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(auth.errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final panelWidth = sw * (_panelRight - _panelLeft);
    final panelCenter = sw * _panelLeft + panelWidth / 2;
    final cardWidth = panelWidth * _cardFraction;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Login.png', fit: BoxFit.cover),
          Positioned(
            left: panelCenter - cardWidth / 2,
            width: cardWidth,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: _bottomOffset),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: _cardDecoration(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("SIGN UP",
                            textAlign: TextAlign.center,
                            style: _titleStyle),
                        const SizedBox(height: 16),
                        Theme(
                          data: ThemeData(brightness: Brightness.dark),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle:
                                      TextStyle(color: Colors.white70),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  labelStyle:
                                      TextStyle(color: Colors.white70),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  labelStyle:
                                      TextStyle(color: Colors.white70),
                                ),
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => auth.isLoading
                              ? const Center(
                                  child: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                ))
                              : const SizedBox.shrink(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _actionButton(
                                label: 'BACK',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _actionButton(
                                label: 'SIGN UP',
                                onPressed: _handleSignUp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}