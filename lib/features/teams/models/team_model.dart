class TeamMember {
  final String id;
  final String name;
  final String role;
  final String email;
  final String avatar;
  final bool isLeader;
  final bool isCheckedIn;

  TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.avatar,
    this.isLeader = false,
    this.isCheckedIn = false,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      isLeader: json['isLeader'] ?? false,
      isCheckedIn: json['isCheckedIn'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'email': email,
        'avatar': avatar,
        'isLeader': isLeader,
        'isCheckedIn': isCheckedIn,
      };
}

class JoinRequest {
  final String userId;
  final String name;
  final String handle;
  final String avatar;

  JoinRequest({
    required this.userId,
    required this.name,
    required this.handle,
    required this.avatar,
  });

  factory JoinRequest.fromJson(Map<String, dynamic> json) => JoinRequest(
        userId: json['userId'] ?? '',
        name: json['name'] ?? '',
        handle: json['handle'] ?? '',
        avatar: json['avatar'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'handle': handle,
        'avatar': avatar,
      };
}

enum TeamStatus { recruiting, fullPendingApproval, approved }

class TeamModel {
  final String id;
  final String eventId;
  final String name;
  final String track;
  final String tableNumber;
  final int maxCapacity;
  final List<TeamMember> members;
  final TeamStatus status;
  final String? approvedAt;
  final List<String> requiredSkills;
  final List<JoinRequest> joinRequests;
  final bool isSeekingMembers;

  // Judging Scores
  final double? innovationScore;
  final double? technicalScore;
  final double? uiuxScore;
  final double? pitchScore;

  TeamModel({
    required this.id,
    required this.eventId,
    required this.name,
    required this.track,
    required this.tableNumber,
    required this.maxCapacity,
    required this.members,
    this.status = TeamStatus.recruiting,
    this.approvedAt,
    this.requiredSkills = const [],
    this.joinRequests = const [],
    this.isSeekingMembers = true,
    this.innovationScore,
    this.technicalScore,
    this.uiuxScore,
    this.pitchScore,
  });

  bool get isFull => members.length >= maxCapacity;

  String get teamQrPayload => 'VORTEX-TEAM-AUTH::$id::$name::$tableNumber::MEMBERS=${members.length}';
  
  double get totalScore => (innovationScore ?? 0) + (technicalScore ?? 0) + (uiuxScore ?? 0) + (pitchScore ?? 0);

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] ?? '',
      eventId: json['eventId'] ?? '',
      name: json['name'] ?? '',
      track: json['track'] ?? '',
      tableNumber: json['tableNumber'] ?? '',
      maxCapacity: json['maxCapacity'] ?? 4,
      members: (json['members'] as List<dynamic>?)
              ?.map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      status: TeamStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TeamStatus.recruiting,
      ),
      approvedAt: json['approvedAt'],
      requiredSkills: (json['requiredSkills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      joinRequests: (json['joinRequests'] as List<dynamic>?)
              ?.map((e) => JoinRequest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isSeekingMembers: json['isSeekingMembers'] ?? true,
      innovationScore: json['innovationScore']?.toDouble(),
      technicalScore: json['technicalScore']?.toDouble(),
      uiuxScore: json['uiuxScore']?.toDouble(),
      pitchScore: json['pitchScore']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'name': name,
        'track': track,
        'tableNumber': tableNumber,
        'maxCapacity': maxCapacity,
        'members': members.map((m) => m.toJson()).toList(),
        'status': status.name,
        'approvedAt': approvedAt,
        'requiredSkills': requiredSkills,
        'joinRequests': joinRequests.map((j) => j.toJson()).toList(),
        'isSeekingMembers': isSeekingMembers,
        'innovationScore': innovationScore,
        'technicalScore': technicalScore,
        'uiuxScore': uiuxScore,
        'pitchScore': pitchScore,
      };

  TeamModel copyWith({
    String? name,
    String? track,
    String? tableNumber,
    List<TeamMember>? members,
    TeamStatus? status,
    String? approvedAt,
    List<String>? requiredSkills,
    List<JoinRequest>? joinRequests,
    bool? isSeekingMembers,
    double? innovationScore,
    double? technicalScore,
    double? uiuxScore,
    double? pitchScore,
  }) {
    return TeamModel(
      id: id,
      eventId: eventId,
      name: name ?? this.name,
      track: track ?? this.track,
      tableNumber: tableNumber ?? this.tableNumber,
      maxCapacity: maxCapacity,
      members: members ?? this.members,
      status: status ?? this.status,
      approvedAt: approvedAt ?? this.approvedAt,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      joinRequests: joinRequests ?? this.joinRequests,
      isSeekingMembers: isSeekingMembers ?? this.isSeekingMembers,
      innovationScore: innovationScore ?? this.innovationScore,
      technicalScore: technicalScore ?? this.technicalScore,
      uiuxScore: uiuxScore ?? this.uiuxScore,
      pitchScore: pitchScore ?? this.pitchScore,
    );
  }
}
