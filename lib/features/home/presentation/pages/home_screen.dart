import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/app/router.dart';
import 'package:my_app/widgets/course_list.dart';
import 'package:my_app/widgets/event_card.dart';
import 'package:my_app/features/home/presentation/widgets/banner/components/top_bar.dart';
import 'package:my_app/shared/widgets/section_header.dart';
import 'package:my_app/core/constants/app_spacing.dart';
import 'package:my_app/features/home/presentation/sections/welcome_section.dart';
import 'package:my_app/features/home/presentation/widgets/notifications/notifications_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  static const double _bgSwitchOffset = 8; // threshold to show background
  bool _solid = false;
  late final AnimationController _panelController;
  late final Animation<double> _panelAnim;
  bool _panelOpen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
    _panelAnim = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
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
    _panelController.dispose();
    super.dispose();
  }

  void _togglePanel() {
    setState(() {
      _panelOpen = !_panelOpen;
      if (_panelOpen) {
        _panelController.forward();
      } else {
        _panelController.reverse();
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (_panelOpen) {
      _togglePanel();
      return false; // consume back
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _solid ? Colors.white : Colors.white;
    final double elevation = _solid ? 4 : 0;
    final content = NotificationListener<OverscrollIndicatorNotification>(
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
                  final t =
                      ((constraints.maxHeight - kToolbarHeight) /
                              (120 - kToolbarHeight))
                          .clamp(0.0, 1.0);
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
                          onSearch: () {
                            if (mounted) {
                              // Sử dụng push để có thể pop quay lại màn hình home
                              context.push(AppRoutes.search);
                            }
                          },
                          onNotification: _togglePanel,
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
            title: 'Chào mừng trở lại, Nam!',
            subtitle: 'Bạn đã hoàn thành 80% mục tiêu tuần này',
            primaryLabel: 'Tiếp tục học',
            secondaryLabel: 'Xem thống kê',
            onPrimary: () {},
            onSecondary: () {},
          ),
          SliverToBoxAdapter(child: AppSpacing.h12),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Khoá học của tôi',
              actionLabel: 'Xem tất cả',
              onTap: () {
                // Navigate to My Courses screen
                // Using context.go to keep shell navigation
                // Route constant added in router
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  context.go(AppRoutes.learning);
                }
              },
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
          SliverToBoxAdapter(child: AppSpacing.h16),
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Sự kiện sắp diễn ra'),
          ),
          SliverToBoxAdapter(child: AppSpacing.h8),
          const SliverToBoxAdapter(child: EventCardList()),
          SliverToBoxAdapter(child: AppSpacing.h16),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            content,
            // Backdrop
            if (_panelOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _togglePanel,
                  child: AnimatedBuilder(
                    animation: _panelAnim,
                    builder: (context, _) => Container(
                      color: Colors.black.withOpacity(0.3 * _panelAnim.value),
                    ),
                  ),
                ),
              ),
            // Panel
            NotificationsPanel(
              animation: _panelAnim,
              items: mockNotifications,
              onClose: _togglePanel,
            ),
          ],
        ),
      ),
    );
  }
}

// Removed custom sliver delegate in favor of simpler SliverAppBar.
