import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/app/app.dart';

void main() {
  testWidgets('Tapping search icon navigates to SearchScreen', (tester) async {
    await tester.pumpWidget(const HoolaApp());

    // Allow initial routing animations
    await tester.pumpAndSettle();

    // Find search icon button (by tooltip or semantics). Our custom button does not have a key, so search by icon color/structure.
    // We'll look for an SvgPicture inside a GestureDetector; simplest is to tap the first matching gesture area with circular container.

    // More robust: find by type GestureDetector then ensure container has purple background icon? For now try by icon semantics label if provided.
    // Fallback: just search by finder for any widget with runtimeType containing 'SvgPicture' and tap its parent.

    final gestureFinders = find.byType(GestureDetector);
    expect(gestureFinders, findsWidgets);

    bool tapped = false;
    for (var element in gestureFinders.evaluate()) {
      final widget = element.widget as GestureDetector;
      if (widget.onTap != null) {
        await tester.tap(find.byWidget(widget));
        await tester.pump();
        // After tapping maybe open either search or notifications; check if SearchBar hint appears.
        if (find.text('Tìm kiếm khoá học, sự kiện...').evaluate().isNotEmpty) {
          tapped = true;
          break;
        }
      }
    }

    // settle animations if any
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(find.text('Tìm kiếm khoá học, sự kiện...'), findsOneWidget,
        reason: 'Should navigate to SearchScreen and show the search bar hint');
    expect(tapped, isTrue);
  });
}
