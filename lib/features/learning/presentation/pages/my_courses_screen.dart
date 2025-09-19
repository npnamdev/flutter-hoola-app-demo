import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart'; // still used elsewhere
import 'package:my_app/core/constants/app_svg_icons.dart';
import 'package:my_app/core/providers/course_providers.dart';
import 'package:my_app/core/models/course.dart';

enum CourseFilter { all, inProgress, completed, notStarted }

final courseFilterProvider = StateProvider<CourseFilter>(
  (ref) => CourseFilter.all,
);
final searchQueryProvider = StateProvider<String>((ref) => '');

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(myCoursesProvider);
    final filter = ref.watch(courseFilterProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SearchBar(
                onChanged: (v) =>
                    ref.read(searchQueryProvider.notifier).state = v.trim(),
              ),
            ),
            const SizedBox(height: 10),
            _FilterChips(
              current: filter,
              onSelect: (f) =>
                  ref.read(courseFilterProvider.notifier).state = f,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: coursesAsync.when(
                data: (list) {
                  List<Course> filtered = list;
                  if (query.isNotEmpty) {
                    filtered = filtered
                        .where(
                          (c) => c.title.toLowerCase().contains(
                            query.toLowerCase(),
                          ),
                        )
                        .toList();
                  }
                  filtered = filtered.where((c) {
                    switch (filter) {
                      case CourseFilter.all:
                        return true;
                      case CourseFilter.inProgress:
                        return c.progress > 0 && c.progress < 1.0;
                      case CourseFilter.completed:
                        return c.progress >= 1.0;
                      case CourseFilter.notStarted:
                        return c.progress == 0;
                    }
                  }).toList();

                  if (filtered.isEmpty) {
                    return const _EmptyState();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 14,
                            childAspectRatio: .74,
                          ),
                      itemBuilder: (context, index) =>
                          CourseCardPro(course: filtered[index]),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(
                  child: Text(
                    'Lỗi tải khoá học',
                    style: GoogleFonts.lato(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  const _StatPill({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 60, // taller input per request
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const SvgIcon(AppSvgIcons.search, size: 22, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (v) {
                setState(() {}); // rebuild for clear icon visibility
                widget.onChanged(v);
              },
              style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm khoá học...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.black45),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 2),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: controller.text.isNotEmpty ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: GestureDetector(
              onTap: () {
                controller.clear();
                widget.onChanged('');
                setState(() {});
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
    );
  }
}

class _FilterChips extends StatelessWidget {
  final CourseFilter current;
  final ValueChanged<CourseFilter> onSelect;
  const _FilterChips({required this.current, required this.onSelect});
  @override
  Widget build(BuildContext context) {
    final items = const [
      CourseFilter.all,
      CourseFilter.inProgress,
      CourseFilter.completed,
      CourseFilter.notStarted,
    ];
    String label(CourseFilter f) {
      switch (f) {
        case CourseFilter.all:
          return 'Tất cả';
        case CourseFilter.inProgress:
          return 'Đang học';
        case CourseFilter.completed:
          return 'Hoàn thành';
        case CourseFilter.notStarted:
          return 'Chưa học';
      }
    }

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          final f = items[index];
          final selected = f == current;
          return GestureDetector(
            onTap: () => onSelect(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF3927D6) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF3927D6)
                      : Colors.grey.shade300,
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: const Color(0xFF3927D6).withOpacity(.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  label(f),
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: items.length,
      ),
    );
  }
}

class CourseCardPro extends StatelessWidget {
  final Course course;
  const CourseCardPro({super.key, required this.course});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Image.network(
                    course.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      course.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: course.progress,
                        minHeight: 10,
                        backgroundColor: const Color(0xFFE9ECF2),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF3927D6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      course.progress >= 1.0
                          ? 'Đã hoàn thành'
                          : 'Hoàn thành ${(course.progress * 100).round()}%',
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Iconsax.book, size: 42, color: Color(0xFF3927D6)),
          ),
          const SizedBox(height: 24),
          Text(
            'Không có khoá học',
            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Thử đổi bộ lọc hoặc tìm kiếm khác',
            style: GoogleFonts.lato(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
