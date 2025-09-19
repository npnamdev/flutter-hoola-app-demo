import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:my_app/core/constants/app_tokens.dart';
import 'package:my_app/core/constants/app_colors.dart';

class ClassSession {
  final DateTime start;
  final Duration duration;
  final String subject;
  final String room;
  final String status; // planned, ongoing, done
  ClassSession({
    required this.start,
    required this.duration,
    required this.subject,
    required this.room,
    required this.status,
  });

  DateTime get end => start.add(duration);
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  late final Map<DateTime, List<ClassSession>> _events;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
  _focusedDay = DateTime.now();
    _events = _generateFake();
    _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  Map<DateTime, List<ClassSession>> _generateFake() {
    final now = DateTime.now();
    DateTime d(int add) => DateTime(now.year, now.month, now.day + add);
    List<ClassSession> list(DateTime day) => [
          ClassSession(
            start: day.add(const Duration(hours: 7)),
            duration: const Duration(hours: 1),
            subject: 'Toán',
            room: 'P201',
            status: 'planned',
          ),
          ClassSession(
            start: day.add(const Duration(hours: 9)),
            duration: const Duration(hours: 1),
            subject: 'Văn',
            room: 'P105',
            status: 'planned',
          ),
          ClassSession(
            start: day.add(const Duration(hours: 13, minutes: 30)),
            duration: const Duration(hours: 1),
            subject: 'Anh',
            room: 'Lab 3',
            status: 'planned',
          ),
        ];
    return {
      d(0): list(d(0)),
      d(1): list(d(1)),
      d(2): list(d(2)),
      d(4): list(d(4)),
      d(6): list(d(6)),
    };
  }

  List<ClassSession> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    final base = _events[key] ?? [];
    if (_filter == 'all') return base;
    if (_filter == 'morning') {
      return base.where((e) => e.start.hour < 12).toList();
    } else if (_filter == 'afternoon') {
      return base.where((e) => e.start.hour >= 12 && e.start.hour < 18).toList();
    } else if (_filter == 'done') {
      return base.where((e) => e.status == 'done').toList();
    }
    return base;
  }

  List<ClassSession> get _upcoming {
    final now = DateTime.now();
    final all = _events.values.expand((e) => e).where((s) => s.end.isAfter(now)).toList();
    all.sort((a, b) => a.start.compareTo(b.start));
    return all.take(6).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _getEventsForDay(_selectedDay!);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Lịch học',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCalendar(),
            const SizedBox(height: 18),
            _FilterChips(
              current: _filter,
              onSelect: (f) => setState(() => _filter = f),
            ),
            const SizedBox(height: 24),
            if (selectedEvents.isNotEmpty) ...[
              _SectionHeader(title: 'Trong ngày (${selectedEvents.length})'),
              const SizedBox(height: 12),
              ...selectedEvents.map((e) => _SessionCard(session: e)),
              const SizedBox(height: 28),
            ],
            _SectionHeader(title: 'Sắp tới'),
            const SizedBox(height: 12),
            if (_upcoming.isEmpty)
              _EmptyState(message: 'Không có buổi học sắp tới')
            else
              ..._upcoming.map((e) => _SessionCard(session: e)),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: Colors.black.withOpacity(.05)),
        boxShadow: AppShadows.soft,
      ),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: TableCalendar<ClassSession>(
        firstDay: DateTime.now().subtract(const Duration(days: 90)),
        lastDay: DateTime.now().add(const Duration(days: 180)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, size: 20),
          rightChevronIcon: const Icon(Icons.chevron_right, size: 20),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54),
          weekendStyle: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.redAccent),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(.15),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          markersAlignment: Alignment.bottomCenter,
          markersMaxCount: 3,
          defaultTextStyle: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600),
          weekendTextStyle: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.redAccent),
        ),
        eventLoader: (day) => _getEventsForDay(day),
        onDaySelected: (selected, focused) {
          setState(() {
            _selectedDay = selected;
            _focusedDay = focused;
          });
        },
        onPageChanged: (focused) => _focusedDay = focused,
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final ClassSession session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(session.start);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: Colors.black.withOpacity(.05)),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(AppRadii.sm),
            ),
            child: const Icon(Icons.menu_book, color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.subject,
                  style: GoogleFonts.lato(fontSize: 15, fontWeight: FontWeight.w700, height: 1.1),
                ),
                const SizedBox(height: 4),
                Text(
                  '$time  •  Phòng ${session.room}',
                  style: GoogleFonts.lato(fontSize: 12.5, color: Colors.black54),
                ),
              ],
            ),
          ),
          _StatusBadge(status: session.status),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color _bg() {
    switch (status) {
      case 'done':
        return Colors.green.withOpacity(.12);
      case 'ongoing':
        return Colors.orange.withOpacity(.15);
      default:
        return Colors.blue.withOpacity(.10);
    }
  }

  Color _fg() {
    switch (status) {
      case 'done':
        return Colors.green.shade700;
      case 'ongoing':
        return Colors.orange.shade700;
      default:
        return AppColors.primary;
    }
  }

  String _label() {
    switch (status) {
      case 'done':
        return 'Hoàn thành';
      case 'ongoing':
        return 'Đang học';
      default:
        return 'Sắp học';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _bg(),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        _label(),
        style: GoogleFonts.lato(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: _fg(),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String current;
  final ValueChanged<String> onSelect;
  const _FilterChips({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'k': 'all', 'l': 'Tất cả'},
      {'k': 'morning', 'l': 'Sáng'},
      {'k': 'afternoon', 'l': 'Chiều'},
      {'k': 'done', 'l': 'Hoàn thành'},
    ];
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final f = filters[i];
            final selected = f['k'] == current;
          return GestureDetector(
            onTap: () => onSelect(f['k']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppColors.primary : Colors.black.withOpacity(.08),
                ),
                boxShadow: [
                  if (selected)
                    BoxShadow(
                      color: AppColors.primary.withOpacity(.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  else ...AppShadows.soft,
                ],
              ),
              child: Center(
                child: Text(
                  f['l']!,
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.lato(fontSize: 17, fontWeight: FontWeight.w800),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: Colors.black.withOpacity(.05)),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        children: [
          const Icon(Icons.event_busy, size: 42, color: AppColors.primary),
          const SizedBox(height: 14),
          Text(
            message,
            style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
