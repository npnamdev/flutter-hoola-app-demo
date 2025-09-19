import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/features/home/presentation/widgets/notifications/notifications_panel.dart';

// Simple provider computing unread count from mockNotifications.
// Later you can replace with repository / API source.
final unreadNotificationsCountProvider = Provider<int>((ref) {
  // If you later persist notifications in state, expose them via another provider.
  return mockNotifications.where((n) => n.unread).length;
});
