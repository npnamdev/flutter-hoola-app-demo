import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/models/course.dart';
import 'package:my_app/core/repositories/course_repository.dart';

final courseRepositoryProvider = Provider<ICourseRepository>((ref) {
  return const CourseRepository();
});

final myCoursesProvider = FutureProvider<List<Course>>((ref) async {
  final repo = ref.watch(courseRepositoryProvider);
  return repo.fetchMyCourses();
});
