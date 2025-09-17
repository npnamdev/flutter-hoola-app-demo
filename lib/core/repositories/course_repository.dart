import 'dart:async';
import 'package:my_app/core/models/course.dart';
import 'package:my_app/core/mock/mock_courses.dart';

/// Abstraction for fetching courses (later can point to API or database)
abstract class ICourseRepository {
  Future<List<Course>> fetchMyCourses();
}

class CourseRepository implements ICourseRepository {
  const CourseRepository();

  @override
  Future<List<Course>> fetchMyCourses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockCourses;
  }
}
