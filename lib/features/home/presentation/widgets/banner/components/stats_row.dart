import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsRow extends StatelessWidget {
  final int total;
  final int completed;
  final int inProgress;
  final double progress;
  final bool lightMode;
  const StatsRow({
    super.key,
    required this.total,
    required this.completed,
    required this.inProgress,
    required this.progress,
    this.lightMode = true,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (progress.clamp(0, 1) * 100).toStringAsFixed(0);
    final textColorSecondary = lightMode ? Colors.grey[700] : Colors.white70;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _StatChip(label: 'Tổng', value: total.toString(), lightMode: lightMode),
            const SizedBox(width: 8),
            _StatChip(label: 'Hoàn thành', value: completed.toString(), lightMode: lightMode),
            const SizedBox(width: 8),
            _StatChip(label: 'Đang học', value: inProgress.toString(), lightMode: lightMode),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: progress.clamp(0, 1),
            backgroundColor: lightMode ? Colors.grey.shade300 : Colors.white24,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF3927D6)),
          ),
        ),
        const SizedBox(height: 6),
        Text('Tiến độ: $pct%',
            style: GoogleFonts.lato(
              color: textColorSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final bool lightMode;
  const _StatChip({required this.label, required this.value, required this.lightMode});
  @override
  Widget build(BuildContext context) {
    final bg = lightMode ? Colors.grey.shade200 : Colors.white.withOpacity(.18);
    final border = lightMode ? Colors.grey.shade300 : Colors.white24;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.lato(
              color: lightMode ? Colors.grey[600] : Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              color: lightMode ? Colors.black87 : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
