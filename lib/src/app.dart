import 'dart:async';

import 'package:flutter/material.dart';

import 'focus_timer_controller.dart';
import 'session_store.dart';

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({required this.store, super.key});

  final SessionStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF36D6A0),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0B1020),
      ),
      home: FocusTimerPage(store: store),
    );
  }
}

class FocusTimerPage extends StatefulWidget {
  const FocusTimerPage({required this.store, super.key});

  final SessionStore store;

  @override
  State<FocusTimerPage> createState() => _FocusTimerPageState();
}

class _FocusTimerPageState extends State<FocusTimerPage> {
  late final FocusTimerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FocusTimerController(store: widget.store);
    unawaited(_controller.initialize());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final isFocus = _controller.mode == TimerMode.focus;
        final accent =
            isFocus ? const Color(0xFF36D6A0) : const Color(0xFFFFB35C);

        return Scaffold(
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF10192D), Color(0xFF070A14)],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(completedSessions: _controller.completedSessions),
                        const SizedBox(height: 28),
                        _TimerCard(
                          controller: _controller,
                          accent: accent,
                          isFocus: isFocus,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '选择节奏',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: FocusTimerController.presets.map((preset) {
                            final selected =
                                preset.mode == _controller.mode &&
                                    preset.duration ==
                                        _controller.initialDuration;
                            return ChoiceChip(
                              label: Text(preset.label),
                              selected: selected,
                              selectedColor: accent.withAlpha(51),
                              side: BorderSide(
                                color: selected
                                    ? accent
                                    : Colors.white.withAlpha(31),
                              ),
                              onSelected: (_) =>
                                  _controller.selectPreset(preset),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: accent,
                                  foregroundColor: const Color(0xFF071019),
                                  minimumSize: const Size.fromHeight(56),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: _controller.toggle,
                                icon: Icon(
                                  _controller.isRunning
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                ),
                                label: Text(
                                  _controller.isRunning ? '暂停' : '开始',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton.outlined(
                              tooltip: '重置',
                              onPressed: _controller.reset,
                              icon: const Icon(Icons.refresh_rounded),
                              style: IconButton.styleFrom(
                                minimumSize: const Size(56, 56),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isFocus
                              ? '一次只做一件事。完成专注后会自动切换到 5 分钟休息。'
                              : '离开屏幕，喝水或伸展。休息结束后回到 25 分钟专注。',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withAlpha(158),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.completedSessions});

  final int completedSessions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0x2436D6A0),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.center_focus_strong_rounded,
            color: Color(0xFF36D6A0),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Focus Flow',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              Text(
                '专注计时器',
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '已完成 $completedSessions 次',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _TimerCard extends StatelessWidget {
  const _TimerCard({
    required this.controller,
    required this.accent,
    required this.isFocus,
  });

  final FocusTimerController controller;
  final Color accent;
  final bool isFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(14),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withAlpha(20)),
        boxShadow: [
          BoxShadow(
            color: accent.withAlpha(20),
            blurRadius: 32,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = (constraints.maxWidth - 12).clamp(220.0, 300.0).toDouble();
          return Column(
            children: [
              SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: controller.progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.white.withAlpha(20),
                        color: accent,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isFocus ? '专注时间' : '休息时间',
                          style: TextStyle(
                            color: accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.formattedRemaining,
                          style: const TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                controller.isRunning ? '保持专注，计时进行中' : '准备好后开始这一轮',
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          );
        },
      ),
    );
  }
}
