import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/core/models/course.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/providers/course_providers.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // đồng bộ với CourseCardPro
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              course.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) => Container(
                height: 110,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Icon(Icons.image, color: Colors.grey[500]),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12), // giống Pro
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.author,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: course.progress,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE9ECF2),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF3927D6)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseList extends ConsumerWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCourses = ref.watch(myCoursesProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 32.0;
    final cardWidth = (screenWidth - horizontalPadding) / 2.5;

    return SizedBox(
      height: 230, // điều chỉnh chiều cao phù hợp với header mới
      child: asyncCourses.when(
        data: (courses) => ListView.builder(
          scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Container(
                margin: const EdgeInsets.only(right: 14, top: 4, bottom: 10),
                width: cardWidth,
                child: CourseCard(course: course),
              );
            },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text('Lỗi tải khoá học', style: GoogleFonts.lato(fontSize: 13)),
        ),
      ),
    );
  }
}
