import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/transcription.dart';

class TranscriptionData {
  static Future<List<Transcription>> loadTranscriptions() async {
    final jsonString = await rootBundle.loadString('assets/data/transcription_data.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Transcription.fromJson(json)).toList();
  }
}