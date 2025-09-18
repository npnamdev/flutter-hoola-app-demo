import 'package:flutter/material.dart';
import 'package:my_app/widgets/course_list.dart';
import 'package:my_app/widgets/event_card.dart';
import 'package:my_app/features/home/presentation/widgets/banner/components/top_bar.dart';
import 'package:my_app/shared/widgets/section_header.dart';
import 'package:my_app/core/constants/app_spacing.dart';
import 'package:my_app/features/home/presentation/sections/home_section_models.dart';
import 'package:my_app/features/home/presentation/sections/continue_learning_section.dart';
import 'package:my_app/features/home/presentation/sections/recommendations_section.dart';
import 'package:my_app/features/home/presentation/sections/quick_quiz_section.dart';
import 'package:my_app/features/home/presentation/sections/welcome_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  static const double _bgSwitchOffset = 8; // threshold to show background
  bool _solid = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldBeSolid = _scrollController.offset > _bgSwitchOffset;
    if (shouldBeSolid != _solid) {
      setState(() => _solid = shouldBeSolid);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _solid ? Colors.white : Colors.white;
    final double elevation = _solid ? 4 : 0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (n) {
          n.disallowIndicator();
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 78,
              collapsedHeight: 78,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: bgColor,
                  boxShadow: elevation > 0
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final t = ((constraints.maxHeight - kToolbarHeight) / (120 - kToolbarHeight)).clamp(0.0, 1.0);
                    final avatarScale = 0.85 + (0.15 * t);
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
                            showSearchIcon: true,
                            onSearch: () {},
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: AppSpacing.h8),
            WelcomeSection(
              title: 'Chào mừng quay trở lại',
              subtitle: 'Giữ streak hôm nay  chuỗi tiến độ!',
              primaryLabel: 'Tiếp tục học',
              secondaryLabel: 'Xem thống kê',
              onPrimary: () {},
              onSecondary: () {},
            ),
            // ContinueLearningSection(
            //   items: mockContinue,
            //   onTapItem: (c) {},
            //   onSeeAll: () {},
            // ),
            // RecommendationsSection(
            //   items: mockRecommendations,
            //   onTapItem: (r) {},
            //   onSeeAll: () {},
            // ),
            // QuickQuizSection(
            //   meta: mockQuickQuiz,
            //   onStart: () {},
            //   onReview: () {},
            // ),
            SliverToBoxAdapter(child: AppSpacing.h12),
            const SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Khoá học của tôi',
                actionLabel: 'Xem tất cả',
              ),
            ),
            SliverToBoxAdapter(child: AppSpacing.h12),
            const SliverToBoxAdapter(child: CourseList()),
            SliverToBoxAdapter(child: AppSpacing.h16),
            const SliverToBoxAdapter(
              child: SectionHeader(title: 'Sự kiện sắp diễn ra'),
            ),
            SliverToBoxAdapter(child: AppSpacing.h8),
            const SliverToBoxAdapter(child: EventCardList()),
            SliverToBoxAdapter(child: AppSpacing.h16),
          ],
        ),
      ),
    );
  }
}

// Removed custom sliver delegate in favor of simpler SliverAppBar.
