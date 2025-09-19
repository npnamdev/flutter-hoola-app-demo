import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/core/models/course.dart';
import 'package:my_app/core/constants/app_tokens.dart';
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
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: _CourseImage(url: course.imageUrl),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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

class _CourseImage extends StatefulWidget {
  final String url;
  const _CourseImage({required this.url});

  @override
  State<_CourseImage> createState() => _CourseImageState();
}

class _CourseImageState extends State<_CourseImage> {
  bool _loaded = false;
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    if (_error || widget.url.isEmpty) {
      return Container(
        color: Colors.grey[200],
        alignment: Alignment.center,
        child: Icon(Icons.broken_image, color: Colors.grey[500], size: 30),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedOpacity(
          opacity: _loaded ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: Image.network(
            widget.url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const SizedBox.shrink();
            },
            errorBuilder: (c, o, s) {
              setState(() => _error = true);
              return const SizedBox.shrink();
            },
            frameBuilder: (context, child, frame, wasSync) {
              if (frame != null && !_loaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _loaded = true);
                });
              }
              return child;
            },
          ),
        ),
        if (!_loaded)
          _ImagePlaceholder(),
      ],
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade100,
          ],
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF3927D6)),
            backgroundColor: Colors.white,
          ),
        ),
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
