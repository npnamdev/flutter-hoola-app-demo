import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/core/models/event.dart';
import 'package:my_app/core/repositories/event_repository.dart';

final eventRepositoryProvider = Provider<IEventRepository>((ref) {
  return const EventRepository();
});

final upcomingEventsProvider = FutureProvider<List<EventItem>>((ref) async {
  final repo = ref.watch(eventRepositoryProvider);
  return repo.fetchUpcomingEvents();
});
