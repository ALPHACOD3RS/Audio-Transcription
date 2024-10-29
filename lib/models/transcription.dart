class Transcription {
  final int baseTime;
  final String sentence;

  Transcription({required this.baseTime, required this.sentence});

  factory Transcription.fromJson(Map<String, dynamic> json) {
    return Transcription(
      baseTime: json['base_time'],
      sentence: json['sentence'],
    );
  }
}