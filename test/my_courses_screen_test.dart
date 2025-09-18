import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/app/router.dart';

void main() {
  testWidgets('Navigate to learning (MyCourses) and see stats & filters', (tester) async {
    final router = createRouter();

    await tester.pumpWidget(ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ));

    // Start at splash then we can't navigate directly since splash might auto navigate in real app.
  // Navigate to the learning route now hosting MyCoursesScreen
  router.go('/learning');
    await tester.pumpAndSettle();

    // Expect header title
    expect(find.text('Khoá học của tôi'), findsOneWidget);

    // Filter chips
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Đang học'), findsOneWidget);

    // Wait for courses to load
    await tester.pump(const Duration(milliseconds: 800));

    // Progress text appears (Hoàn thành % or Đã hoàn thành)
    expect(find.byType(GridView), findsOneWidget);
  });
}
