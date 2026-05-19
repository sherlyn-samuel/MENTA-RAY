import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

import 'math_game.dart';
import 'math_game_h.dart';
import 'math_game_m.dart'; 
import 'isl_game.dart'; 
import 'isl_game_h.dart';
import 'isl_game_m.dart'; 
import 'leaderboard.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MathDirective(),
  ));
}

class MathDirective extends StatefulWidget {
  const MathDirective({super.key});

  @override
  State<MathDirective> createState() => _MathDirectiveState();
}

class _MathDirectiveState extends State<MathDirective>
    with SingleTickerProviderStateMixin {
  bool showQuestBoard = false;
  String currentMenu = 'subjects';
  String selectedSubject = '';
  bool showDialogue = true;
  String displayedText = "";
  String speakerName = "Menta Ray";
  
  final String fullMessage =
      "Greetings, Cadet 076. Today, you join the fourth Coral Corps Graduating Fleet of '31. Remember our motto — \"Try, Be, Persist!\" It's your time to show the ocean that you can make the biggest splash!\n\nBut first, you'll need your Cadet ID. Tell me, what is your name?";
  
  bool isTyping = false;
  Timer? _typewriterTimer;
  String userName = "";
  final TextEditingController _nameController = TextEditingController();
  bool showInput = false;
  
  late AnimationController _blinkController;
  late Animation<double> _blinkAnim;

  final AudioPlayer _sfxPlayer = AudioPlayer();
  late Source _bubbleSource;

  @override
  void initState() {
    super.initState();
    _bubbleSource = AssetSource(kIsWeb ? 'audio/bubble.ogg' : 'audio/bubble.mp3');

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    
    _blinkAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_blinkController);
    _startDialogue(fullMessage);
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    _nameController.dispose();
    _blinkController.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  Future<void> _playBubble() async {
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(_bubbleSource);
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  void _startDialogue(String message) {
    if (!mounted) return;
    _typewriterTimer?.cancel();
    setState(() {
      displayedText = "";
      isTyping = true;
      showInput = false;
    });

    int i = 0;
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 38), (timer) {
      if (i < message.length) {
        if (mounted) {
          setState(() => displayedText += message[i]);
          i++;
        } else {
          timer.cancel();
        }
      } else {
        if (mounted) {
          setState(() {
            isTyping = false;
            if (message == fullMessage) showInput = true;
          });
        }
        timer.cancel();
      }
    });
  }

  void _closeDialogue() {
    setState(() => showDialogue = false);
  }

  void _handleDialogueTap() {
    if (isTyping) {
      _typewriterTimer?.cancel();
      setState(() {
        displayedText = userName.isEmpty
            ? fullMessage
            : "$userName? A worthy name! I'll make sure to remember it.\n\nNow tap the quest board to choose your subject.";
        isTyping = false;
        if (userName.isEmpty) showInput = true;
      });
    } else if (!showInput) {
      _closeDialogue();
    }
  }

  Widget _pixelButton(String label, Color color, double btnWidth, VoidCallback onPressed) {
    return SizedBox(
      width: btnWidth,
      height: 24,
      child: ElevatedButton(
        onPressed: () {
          _playBubble();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Pixellari',
            fontWeight: FontWeight.bold,
            fontSize: 9,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double boardWidth = width * 0.8;
        final double boardHeight = height * 0.7;

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/Lobby_Level_final.png',
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 30,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  _playBubble();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LeaderboardPage()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C2E00),
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.emoji_events, 
                        color: Colors.yellowAccent, 
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "RANKS",
                      style: TextStyle(
                        fontFamily: 'Pixellari',
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Positioned(
              top: height * 0.02,
              left: width * 0.15,
              child: GestureDetector(
                onTap: () {
                  if (!showDialogue) setState(() => showQuestBoard = true);
                },
                child: Container(
                  width: width * 0.7,
                  height: height * 0.45,
                  color: Colors.transparent,
                ),
              ),
            ),
            
            if (showQuestBoard)
              GestureDetector(
                onTap: () => setState(() {
                  showQuestBoard = false;
                  currentMenu = 'subjects';
                }),
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {}, 
                      child: Container(
                        width: boardWidth,
                        height: boardHeight,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/Quest_Board.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: boardHeight * 0.16,
                              left: boardWidth * 0.38,
                              child: Text(
                                currentMenu == 'subjects' ? "SUBJECTS:" : "LEVELS:",
                                style: const TextStyle(
                                  fontFamily: 'Pixellari',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            
                            if (currentMenu == 'subjects') ...[
                              Positioned(
                                top: boardHeight * 0.26,
                                left: boardWidth * 0.38,
                                child: _pixelButton("MATH", const Color(0xFF0B1857), 50, () {
                                  setState(() {
                                    selectedSubject = 'MATH';
                                    currentMenu = 'difficulty';
                                  });
                                }),
                              ),
                              Positioned(
                                top: boardHeight * 0.40,
                                left: boardWidth * 0.38,
                                child: _pixelButton("ISL", const Color(0xFF480D29), 50, () {
                                  setState(() {
                                    selectedSubject = 'ISL';
                                    currentMenu = 'difficulty';
                                  });
                                }),
                              ),
                              Positioned(
                                top: boardHeight * 0.54,
                                left: boardWidth * 0.38,
                                child: _pixelButton("RANKINGS", const Color(0xFF5C2E00), 50, () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardPage()));
                                }),
                              ),
                            ],
                            
                            if (currentMenu == 'difficulty') ...[
                              Positioned(
                                top: boardHeight * 0.23,
                                left: boardWidth * 0.55,
                                child: _pixelButton("EASY", const Color(0xFF388E3C), 35, () {
                                  Widget target = selectedSubject == 'MATH'
                                      ? const MathGame()
                                      : const ISLGameEasy();
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => target));
                                }),
                              ),
                              Positioned(
                                top: boardHeight * 0.35,
                                left: boardWidth * 0.67,
                                child: _pixelButton("MEDIUM", const Color(0xFFEF6C00), 40, () {
                                  Widget target = (selectedSubject == 'MATH')
                                      ? const MathGameM() 
                                      : const ISLGameM();
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => target));
                                }),
                              ),
                              Positioned(
                                top: boardHeight * 0.47,
                                left: boardWidth * 0.55,
                                child: _pixelButton("HARD", const Color(0xFFB71C1C), 35, () {
                                  Widget target = selectedSubject == 'MATH'
                                      ? const MathGameH()
                                      : const ISLGameH();
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => target));
                                }),
                              ),
                              Positioned(
                                top: boardHeight * 0.60,
                                left: boardWidth * 0.38,
                                child: _pixelButton("BACK", Colors.black45, 50, () {
                                  setState(() => currentMenu = 'subjects');
                                }),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            if (showDialogue) ...[
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black38, Colors.black87],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/textbox.png',
                    height: 220,
                    width: width,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned(
                bottom: 18 + 155 + 8,
                left: width * 0.08,
                child: Container(
                  height: 22,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: const BoxDecoration(
                    color: Color(0xFF5C2E00),
                    boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(2, 2))],
                  ),
                  child: Text(
                    speakerName,
                    style: const TextStyle(fontFamily: 'Pixellari', fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                bottom: 18,
                left: 20,
                right: 20,
                height: 155,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _handleDialogueTap,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      border: Border.all(color: const Color(0xFF5C2E00).withOpacity(0.8), width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            displayedText,
                            style: const TextStyle(fontFamily: 'Pixellari', fontSize: 12, color: Colors.white, height: 1.5),
                          ),
                        ),
                        if (!isTyping && !showInput)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FadeTransition(
                              opacity: _blinkAnim,
                              child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                        if (showInput)
                          TextField(
                            controller: _nameController,
                            autofocus: true,
                            style: const TextStyle(fontFamily: 'Pixellari', color: Colors.yellow, fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: "Enter Name...",
                              hintStyle: TextStyle(color: Colors.white38),
                              isDense: true,
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
                            ),
                            onSubmitted: (val) {
                              if (val.trim().isEmpty) return;
                              setState(() {
                                userName = val.trim();
                                showInput = false;
                                _startDialogue("$userName? A worthy name! I'll make sure to remember it.\n\nNow tap the quest board to choose your subject.");
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      }),
    );
  }
}