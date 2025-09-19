import 'package:flutter/material.dart';
import 'package:my_app/core/constants/app_colors.dart';
import 'package:my_app/core/constants/app_tokens.dart';
import 'dart:collection';

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
  NotificationItemData(
    id: 'n5',
    title: 'Nhắc học từ vựng',
    body: 'Đã 2 ngày chưa ôn lại flashcards của bạn.',
    time: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
    unread: false,
  ),
  NotificationItemData(
    id: 'n6',
    title: 'Khoá “Dart Patterns” giảm 30%',
    body: 'Ưu đãi hết hạn trong 12 giờ nữa.',
    time: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
  ),
  NotificationItemData(
    id: 'n7',
    title: 'Bạn đạt streak 5 ngày',
    body: 'Giữ nhịp học tốt lắm, tiếp tục nhé!',
    time: DateTime.now().subtract(const Duration(days: 2, hours: 10)),
    unread: false,
  ),
  NotificationItemData(
    id: 'n8',
    title: 'Cập nhật nội dung mới',
    body: 'Phần “Animations nâng cao” vừa thêm 2 bài học.',
    time: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
  ),
  NotificationItemData(
    id: 'n9',
    title: 'Nhắc ôn quiz',
    body: 'Bạn chưa hoàn thành quiz tuần này.',
    time: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
  ),
  NotificationItemData(
    id: 'n10',
    title: 'Báo cáo tuần đã sẵn sàng',
    body: 'Xem lại tiến bộ và thời gian học của bạn.',
    time: DateTime.now().subtract(const Duration(days: 4, hours: 2)),
    unread: false,
  ),
  NotificationItemData(
    id: 'n11',
    title: 'Góp ý từ giảng viên',
    body: 'Bài tập tuần trước của bạn đã được nhận xét.',
    time: DateTime.now().subtract(const Duration(days: 5, hours: 3)),
  ),
  NotificationItemData(
    id: 'n12',
    title: 'Nhắc bảo mật tài khoản',
    body: 'Kích hoạt bảo mật 2 lớp để bảo vệ tài khoản.',
    time: DateTime.now().subtract(const Duration(days: 6, hours: 5)),
    unread: false,
  ),
];

class NotificationsPanel extends StatefulWidget {
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
  State<NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<NotificationsPanel> {
  late List<NotificationItemData> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items)..sort((a,b)=> b.time.compareTo(a.time));
  }

  void _markRead(String id) {
    setState(() {
      final idx = _items.indexWhere((e) => e.id == id);
      if (idx != -1) {
        final it = _items[idx];
        _items[idx] = NotificationItemData(
          id: it.id,
            title: it.title,
          body: it.body,
          time: it.time,
          unread: false,
        );
      }
    });
  }

  void _dismiss(String id) {
    setState(() => _items.removeWhere((e) => e.id == id));
  }

  Map<String, List<NotificationItemData>> _grouped() {
    final map = LinkedHashMap<String, List<NotificationItemData>>();
    for (final n in _items) {
      final key = _sectionLabel(n.time);
      map.putIfAbsent(key, () => []).add(n);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width * 0.88; // panel width a bit wider

    final grouped = _grouped();
    final unreadCount = _items.where((e) => e.unread).length;

    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, _) {
        final dx = -width * (1 - Curves.easeOut.transform(widget.animation.value));
        return Positioned(
          top: 0,
          bottom: 0,
          left: dx,
          child: IgnorePointer(
            ignoring: widget.animation.value < .01,
            child: SizedBox(
              width: width,
              child: Material(
                color: AppColors.backgroundAlt,
                elevation: 10,
                shadowColor: Colors.black.withOpacity(.20),
                child: SafeArea(
                  child: Column(
                    children: [
                      _Header(onClose: widget.onClose, unread: unreadCount),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                          itemCount: grouped.length,
                          itemBuilder: (context, index) {
                            final sectionTitle = grouped.keys.elementAt(index);
                            final sectionItems = grouped[sectionTitle]!;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 28),
                              child: _SectionGroup(
                                title: sectionTitle,
                                children: [
                                  for (final item in sectionItems)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: Dismissible(
                                        key: ValueKey(item.id),
                                        background: _dismissBg(alignRight: false),
                                        secondaryBackground: _dismissBg(alignRight: true),
                                        onDismissed: (_) => _dismiss(item.id),
                                        child: NotificationCard(
                                          item: item,
                                          onTap: () => _markRead(item.id),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
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

  Widget _dismissBg({required bool alignRight}) {
    return Container(
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(.08),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Icon(Icons.delete, color: AppColors.danger.withOpacity(.8)),
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
                borderRadius: BorderRadius.circular(AppRadii.lg),
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
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
                boxShadow: AppShadows.card,
              ),
              child: const Icon(Icons.close, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItemData item;
  final VoidCallback? onTap;
  const NotificationCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = item.unread ? Colors.white : Colors.white.withOpacity(.92);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: item.unread
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(.10),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
                ...AppShadows.card,
              ]
            : AppShadows.card,
        border: Border.all(
          color: item.unread
              ? AppColors.primary.withOpacity(.18)
              : Colors.grey.withOpacity(.15),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _LeadingIcon(item: item),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: 14.5,
                              fontWeight: item.unread ? FontWeight.w700 : FontWeight.w600,
                              height: 1.15,
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
                        fontWeight: item.unread ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                    if (item.unread) ...[
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Chưa đọc',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _LeadingIcon extends StatelessWidget {
  final NotificationItemData item;
  const _LeadingIcon({required this.item});
  @override
  Widget build(BuildContext context) {
    final bg = item.unread ? AppColors.primary.withOpacity(.12) : Colors.grey.shade100;
    final color = item.unread ? AppColors.primary : Colors.grey.shade600;
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Center(
        child: Text(
          item.title.characters.first.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _SectionGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionGroup({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: .3,
              color: AppColors.neutralDark,
            ),
          ),
        ),
        ...children,
      ],
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

String _sectionLabel(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(time.year, time.month, time.day);
  if (date == today) return 'Hôm nay';
  if (date == today.subtract(const Duration(days: 1))) return 'Hôm qua';
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
}
