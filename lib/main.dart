import 'package:flutter/material.dart';
import 'audio_transcription_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Audio Transcription',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AudioTranscriptionScreen(),
    );
  }
}
