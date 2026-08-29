enum InvitationStatus { pending, accepted, declined }

class TeamInvitation {
  final String id;
  final String senderName;
  final String senderRole;
  final String teamName;
  final String avatar;
  final int compatibilityScore;
  final String sentTime;
  InvitationStatus status;

  TeamInvitation({
    required this.id,
    required this.senderName,
    required this.senderRole,
    required this.teamName,
    required this.avatar,
    required this.compatibilityScore,
    required this.sentTime,
    this.status = InvitationStatus.pending,
  });
}
