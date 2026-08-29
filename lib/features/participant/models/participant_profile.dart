class ParticipantProfile {
  final String id;
  final String name;
  final String handle;
  final String avatar;
  final String teamName;
  final String tableNumber;
  final String bio;
  final Set<String> skills;
  final List<String> lookingFor;
  final String githubUrl;
  final String discordHandle;
  final bool isCheckedIn;
  final Map<String, bool> mealCoupons;

  ParticipantProfile({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatar,
    required this.teamName,
    required this.tableNumber,
    required this.bio,
    required this.skills,
    required this.lookingFor,
    required this.githubUrl,
    required this.discordHandle,
    this.isCheckedIn = true,
    required this.mealCoupons,
  });

  ParticipantProfile copyWith({
    String? name,
    String? handle,
    String? avatar,
    String? teamName,
    String? tableNumber,
    String? bio,
    Set<String>? skills,
    List<String>? lookingFor,
    String? githubUrl,
    String? discordHandle,
    bool? isCheckedIn,
    Map<String, bool>? mealCoupons,
  }) {
    return ParticipantProfile(
      id: id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      avatar: avatar ?? this.avatar,
      teamName: teamName ?? this.teamName,
      tableNumber: tableNumber ?? this.tableNumber,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      lookingFor: lookingFor ?? this.lookingFor,
      githubUrl: githubUrl ?? this.githubUrl,
      discordHandle: discordHandle ?? this.discordHandle,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      mealCoupons: mealCoupons ?? this.mealCoupons,
    );
  }
}
