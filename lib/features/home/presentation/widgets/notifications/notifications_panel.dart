import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_colors.dart';

class NotificationItemData {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final bool unread;
  const NotificationItemData({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    this.unread = true,
  });
}

final mockNotifications = <NotificationItemData>[
  NotificationItemData(
    id: 'n1',
    title: 'Lịch học hôm nay',
    body: 'Bạn có 1 buổi “Flutter Cơ bản” lúc 19:00.',
    time: DateTime.now().subtract(const Duration(minutes: 8)),
  ),
  NotificationItemData(
    id: 'n2',
    title: 'Hoàn thành 70% khoá học',
    body: 'Sắp chạm mốc tiếp theo rồi, cố lên nào!',
    time: DateTime.now().subtract(const Duration(hours: 1, minutes: 12)),
    unread: false,
  ),
  NotificationItemData(
    id: 'n3',
    title: 'Quiz mới mở khoá',
    body: 'Làm quiz ôn nhanh 5 câu để giữ streak.',
    time: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  NotificationItemData(
    id: 'n4',
    title: 'Sự kiện UI/UX tối mai',
    body: 'Đăng ký sớm để giữ chỗ tham gia livestream.',
    time: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
  ),
];

class NotificationsPanel extends StatelessWidget {
  final Animation<double> animation; // 0 -> 1
  final VoidCallback? onClose;
  final List<NotificationItemData> items;
  const NotificationsPanel({
    super.key,
    required this.animation,
    required this.items,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width * 0.85; // panel width

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final dx = -width * (1 - Curves.easeOut.transform(animation.value));
        return Positioned(
          top: 0,
            bottom: 0,
          left: dx,
          child: IgnorePointer(
            ignoring: animation.value < .01,
            child: SizedBox(
              width: width,
              child: Material(
                color: Colors.white,
                elevation: 12,
                shadowColor: Colors.black.withOpacity(.25),
                child: SafeArea(
                  child: Column(
                    children: [
                      _Header(onClose: onClose, unread: items.where((e) => e.unread).length),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
                          itemBuilder: (context, i) {
                            final item = items[i];
                            return _NotificationTile(item: item);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final int unread;
  final VoidCallback? onClose;
  const _Header({required this.unread, this.onClose});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: AppColors.primary, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Thông báo',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unread mới',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
              child: const Icon(Icons.close, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItemData item;
  const _NotificationTile({required this.item});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.unread ? AppColors.primary.withOpacity(.12) : Colors.grey.shade200,
              ),
              child: Center(
                child: Text(
                  item.title.characters.first.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: item.unread ? AppColors.primary : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: item.unread ? FontWeight.w700 : FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _timeAgo(item.time),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      height: 1.25,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  if (item.unread) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _timeAgo(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'Vừa xong';
  if (diff.inMinutes < 60) return '${diff.inMinutes}p';
  if (diff.inHours < 24) return '${diff.inHours}g';
  return '${diff.inDays}n';
}
