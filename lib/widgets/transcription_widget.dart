import 'package:flutter/material.dart';
import '../models/transcription.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class TranscriptionWidget extends StatelessWidget {
  final List<Transcription> transcriptions;
  final int currentPosition;

  const TranscriptionWidget({
    super.key,
    required this.transcriptions,
    required this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transcriptions.length,
      itemBuilder: (context, index) {
        final transcription = transcriptions[index];
        final isActive = _isTranscriptionActive(transcription, index);
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive
                ? const Color.fromARGB(255, 241, 240, 240)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isActive
                  ? Icon(IconsaxPlusLinear.sound, color: Colors.grey[600])
                  : Icon(IconsaxPlusLinear.play, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                _formatDuration(transcription.baseTime),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  transcription.sentence,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: isActive
                        ? const Color.fromARGB(255, 33, 33, 33)
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _isTranscriptionActive(Transcription transcription, int index) {
    if (index == transcriptions.length - 1) {
      return currentPosition >= transcription.baseTime;
    }
    return currentPosition >= transcription.baseTime &&
        currentPosition < transcriptions[index + 1].baseTime;
  }

  String _formatDuration(int milliseconds) {
    final seconds = milliseconds ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
