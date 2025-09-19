import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/core/constants/app_tokens.dart';
import 'package:my_app/core/constants/app_colors.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Báo cáo học tập',
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _TodaySummaryCard(),
            SizedBox(height: 18),
            _StreakCard(),
            SizedBox(height: 18),
            _WeekChartCard(),
            SizedBox(height: 18),
            _CoursesProgressCard(),
            SizedBox(height: 18),
            _AchievementsCard(),
          ],
        ),
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _BaseCard({required this.child, EdgeInsetsGeometry? padding})
      : padding = padding ?? const EdgeInsets.fromLTRB(16, 14, 16, 16);

  @override
  Widget build(BuildContext context) {
    final pad = padding; // ensure referenced
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: Colors.black.withOpacity(.05)),
        boxShadow: AppShadows.soft,
      ),
      child: Padding(padding: pad, child: child),
    );
  }
}

class _TodaySummaryCard extends StatelessWidget {
  const _TodaySummaryCard();
  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: const [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text('62%',
                style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hôm nay', style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
                const SizedBox(height: 6),
                Text('24 / 40 phút mục tiêu', style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 24/40,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE9ECF2),
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard();
  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.local_fire_department, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chuỗi ngày học', style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
                const SizedBox(height: 6),
                Text('5 ngày liên tiếp', style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(7, (i) {
                    final active = i < 5;
                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? AppColors.primary : Colors.grey.shade200,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekChartCard extends StatelessWidget {
  const _WeekChartCard();
  @override
  Widget build(BuildContext context) {
    final data = const [40,30,55,0,20,60,10]; // minutes
    final maxVal = 60.0;
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Biểu đồ tuần', style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i=0;i<data.length;i++) ...[
                  Expanded(
                    child: _Bar(
                      value: data[i]/maxVal,
                      label: ['T2','T3','T4','T5','T6','T7','CN'][i],
                    ),
                  ),
                  if (i!=data.length-1) const SizedBox(width: 6),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double value; // 0..1
  final String label;
  const _Bar({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              width: 18,
              height: (value.clamp(0,1))*100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [AppColors.primaryLight, AppColors.primary],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black54)),
      ],
    );
  }
}

class _CoursesProgressCard extends StatelessWidget {
  const _CoursesProgressCard();
  @override
  Widget build(BuildContext context) {
    final courses = const [
      {'title':'Flutter cơ bản','progress':0.62},
      {'title':'UI/UX Design','progress':0.30},
      {'title':'Python Data','progress':0.80},
    ];
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tiến độ khoá học', style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          for (final c in courses) ...[
            _CourseProgressRow(title: c['title'] as String, progress: c['progress'] as double),
            const SizedBox(height: 12),
          ]
        ],
      ),
    );
  }
}

class _CourseProgressRow extends StatelessWidget {
  final String title; final double progress;
  const _CourseProgressRow({required this.title, required this.progress});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.lato(fontSize: 13.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE9ECF2),
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text('${(progress*100).round()}%', style: GoogleFonts.lato(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary)),
      ],
    );
  }
}

class _AchievementsCard extends StatelessWidget {
  const _AchievementsCard();
  @override
  Widget build(BuildContext context) {
    final items = const [
      {'icon': Icons.star, 'label': 'Hoàn thành 5 bài'},
      {'icon': Icons.flash_on, 'label': 'Streak 5 ngày'},
      {'icon': Icons.speed, 'label': '100 phút học'},
    ];
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thành tựu', style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              // target chip min width
              const minChipWidth = 150.0;
              int columns = (maxWidth / (minChipWidth + 12)).floor();
              if (columns < 1) columns = 1;
              if (columns > items.length) columns = items.length;
              final itemWidth = (maxWidth - (12 * (columns - 1))) / columns;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final i in items)
                    SizedBox(
                      width: itemWidth,
                      child: _AchievementChip(
                        icon: i['icon'] as IconData,
                        label: i['label'] as String,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AchievementChip extends StatelessWidget {
  final IconData icon; final String label;
  const _AchievementChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(.10), AppColors.primary.withOpacity(.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(.12),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
