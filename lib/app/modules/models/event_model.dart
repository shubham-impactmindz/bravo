class Event {
  DateTime date;
  String title;
  String time;
  String? description;
  double? cost;
  String? createdBy;

  Event({
    required this.date,
    required this.title,
    required this.time,
    this.description,
    this.cost,
    this.createdBy,
  });
}