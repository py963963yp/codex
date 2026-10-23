import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/src/app.dart';
import 'package:focus_flow/src/session_store.dart';

void main() {
  testWidgets('shows the timer and saved session count', (tester) async {
    await tester.pumpWidget(
      FocusFlowApp(store: MemorySessionStore(3)),
    );
    await tester.pump();

    expect(find.text('Focus Flow'), findsOneWidget);
    expect(find.text('25:00'), findsOneWidget);
    expect(find.text('已完成 3 次'), findsOneWidget);
    expect(find.text('开始'), findsOneWidget);
  });

  testWidgets('start and pause controls update the primary action',
      (tester) async {
    await tester.pumpWidget(
      FocusFlowApp(store: MemorySessionStore()),
    );
    await tester.pump();

    await tester.tap(find.text('开始'));
    await tester.pump();
    expect(find.text('暂停'), findsOneWidget);

    await tester.tap(find.text('暂停'));
    await tester.pump();
    expect(find.text('开始'), findsOneWidget);
  });
}
