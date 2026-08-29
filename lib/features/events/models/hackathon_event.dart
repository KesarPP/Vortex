class HackathonEvent {
  final String id;
  final String title;
  final String tagline;
  final String bannerIcon;
  final String date;
  final String venue;
  final int minTeamSize;
  final int maxTeamSize;
  final List<String> tracks;
  final List<String> availableCoupons;
  final bool isRegistered;
  final String? registeredTeamId;

  HackathonEvent({
    required this.id,
    required this.title,
    required this.tagline,
    required this.bannerIcon,
    required this.date,
    required this.venue,
    required this.minTeamSize,
    required this.maxTeamSize,
    required this.tracks,
    required this.availableCoupons,
    this.isRegistered = false,
    this.registeredTeamId,
  });

  HackathonEvent copyWith({
    bool? isRegistered,
    String? registeredTeamId,
  }) {
    return HackathonEvent(
      id: id,
      title: title,
      tagline: tagline,
      bannerIcon: bannerIcon,
      date: date,
      venue: venue,
      minTeamSize: minTeamSize,
      maxTeamSize: maxTeamSize,
      tracks: tracks,
      availableCoupons: availableCoupons,
      isRegistered: isRegistered ?? this.isRegistered,
      registeredTeamId: registeredTeamId ?? this.registeredTeamId,
    );
  }
}
