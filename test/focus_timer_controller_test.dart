import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/src/focus_timer_controller.dart';
import 'package:focus_flow/src/session_store.dart';

void main() {
  group('FocusTimerController', () {
    test('formats the remaining duration as minutes and seconds', () {
      final controller = FocusTimerController(
        store: MemorySessionStore(),
        initialDuration: const Duration(minutes: 2, seconds: 5),
      );
      addTearDown(controller.dispose);

      expect(controller.formattedRemaining, '02:05');
    });

    test('loads the saved completed-session count', () async {
      final controller = FocusTimerController(
        store: MemorySessionStore(7),
      );
      addTearDown(controller.dispose);

      await controller.initialize();

      expect(controller.completedSessions, 7);
    });

    test('completes a focus session, persists it, and switches to rest', () async {
      final store = MemorySessionStore();
      final controller = FocusTimerController(
        store: store,
        initialDuration: const Duration(seconds: 2),
      );
      addTearDown(controller.dispose);

      controller.start();
      controller.tick(const Duration(seconds: 2));
      await Future<void>.delayed(Duration.zero);

      expect(controller.completedSessions, 1);
      expect(store.count, 1);
      expect(controller.mode, TimerMode.rest);
      expect(controller.isRunning, isFalse);
      expect(controller.formattedRemaining, '05:00');
    });

    test('pauses and reset restores the selected duration', () {
      final controller = FocusTimerController(
        store: MemorySessionStore(),
        initialDuration: const Duration(minutes: 25),
      );
      addTearDown(controller.dispose);

      controller.start();
      controller.tick(const Duration(minutes: 2));
      controller.reset();

      expect(controller.isRunning, isFalse);
      expect(controller.formattedRemaining, '25:00');
    });

    test('selecting a break preset pauses and updates the timer', () {
      final controller = FocusTimerController(store: MemorySessionStore());
      addTearDown(controller.dispose);

      controller.start();
      controller.selectPreset(FocusTimerController.presets.last);

      expect(controller.mode, TimerMode.rest);
      expect(controller.isRunning, isFalse);
      expect(controller.formattedRemaining, '05:00');
    });
  });
}
