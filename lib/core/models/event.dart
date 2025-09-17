class EventItem {
  final String id;
  final String title;
  final String date; // ISO or formatted for now
  final String time; // Could be DateTime later
  final String imageUrl;

  const EventItem({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.imageUrl,
  });
}
