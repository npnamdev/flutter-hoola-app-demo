import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool lightMode;
  final ValueChanged<String>? onSubmitted;

  /// Total outer height of the search bar container.
  final double height;

  /// Optional leading icon override.
  final IconData leadingIcon;

  const SearchBar({
    super.key,
    required this.controller,
    required this.hint,
    this.lightMode = true,
    this.onSubmitted,
    this.height = 56,
    this.leadingIcon = LucideIcons.search,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: lightMode ? Colors.grey[100] : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: lightMode ? Colors.grey.shade300 : Colors.white24,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(leadingIcon, color: Colors.grey[600], size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: lightMode ? Colors.black87 : Colors.white,
                ),
                onSubmitted: onSubmitted,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.lato(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10), // thêm padding cho đẹp
                ),
              ),
            ),
   
          ],
        ),
      ),
    );
  }
}

// Removed unused _FilterButton widget (was not referenced anywhere)
