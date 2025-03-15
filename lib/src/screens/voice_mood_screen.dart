import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:mood_ai/src/services/gemini_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class VoiceMoodScreen extends StatefulWidget {
  const VoiceMoodScreen({super.key});

  @override
  State<VoiceMoodScreen> createState() => _VoiceMoodScreenState();
}

class _VoiceMoodScreenState extends State<VoiceMoodScreen>
    with SingleTickerProviderStateMixin {
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isAnalyzing = false;
  Timer? _timer;
  int _recordingDuration = 0;
  final int _maxDuration = 30; // Maximum recording duration in seconds
  List<double> _audioLevels = [];
  late AnimationController _animationController;
  final _geminiService = GeminiService();
  StreamSubscription<RecordState>? _recordSub;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        print('Debug: Microphone permission not granted');
        return;
      }

      // Initialize record state subscription
      _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
        setState(() {
          _isRecording = recordState == RecordState.record;
        });
      });
    } catch (e) {
      print('Debug: Failed to initialize recorder: $e');
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        if (_isRecording) return;

        final tempDir = await getTemporaryDirectory();
        final audioPath = '${tempDir.path}/mood_recording.aac';

        // Configure recording with proper settings
        await _audioRecorder.start(
          RecordConfig(
            encoder: AudioEncoder.aacLc,
            sampleRate: 44100,
            bitRate: 128000,
            numChannels: 1,
          ),
          path: audioPath,
        );

        // Setup amplitude monitoring after recording starts
        _amplitudeSub?.cancel(); // Cancel any existing subscription
        _amplitudeSub = _audioRecorder
            .onAmplitudeChanged(const Duration(milliseconds: 50))
            .listen((amp) {
          if (!mounted) return;

          final dB = amp.current ?? -120.0;
          // Adjust normalization for better visualization
          // Using a non-linear scale that gives more weight to lower volumes
          final normalized =
              (pow((dB + 120) / 120, 2) as double).clamp(0.0, 1.0);

          print('Debug: Audio level - dB: $dB, Normalized: $normalized');

          setState(() {
            _amplitude = amp;
            _audioLevels.add(normalized);
            if (_audioLevels.length > 100) {
              _audioLevels.removeAt(0);
            }
          });
        });

        _startTimer();
        setState(() {
          _isRecording = true;
          _audioLevels = [];
        });
      }
    } catch (e) {
      print('Debug: Recording error: $e');
      setState(() => _isRecording = false);
    }
  }

  Future<void> _stopRecording() async {
    try {
      _amplitudeSub?.cancel();
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });
      _timer?.cancel();

      if (path != null) {
        await _analyzeAudio(path);
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isAnalyzing = false;
      });
      print('Debug: Stop recording error: $e');
    }
  }

  void _startTimer() {
    _recordingDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_recordingDuration >= _maxDuration) {
          _stopRecording();
        } else {
          _recordingDuration++;
        }
      });
    });
  }

  String _formatDuration() {
    final remainingTime = _maxDuration - _recordingDuration;
    final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _analyzeAudio(String audioPath) async {
    setState(() => _isAnalyzing = true);
    try {
      final file = File(audioPath);
      if (!await file.exists()) {
        throw Exception('Audio file not found at path: $audioPath');
      }

      if (_recordingDuration < 3) {
        throw Exception(
            'Recording too short. Please record for at least 3 seconds.');
      }

      final result = await _geminiService.analyzeVoiceMood(audioPath);

      if (mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _isRecording = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Recording Error'),
            content: Text(
              e.toString().contains('too short')
                  ? 'Please record for at least 3 seconds to analyze your mood.'
                  : 'Failed to analyze recording. Please try again.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  if (!e.toString().contains('too short')) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isAnalyzing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF6448FE),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Analyzing your mood...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  _isRecording ? 'Recording...' : 'Tap to start recording',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 200,
                  child: _isRecording
                      ? CustomPaint(
                          size: const Size(double.infinity, 200),
                          painter: AudioWavePainter(
                            waveData: _audioLevels,
                            color: const Color(0xFF6448FE),
                          ),
                        )
                      : AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(double.infinity, 200),
                              painter: PulsePainter(
                                progress: _animationController.value,
                                color: const Color(0xFF6448FE),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 48),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatDuration(),
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Minimum 3 seconds',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _isRecording ? _stopRecording : _startRecording,
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 48),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _isRecording ? Colors.red : const Color(0xFF6448FE),
                      boxShadow: [
                        BoxShadow(
                          color: (_isRecording
                                  ? Colors.red
                                  : const Color(0xFF6448FE))
                              .withOpacity(0.3),
                          spreadRadius: 4,
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class AudioWavePainter extends CustomPainter {
  final List<double> waveData;
  final Color color;

  AudioWavePainter({required this.waveData, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (waveData.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 3;
    final angleStep = 2 * pi / waveData.length;

    final path = Path();
    final outerPath = Path();

    for (var i = 0; i < waveData.length; i++) {
      final amplitude =
          waveData[i] * 50; // Adjust this multiplier to control wave height
      final angle = i * angleStep;

      final x = center.dx + (radius + amplitude) * cos(angle);
      final y = center.dy + (radius + amplitude) * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
        outerPath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        outerPath.lineTo(x, y);
      }
    }

    // Close the paths
    path.close();
    outerPath.close();

    // Draw outer glow
    final outerPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    canvas.drawPath(outerPath, outerPaint);

    // Draw main line
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(AudioWavePainter oldDelegate) => true;
}

class PulsePainter extends CustomPainter {
  final double progress;
  final Color color;

  PulsePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 3;

    // Draw multiple rings with different opacities and sizes
    for (int i = 0; i < 3; i++) {
      final ringProgress = (progress + (i * 0.3)) % 1.0;
      final paint = Paint()
        ..color = color.withOpacity((1 - ringProgress) * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5);

      // Draw the main ring
      canvas.drawCircle(center, maxRadius * ringProgress, paint);

      // Draw inner glow
      final innerGlowPaint = Paint()
        ..color = color.withOpacity((1 - ringProgress) * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
          center, maxRadius * ringProgress * 0.95, innerGlowPaint);
    }

    // Draw static center circle
    final centerPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);

    canvas.drawCircle(center, maxRadius * 0.3, centerPaint);
  }

  @override
  bool shouldRepaint(PulsePainter oldDelegate) => true;
}
