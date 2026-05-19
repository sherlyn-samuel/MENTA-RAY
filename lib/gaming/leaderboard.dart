import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final List<Map<String, dynamic>> players = [
      {"rank": "01", "name": "Cadet Kaveh", "score": 2500},
      {"rank": "02", "name": "Cadet Furina", "score": 2150},
      {"rank": "03", "name": "Cadet Navia", "score": 1900},
      {"rank": "04", "name": "Cadet 076", "score": 1450},
      {"rank": "05", "name": "Cadet Itto", "score": 800},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1857), // Deep ocean blue
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xFFF3E5AB), // Parchment/Paper color
            border: Border.all(color: const Color(0xFF5C2E00), width: 4),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "HALL OF FAME",
                style: TextStyle(
                  fontFamily: 'Pixellari',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C2E00),
                ),
              ),
              const SizedBox(height: 20),
              // Table Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("RANK", style: TextStyle(fontFamily: 'Pixellari', fontWeight: FontWeight.bold)),
                    Text("NAME", style: TextStyle(fontFamily: 'Pixellari', fontWeight: FontWeight.bold)),
                    Text("SCORE", style: TextStyle(fontFamily: 'Pixellari', fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(color: Color(0xFF5C2E00)),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final p = players[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("#${p['rank']}", style: const TextStyle(fontFamily: 'Pixellari')),
                          Text("${p['name']}", style: const TextStyle(fontFamily: 'Pixellari')),
                          Text("${p['score']} pts", style: const TextStyle(fontFamily: 'Pixellari', color: Color(0xFFB71C1C))),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C2E00),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: const Text("BACK TO LOBBY", style: TextStyle(fontFamily: 'Pixellari', color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}