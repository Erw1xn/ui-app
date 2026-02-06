// lib/main.dart

import 'package:flutter/material.dart';// ✨ 1. Import your expert selection screen
import 'package:chat_ui_lab/screens/expert_selection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persona App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.blueGrey[800],
      ),
      // ✨ 2. THE FIX: Set ExpertSelectionScreen as the home screen
      home: const ExpertSelectionScreen(),
      debugShowCheckedModeBanner: false,  // Clean screen
    );
  }
}

// ✨ 3. The HomeScreen class is no longer needed and can be removed.
/*
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Dashboard'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the AI Expert Chat',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExpertSelectionScreen(),
                  ),
                );
              },
              child: const Text('Choose an Expert'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
