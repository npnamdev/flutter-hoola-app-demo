import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Hoàn thành bài học',
        'message': 'Bạn đã hoàn thành Chương 2 - Phân tích dữ liệu cơ bản.',
        'time': '2 giờ trước',
        'icon': Iconsax.book,
        'color': Colors.green,
      },
      {
        'title': 'Lịch học mới',
        'message':
            'Khoá học "Google Data Analytics" sẽ bắt đầu vào ngày 20/08.',
        'time': '1 ngày trước',
        'icon': Iconsax.book,
        'color': Colors.blue,
      },
      {
        'title': 'Cập nhật chứng chỉ',
        'message':
            'Chứng chỉ Google IT Support đã được thêm vào hồ sơ của bạn.',
        'time': '3 ngày trước',
        'icon': Iconsax.book,
        'color': Colors.orange,
      },
      {
        'title': 'Hoàn thành bài học',
        'message': 'Bạn đã hoàn thành Chương 2 - Phân tích dữ liệu cơ bản.',
        'time': '2 giờ trước',
        'icon': Iconsax.book,
        'color': Colors.green,
      },
      {
        'title': 'Lịch học mới',
        'message':
            'Khoá học "Google Data Analytics" sẽ bắt đầu vào ngày 20/08.',
        'time': '1 ngày trước',
        'icon': Iconsax.book,
        'color': Colors.blue,
      },
      {
        'title': 'Cập nhật chứng chỉ',
        'message':
            'Chứng chỉ Google IT Support đã được thêm vào hồ sơ của bạn.',
        'time': '3 ngày trước',
        'icon': Iconsax.book,
        'color': Colors.orange,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Thông báo",
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (notif['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  notif['icon'] as IconData,
                  color: notif['color'] as Color,
                  size: 22,
                ),
              ),
              title: Text(
                notif['title'],
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif['message'],
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif['time'],
                    style: GoogleFonts.lato(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
