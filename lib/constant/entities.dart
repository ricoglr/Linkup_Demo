class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String location;
  final String category;
  final String imageUrl;
  final String organizerId;
  final List<String> participants;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.imageUrl,
    required this.organizerId,
    this.participants = const [],
    required this.createdAt,
  });
}
