import 'package:flutter/material.dart';

/// Central shadow tokens to ensure consistency across widgets.
/// Use the smallest shadow necessary; avoid ad-hoc BoxShadow duplication.
class AppShadows {
  AppShadows._();

  static const BoxShadow xs = BoxShadow(
    color: Color(0x0F000000), // 6% black
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const BoxShadow sm = BoxShadow(
    color: Color(0x14000000), // 8% black
    blurRadius: 8,
    offset: Offset(0, 3),
  );

  static const BoxShadow md = BoxShadow(
    color: Color(0x1A000000), // 10% black
    blurRadius: 14,
    offset: Offset(0, 6),
  );

  static const BoxShadow lg = BoxShadow(
    color: Color(0x1F000000), // 12% black
    blurRadius: 24,
    offset: Offset(0, 10),
  );

  static const List<BoxShadow> card = [sm];
  static const List<BoxShadow> popover = [md];
  static const List<BoxShadow> elevated = [lg];
  static const List<BoxShadow> subtle = [xs];

  /// Utility to combine multiple layers if ever needed.
  static List<BoxShadow> compose(List<BoxShadow> a, List<BoxShadow> b) => [...a, ...b];
}
