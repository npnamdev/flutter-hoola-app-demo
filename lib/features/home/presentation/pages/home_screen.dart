import 'package:flutter/material.dart';
import 'package:my_app/widgets/course_list.dart';
import 'package:my_app/widgets/event_card.dart';
import 'package:my_app/features/home/presentation/widgets/banner/components/top_bar.dart';
import 'package:my_app/shared/widgets/section_header.dart';
import 'package:my_app/core/constants/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 78,
            collapsedHeight: 78,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final t = ((constraints.maxHeight - kToolbarHeight) / (120 - kToolbarHeight)).clamp(0.0, 1.0);
                final avatarScale = 0.85 + (0.15 * t); // scale avatar a bit when expanded
                return SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22 - (8 * (1 - t)),
                      vertical: 12 - (6 * (1 - t)),
                    ),
                    child: Transform.scale(
                      alignment: Alignment.centerLeft,
                      scale: avatarScale,
                      child: TopBar(
                        avatarUrl: 'https://i.pravatar.cc/150?img=12',
                        userName: 'Phương Nam',
                        lightMode: true,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: AppSpacing.h20),
          SliverToBoxAdapter(
            child: const SectionHeader(
              title: 'Khoá học của tôi',
              actionLabel: 'Xem tất cả',
            ),
          ),
            SliverToBoxAdapter(child: AppSpacing.h12),
          SliverToBoxAdapter(child: const CourseList()),
          SliverToBoxAdapter(child: AppSpacing.h16),
          SliverToBoxAdapter(child: const SectionHeader(title: 'Sự kiện sắp diễn ra')),
          SliverToBoxAdapter(child: AppSpacing.h8),
          SliverToBoxAdapter(child: const EventCardList()),
          SliverToBoxAdapter(child: AppSpacing.h16),
          SliverToBoxAdapter(child: const SectionHeader(title: 'Sự kiện sắp diễn ra')),
          SliverToBoxAdapter(child: AppSpacing.h8),
          SliverToBoxAdapter(child: const EventCardList()),
          SliverToBoxAdapter(child: AppSpacing.h16),
        ],
      ),
    );
  }
}

// Removed custom sliver delegate in favor of simpler SliverAppBar.
