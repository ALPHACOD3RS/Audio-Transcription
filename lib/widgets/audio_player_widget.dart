import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final Function(int) onPositionChanged;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    required this.onPositionChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late PlayerController _playerController;
  bool _isPlaying = false;
  int _currentPosition = 0;
  int _totalDuration = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    _playerController = PlayerController();
    try {
      await _playerController.preparePlayer(
        path: widget.audioPath,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );
      _totalDuration = await _playerController.getDuration(DurationType.max);
      _isInitialized = true;
      setState(() {});

      _playerController.onCurrentDurationChanged.listen((duration) {
        setState(() {
          _currentPosition = duration;
        });
        widget.onPositionChanged(duration);
      });

      _playerController.onPlayerStateChanged.listen((state) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      });

      _playerController.onCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _currentPosition = _totalDuration;
        });
      });
    } catch (e) {
      print("Error initializing player: $e");
    }
  }

  Future<void> _togglePlayPause() async {
    if (!_isInitialized) return;

    try {
      if (_isPlaying) {
        await _playerController.pausePlayer();
      } else {
        if (_currentPosition >= _totalDuration) {
          await _playerController.seekTo(0);
        }
        await _playerController.startPlayer(finishMode: FinishMode.pause);
      }
    } catch (e) {
      print("Error toggling play/pause: $e");
    }
  }

  Future<void> _stopPlayer() async {
    if (!_isInitialized) return;

    try {
      await _playerController.stopPlayer();
      setState(() {
        _currentPosition = 0;
        _isPlaying = false;
      });
    } catch (e) {
      print("Error stopping player: $e");
    }
  }

  String _formatDuration(int milliseconds) {
    final seconds = milliseconds ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6A1B9A),
            Color(0xFF4A148C),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isInitialized)
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width - 48, 40),
              playerController: _playerController,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Colors.white30,
                liveWaveColor: Colors.white,
                seekLineColor: Color(0xFFE1BEE7),
                seekLineThickness: 2,
              ),
              enableSeekGesture: true,
            )
          else
            const SizedBox(
                height: 40, child: Center(child: CircularProgressIndicator())),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white, size: 32),
                    onPressed: _togglePlayPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.white, size: 32),
                    onPressed: _stopPlayer,
                  ),
                ],
              ),
              Text(
                _formatDuration(_totalDuration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
