import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventCardList extends StatelessWidget {
  const EventCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> events = [
      {
        "title": "Workshop: Kỹ năng thuyết trình",
        "date": "20/08/2025",
        "time": "19:00",
        "image": "https://picsum.photos/400/200?random=1",
      },
      {
        "title": "Webinar: Lập trình Flutter cơ bản",
        "date": "25/08/2025",
        "time": "20:00",
        "image": "https://picsum.photos/400/200?random=2",
      },
      {
        "title": "Khóa học: Tư duy phản biện",
        "date": "28/08/2025",
        "time": "18:30",
        "image": "https://picsum.photos/400/200?random=3",
      },
      {
        "title": "Workshop: Kỹ năng thuyết trình",
        "date": "20/08/2025",
        "time": "19:00",
        "image": "https://picsum.photos/400/200?random=1",
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final event = events[index];
          return SizedBox(
            width: screenWidth / 2.5,
            child: _EventCard(
              title: event["title"]!,
              date: event["date"]!,
              time: event["time"]!,
              imageUrl: event["image"]!,
            ),
          );
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String imageUrl;

  const _EventCard({
    required this.title,
    required this.date,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sự kiện
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Nội dung
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
