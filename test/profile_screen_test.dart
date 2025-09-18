import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/features/profile/presentation/pages/profile_screen.dart';

void main() {
  testWidgets('Profile screen renders key sections', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: ProfileScreen())));

    // Allow layout
    await tester.pumpAndSettle();

  // Removed title bar, so no 'Hồ sơ' text expected anymore.
    expect(find.text('Tiến độ học tập'), findsOneWidget);
    expect(find.text('Giới thiệu'), findsOneWidget);
    expect(find.text('TÀI KHOẢN'), findsOneWidget); // header uppercased
    expect(find.text('ỨNG DỤNG'), findsOneWidget);
    expect(find.text('HỖ TRỢ'), findsOneWidget);
    expect(find.text('Đăng xuất'), findsWidgets);
  });
}
