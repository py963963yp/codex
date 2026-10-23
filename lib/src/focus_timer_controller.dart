import 'dart:async';

import 'package:flutter/foundation.dart';

import 'session_store.dart';

enum TimerMode { focus, rest }

@immutable
class TimerPreset {
  const TimerPreset({
    required this.label,
    required this.mode,
    required this.duration,
  });

  final String label;
  final TimerMode mode;
  final Duration duration;
}

class FocusTimerController extends ChangeNotifier {
  FocusTimerController({
    required SessionStore store,
    Duration initialDuration = const Duration(minutes: 25),
    int initialCompletedSessions = 0,
  })  : _store = store,
        _initialDuration = initialDuration,
        _remaining = initialDuration,
        _completedSessions = initialCompletedSessions;

  static const presets = <TimerPreset>[
    TimerPreset(
      label: '专注 15',
      mode: TimerMode.focus,
      duration: Duration(minutes: 15),
    ),
    TimerPreset(
      label: '专注 25',
      mode: TimerMode.focus,
      duration: Duration(minutes: 25),
    ),
    TimerPreset(
      label: '专注 45',
      mode: TimerMode.focus,
      duration: Duration(minutes: 45),
    ),
    TimerPreset(
      label: '休息 5',
      mode: TimerMode.rest,
      duration: Duration(minutes: 5),
    ),
  ];

  final SessionStore _store;
  Timer? _ticker;

  TimerMode _mode = TimerMode.focus;
  Duration _initialDuration;
  Duration _remaining;
  bool _isRunning = false;
  int _completedSessions;

  TimerMode get mode => _mode;
  Duration get initialDuration => _initialDuration;
  Duration get remaining => _remaining;
  bool get isRunning => _isRunning;
  int get completedSessions => _completedSessions;

  double get progress {
    if (_initialDuration.inMilliseconds == 0) {
      return 0;
    }
    return (_remaining.inMilliseconds / _initialDuration.inMilliseconds)
        .clamp(0.0, 1.0)
        .toDouble();
  }

  String get formattedRemaining {
    final seconds = _remaining.inSeconds.clamp(0, 24 * 60 * 60);
    final minutesPart = seconds ~/ 60;
    final secondsPart = seconds % 60;
    return '${minutesPart.toString().padLeft(2, '0')}:'
        '${secondsPart.toString().padLeft(2, '0')}';
  }

  Future<void> initialize() async {
    _completedSessions = await _store.readCompletedSessions();
    notifyListeners();
  }

  void toggle() {
    if (_isRunning) {
      pause();
    } else {
      start();
    }
  }

  void start() {
    if (_isRunning || _remaining <= Duration.zero) {
      return;
    }
    _ticker?.cancel();
    _isRunning = true;
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => tick(const Duration(seconds: 1)),
    );
    notifyListeners();
  }

  void pause() {
    _ticker?.cancel();
    _ticker = null;
    _isRunning = false;
    notifyListeners();
  }

  void reset() {
    pause();
    _remaining = _initialDuration;
    notifyListeners();
  }

  void selectPreset(TimerPreset preset) {
    pause();
    _mode = preset.mode;
    _initialDuration = preset.duration;
    _remaining = preset.duration;
    notifyListeners();
  }

  @visibleForTesting
  void tick(Duration elapsed) {
    if (!_isRunning || elapsed <= Duration.zero) {
      return;
    }

    _remaining -= elapsed;
    if (_remaining > Duration.zero) {
      notifyListeners();
      return;
    }

    _completeSession();
  }

  void _completeSession() {
    _ticker?.cancel();
    _ticker = null;
    _isRunning = false;

    if (_mode == TimerMode.focus) {
      _completedSessions += 1;
      unawaited(_store.writeCompletedSessions(_completedSessions));
      _mode = TimerMode.rest;
      _initialDuration = const Duration(minutes: 5);
    } else {
      _mode = TimerMode.focus;
      _initialDuration = const Duration(minutes: 25);
    }

    _remaining = _initialDuration;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
