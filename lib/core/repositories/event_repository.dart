import 'dart:async';
import 'package:my_app/core/models/event.dart';
import 'package:my_app/core/mock/mock_events.dart';

abstract class IEventRepository {
  Future<List<EventItem>> fetchUpcomingEvents();
}

class EventRepository implements IEventRepository {
  const EventRepository();

  @override
  Future<List<EventItem>> fetchUpcomingEvents() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return mockEvents;
  }
}
