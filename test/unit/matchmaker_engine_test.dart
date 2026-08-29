import 'package:flutter_test/flutter_test.dart';
import 'package:vortex/core/utils/matchmaker_engine.dart';

void main() {
  group('MatchmakerEngine Compatibility Tests', () {
    test('calculateCompatibility with exact skill matches', () {
      final score = MatchmakerEngine.calculateCompatibility(
        userSkills: {'Flutter', 'Dart', 'Firebase'},
        userLookingFor: ['Python', 'FastAPI'],
        targetSkills: {'Python', 'FastAPI'},
        targetLookingFor: ['Flutter'],
      );

      expect(score, greaterThanOrEqualTo(70));
      expect(score, lessThanOrEqualTo(100));
    });

    test('calculateCompatibility with partial complementary matches', () {
      final score = MatchmakerEngine.calculateCompatibility(
        userSkills: {'Flutter', 'Dart'},
        userLookingFor: ['Python'],
        targetSkills: {'Python', 'Rust'},
        targetLookingFor: ['Go'],
      );

      expect(score, greaterThanOrEqualTo(30));
      expect(score, lessThanOrEqualTo(80));
    });

    test('calculateCompatibility with zero matches returns sensible baseline', () {
      final score = MatchmakerEngine.calculateCompatibility(
        userSkills: {'Solidity'},
        userLookingFor: ['Web3'],
        targetSkills: {'Swift', 'iOS'},
        targetLookingFor: ['Android'],
      );

      expect(score, lessThanOrEqualTo(50));
    });
  });
}
