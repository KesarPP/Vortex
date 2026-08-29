import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/participant_profile.dart';
import '../models/team_invitation.dart';
import '../models/agenda_item.dart';

final participantProfileProvider = StateNotifierProvider<ParticipantProfileNotifier, ParticipantProfile>((ref) {
  return ParticipantProfileNotifier();
});

class ParticipantProfileNotifier extends StateNotifier<ParticipantProfile> {
  ParticipantProfileNotifier()
      : super(
          ParticipantProfile(
            id: 'usr-new',
            name: 'Hacker',
            handle: '@hacker',
            avatar: '👤',
            teamName: '',
            tableNumber: '',
            bio: 'Add a bio...',
            skills: {},
            lookingFor: [],
            githubUrl: '',
            discordHandle: '',
            isCheckedIn: false,
            mealCoupons: {},
          ),
        );

  void reset() {
    state = ParticipantProfile(
      id: 'usr-new',
      name: 'Hacker',
      handle: '@hacker',
      avatar: '👤',
      teamName: '',
      tableNumber: '',
      bio: 'Add a bio...',
      skills: {},
      lookingFor: [],
      githubUrl: '',
      discordHandle: '',
      isCheckedIn: false,
      mealCoupons: {},
    );
  }

  void updateProfile({
    String? name,
    String? handle,
    String? bio,
    String? teamName,
    String? tableNumber,
    String? githubUrl,
    String? discordHandle,
  }) {
    state = state.copyWith(
      name: name,
      handle: handle,
      bio: bio,
      teamName: teamName,
      tableNumber: tableNumber,
      githubUrl: githubUrl,
      discordHandle: discordHandle,
    );
  }

  void addSkill(String skill) {
    final updated = Set<String>.from(state.skills)..add(skill);
    state = state.copyWith(skills: updated);
  }

  void removeSkill(String skill) {
    final updated = Set<String>.from(state.skills)..remove(skill);
    state = state.copyWith(skills: updated);
  }

  void toggleCoupon(String label) {
    final current = Map<String, bool>.from(state.mealCoupons);
    current[label] = !(current[label] ?? false);
    state = state.copyWith(mealCoupons: current);
  }
}

// Invitations Provider
final invitationsProvider = StateNotifierProvider<InvitationsNotifier, List<TeamInvitation>>((ref) {
  return InvitationsNotifier();
});

class InvitationsNotifier extends StateNotifier<List<TeamInvitation>> {
  InvitationsNotifier() : super([]);

  void acceptInvitation(String id) {
    state = [
      for (final inv in state)
        if (inv.id == id)
          TeamInvitation(
            id: inv.id,
            senderName: inv.senderName,
            senderRole: inv.senderRole,
            teamName: inv.teamName,
            avatar: inv.avatar,
            compatibilityScore: inv.compatibilityScore,
            sentTime: inv.sentTime,
            status: InvitationStatus.accepted,
          )
        else
          inv
    ];
  }

  void declineInvitation(String id) {
    state = [
      for (final inv in state)
        if (inv.id == id)
          TeamInvitation(
            id: inv.id,
            senderName: inv.senderName,
            senderRole: inv.senderRole,
            teamName: inv.teamName,
            avatar: inv.avatar,
            compatibilityScore: inv.compatibilityScore,
            sentTime: inv.sentTime,
            status: InvitationStatus.declined,
          )
        else
          inv
    ];
  }
}

// Agenda Provider
final agendaProvider = StateNotifierProvider<AgendaNotifier, List<AgendaItem>>((ref) {
  return AgendaNotifier();
});

class AgendaNotifier extends StateNotifier<List<AgendaItem>> {
  AgendaNotifier() : super([]);

  void toggleBookmark(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          AgendaItem(
            id: item.id,
            title: item.title,
            speakerOrLocation: item.speakerOrLocation,
            startTime: item.startTime,
            endTime: item.endTime,
            type: item.type,
            isCompleted: item.isCompleted,
            isLiveNow: item.isLiveNow,
            isBookmarked: !item.isBookmarked,
          )
        else
          item
    ];
  }
}

