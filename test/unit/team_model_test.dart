import 'package:flutter_test/flutter_test.dart';
import 'package:vortex/features/teams/models/team_model.dart';

void main() {
  group('TeamModel Tests', () {
    test('TeamMember serialization and deserialization', () {
      final member = TeamMember(
        id: 'usr-1',
        name: 'Alice Dev',
        role: 'Full Stack',
        email: 'alice@vortex.os',
        avatar: '⚡',
        isLeader: true,
        isCheckedIn: true,
      );

      final json = member.toJson();
      final fromJson = TeamMember.fromJson(json);

      expect(fromJson.id, 'usr-1');
      expect(fromJson.name, 'Alice Dev');
      expect(fromJson.role, 'Full Stack');
      expect(fromJson.isLeader, true);
      expect(fromJson.isCheckedIn, true);
    });

    test('JoinRequest serialization and deserialization', () {
      final request = JoinRequest(
        userId: 'usr-2',
        name: 'Bob Cyber',
        handle: '@bob',
        avatar: '🔥',
      );

      final json = request.toJson();
      final fromJson = JoinRequest.fromJson(json);

      expect(fromJson.userId, 'usr-2');
      expect(fromJson.name, 'Bob Cyber');
      expect(fromJson.handle, '@bob');
      expect(fromJson.avatar, '🔥');
    });

    test('TeamModel calculations, copyWith, and serialization', () {
      final leader = TeamMember(
        id: 'usr-1',
        name: 'Alice',
        role: 'Lead',
        email: 'alice@vortex.os',
        avatar: '⚡',
        isLeader: true,
      );

      final team = TeamModel(
        id: 'TEAM-001',
        eventId: 'sprint-2026',
        name: 'NeuralHackers',
        track: 'AI/ML',
        tableNumber: 'Table A-01',
        maxCapacity: 4,
        members: [leader],
        isSeekingMembers: true,
        innovationScore: 8.5,
        technicalScore: 9.0,
        uiuxScore: 8.0,
        pitchScore: 9.5,
      );

      expect(team.isFull, false);
      expect(team.totalScore, 35.0);
      expect(team.teamQrPayload, contains('TEAM-001'));
      expect(team.teamQrPayload, contains('NeuralHackers'));

      final json = team.toJson();
      final fromJson = TeamModel.fromJson(json);

      expect(fromJson.id, 'TEAM-001');
      expect(fromJson.name, 'NeuralHackers');
      expect(fromJson.isSeekingMembers, true);
      expect(fromJson.totalScore, 35.0);

      final updatedTeam = team.copyWith(
        isSeekingMembers: false,
        status: TeamStatus.approved,
      );

      expect(updatedTeam.isSeekingMembers, false);
      expect(updatedTeam.status, TeamStatus.approved);
    });
  });
}
