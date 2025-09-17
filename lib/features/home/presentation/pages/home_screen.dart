import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:my_app/widgets/course_list.dart';
import 'package:my_app/widgets/event_card.dart';
import 'package:my_app/widgets/banner_header.dart';
import 'package:my_app/shared/widgets/section_header.dart';
import 'package:my_app/core/constants/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const BannerHeader(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/150?img=12',
                              ),
                            ),
                            SizedBox(width: 12),
                            _WelcomeUser(),
                          ],
                        ),
                        AppSpacing.h20,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                LucideIcons.search,
                                color: Color.fromARGB(255, 154, 150, 150),
                                size: 25,
                              ),
                              SizedBox(width: 8),
                              Expanded(child: _SearchInput()),
                              _FilterButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.h22,
            const SectionHeader(
              title: 'Khoá học của tôi',
              actionLabel: 'Xem tất cả',
            ),
            AppSpacing.h12,
            const CourseList(),
            AppSpacing.h16,
            const SectionHeader(title: 'Sự kiện sắp diễn ra'),
            AppSpacing.h8,
            const EventCardList(),
            AppSpacing.h16,
            const SectionHeader(title: 'Sự kiện sắp diễn ra'),
            AppSpacing.h8,
            const EventCardList(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeUser extends StatelessWidget {
  const _WelcomeUser();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Chào mừng trở lại,',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1),
        Text(
          'Nguyễn Phương Nam',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput();
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 15),
      decoration: const InputDecoration(
        hintText: 'Tìm kiếm khoá học...',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
        border: InputBorder.none,
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF3927D6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Iconsax.filter,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
