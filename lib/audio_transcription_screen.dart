import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/audio_player_widget.dart';
import '../widgets/transcription_widget.dart';
import '../data/transcription_data.dart';
import '../models/transcription.dart';

class AudioTranscriptionScreen extends StatefulWidget {
  const AudioTranscriptionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AudioTranscriptionScreenState createState() =>
      _AudioTranscriptionScreenState();
}

class _AudioTranscriptionScreenState extends State<AudioTranscriptionScreen> {
  List<Transcription> _transcriptions = [];
  String? _audioPath;
  bool _isLoading = true;
  int _currentPosition = 0;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _loadTranscriptions();
  }

  void _initializeAudio() async {
    try {
      final path = await _loadAudio();
      setState(() {
        _audioPath = path;
        _isLoading = false;
      });
    } catch (e) {
      print("Error initializing audio: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _loadAudio() async {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/speech.mp3');
    if (!await file.exists()) {
      final audioAsset = await rootBundle.load('assets/audio/speech.mp3');
      await file.writeAsBytes(audioAsset.buffer.asUint8List());
    }
    return file.path;
  }

  void _loadTranscriptions() async {
    try {
      final transcriptions = await TranscriptionData.loadTranscriptions();
      setState(() {
        _transcriptions = transcriptions;
      });
    } catch (e) {
      print("Error loading transcriptions: $e");
    }
  }

  void _updatePosition(int position) {
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Audio Transcription',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _audioPath != null
                      ? AudioPlayerWidget(
                          audioPath: _audioPath!,
                          onPositionChanged: _updatePosition,
                        )
                      : const Text("Audio file not found"),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TranscriptionWidget(
                    transcriptions: _transcriptions,
                    currentPosition: _currentPosition,
                  ),
                ),
              ],
            ),
    );
  }
}
