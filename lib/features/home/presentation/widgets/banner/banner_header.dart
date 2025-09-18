// New modular BannerHeader (migrated from lib/widgets/banner_header.dart)
// NOTE: The old file will export this one for backward compatibility.

import 'package:flutter/material.dart';
import 'components/top_bar.dart';
import 'components/stats_row.dart';

class BannerHeader extends StatefulWidget {
  final String userName;
  final String avatarUrl;
  final double height;
  final bool showStats;
  final int? totalCourses;
  final int? completedCourses;
  final int? inProgressCourses;
  final double? progressPercent; // 0..1
  final VoidCallback? onNotification;
  final VoidCallback? onSettings;
  final bool lightMode;

  const BannerHeader({
    super.key,
    this.userName = 'Phương Nam',
    this.avatarUrl = 'https://i.pravatar.cc/150?img=12',
    this.height = 140,
    this.showStats = false,
    this.totalCourses,
    this.completedCourses,
    this.inProgressCourses,
    this.progressPercent,
    this.onNotification,
    this.onSettings,
    this.lightMode = true,
  });

  @override
  State<BannerHeader> createState() => _BannerHeaderState();
}

class _BannerHeaderState extends State<BannerHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Container(
          color: widget.lightMode ? Colors.white : theme.colorScheme.surface,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopBar(
                    avatarUrl: widget.avatarUrl,
                    userName: widget.userName,
                    onNotification: widget.onNotification,
                    onSettings: widget.onSettings,
                    onSearch: () {},
                    showSearchIcon: true,
                    lightMode: widget.lightMode,
                  ),
                  const SizedBox(height: 8),
                  if (widget.showStats && widget.totalCourses != null)
                    StatsRow(
                      total: widget.totalCourses!,
                      completed: widget.completedCourses ?? 0,
                      inProgress: widget.inProgressCourses ?? 0,
                      progress: widget.progressPercent ?? 0,
                      lightMode: widget.lightMode,
                    ),
                  if (widget.showStats) const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
