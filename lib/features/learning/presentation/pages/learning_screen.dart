import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {
        'title': 'Google Data Analytics',
        'subtitle': 'Google Professional Certificate',
        'rating': '4.8',
        'students': '175K',
        'image': 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=400',
      },
      {
        'title': 'Google IT Support',
        'subtitle': 'Google Professional Certificate',
        'rating': '4.9',
        'students': '170K',
        'image': 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400',
      },
      {
        'title': 'Google Project Management',
        'subtitle': 'Google Professional Certificate',
        'rating': '4.8',
        'students': '120K',
        'image': 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=400',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Khoá học của tôi',
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
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  course['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                course['title']!,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['subtitle']!,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Iconsax.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        course['rating']!,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Iconsax.user, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        course['students']!,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
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
