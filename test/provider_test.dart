import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/core/providers/course_providers.dart';

void main() {
  test('myCoursesProvider returns data', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final result = await container.read(myCoursesProvider.future);
    expect(result.isNotEmpty, true);
  });
}
