import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/core/constants/app_svg_icons.dart';
import 'package:my_app/core/constants/app_tokens.dart';
import 'package:my_app/core/constants/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(
              controller: _controller,
              query: _query,
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _query.isEmpty
                    ? _Suggestions(
                        key: const ValueKey('search_suggestions_panel'),
                        onSelect: (s) {
                          setState(() {
                            _query = s;
                            _controller.text = s;
                          });
                        },
                      )
                    : _Results(
                        key: const ValueKey('search_results_list'),
                        query: _query,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Header with back + search field
class _Header extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  const _Header({
    required this.controller,
    required this.query,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(.06), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Expanded search bar now takes full width minus trailing home button
          Expanded(
            child: Hero(
              tag: 'search_bar_hero',
              flightShuttleBuilder: (context, animation, direction, fromCtx, toCtx) {
                return FadeTransition(
                  opacity: animation,
                  child: toCtx.widget,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: AppShadows.soft,
                ),
                child: Row(
                  children: [
                    const SvgIcon(AppSvgIcons.search, size: 20, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        key: const ValueKey('search_field'),
                        controller: controller,
                        onChanged: onChanged,
                        autofocus: true,
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm khoá học, sự kiện...',
                          hintStyle: TextStyle(fontSize: 13, color: Colors.black45),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.only(bottom: 0),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: query.isNotEmpty ? 1 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: GestureDetector(
                        onTap: () {
                          controller.clear();
                          onChanged('');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          child: const Icon(Icons.close, size: 16, color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                context.go('/home');
              },
              child: Ink(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black.withOpacity(.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: const Center(
                  child: SvgIcon(
                    AppSvgIcons.home,
                    size: 19,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const _Suggestions({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Flutter căn bản',
      'Kotlin nâng cao',
      'Data Science',
      'UI/UX',
      'Web Fullstack',
      'AI cơ bản',
      'Dart tips',
      'Design System',
    ];
    // Only show popular suggestions now (recent searches removed as per request)
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  'Gợi ý phổ biến',
                  style: GoogleFonts.lato(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: suggestions
                  .map((s) => _Chip(label: s, onTap: () => onSelect(s)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  final String query;
  const _Results({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final results = List.generate(8, (i) => '$query kết quả #${i + 1}');
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 350),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _ResultCard(title: item, subtitle: 'Mô tả ngắn gọn cho $item'),
        );
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ResultCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: Colors.black.withOpacity(.05)),
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.10),
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: const Icon(
                Icons.play_circle_fill,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_outward, size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black.withOpacity(.06)),
          boxShadow: AppShadows.soft,
        ),
        child: Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
