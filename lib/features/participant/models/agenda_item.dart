enum AgendaType { keynote, workshop, meal, checkpoint, deadline }

class AgendaItem {
  final String id;
  final String title;
  final String speakerOrLocation;
  final String startTime;
  final String endTime;
  final AgendaType type;
  final bool isCompleted;
  final bool isLiveNow;
  bool isBookmarked;

  AgendaItem({
    required this.id,
    required this.title,
    required this.speakerOrLocation,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.isCompleted = false,
    this.isLiveNow = false,
    this.isBookmarked = false,
  });
}
