import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schedule = {
      'Thứ 2': ['Toán - 7:00', 'Văn - 9:00', 'Lý - 13:00'],
      'Thứ 3': ['Anh - 8:00', 'Hóa - 10:00'],
      'Thứ 4': ['Sinh - 7:30', 'Sử - 10:00', 'Địa - 14:00'],
      'Thứ 5': ['Toán - 8:00', 'Văn - 10:00'],
      'Thứ 6': ['Anh - 7:00', 'Tin - 9:00', 'GDCD - 13:00'],
    };

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lịch Học Tuần',
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 12),
              ...schedule.entries.map(
                (entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Column(
                      children: entry.value
                          .map(
                            (cls) => Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                cls,
                                style: GoogleFonts.lato(fontSize: 15),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
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
