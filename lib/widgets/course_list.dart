import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final double progress; // 0.0 -> 1.0

  const CourseCard({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) => Container(
                height: 140,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: Icon(Icons.image, color: Colors.grey[500]),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    author,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.purple,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseList extends StatelessWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {
        "title": "Lập trình Flutter từ A-Z",
        "author": "Nguyễn Văn A",
        "imageUrl":
            "https://cdn-s.hoolacdn.com/coding-29315-1i40r6bp1/sgp1/lib/image/1_xDf7qGxuMsuDgDSeo-original.png",
        "progress": 0.6,
      },
      {
        "title": "Thiết kế UI/UX chuyên nghiệp",
        "author": "Trần Thị B",
        "imageUrl":
            "https://cdn-s.hoolacdn.com/coding-29315-1i40r6bp1/sgp1/lib/image/7_x8P6FLyphxBcrvDqw-original.png",
        "progress": 0.3,
      },
      {
        "title": "Phân tích dữ liệu với Python",
        "author": "Lê Văn C",
        "imageUrl":
            "https://cdn-s.hoolacdn.com/coding-29315-1i40r6bp1/sgp1/lib/image/2_6kGipwm39czsCf3Dk-original.png",
        "progress": 0.8,
      },
      {
        "title": "Machine Learning cơ bản",
        "author": "Mai D",
        "imageUrl":
            "https://cdn-s.hoolacdn.com/coding-29315-1i40r6bp1/sgp1/lib/image/12_cwcHLEzCwFWjkbETi-original.png",
        "progress": 0.1,
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 32.0;
    final cardWidth = (screenWidth - horizontalPadding) / 2.5;

    return SizedBox(
      height: 246,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            width: cardWidth,
            child: CourseCard(
              title: course["title"] as String,
              author: course["author"] as String,
              imageUrl: course["imageUrl"] as String,
              progress: course["progress"] as double,
            ),
          );
        },
      ),
    );
  }
}
