import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPlayerController {
  final PlayerController playerController = PlayerController();
  bool isInitialized = false;

  Future<void> initializePlayer(String audioPath, Function(int) onPositionChanged, Function(bool) onStateChanged) async {
    try {
      await playerController.preparePlayer(
        path: audioPath,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );
      isInitialized = true;

      playerController.onCurrentDurationChanged.listen((duration) {
        onPositionChanged(duration);
      });

      playerController.onPlayerStateChanged.listen((state) {
        bool isPlaying = state == PlayerState.playing;
        onStateChanged(isPlaying);
      });

      playerController.onCompletion.listen((_) async {
        onStateChanged(false);
        onPositionChanged(await playerController.getDuration(DurationType.max));
      });
    } catch (e) {
      print("Error initializing player: $e");
    }
  }

  void dispose() {
    playerController.dispose();
  }

  Future<int> getTotalDuration() async {
    return playerController.getDuration(DurationType.max);
  }

  Future<void> togglePlayPause(bool isPlaying, int currentPosition, int totalDuration) async {
    if (isPlaying) {
      await playerController.pausePlayer();
    } else {
      if (currentPosition >= totalDuration) {
        await playerController.seekTo(0);
      }
      await playerController.startPlayer(finishMode: FinishMode.pause);
    }
  }

  Future<void> stopPlayer() async {
    await playerController.stopPlayer();
  }

  Future<void> seekTo(int position) async {
    await playerController.seekTo(position);
  }
}
