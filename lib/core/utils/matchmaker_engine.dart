class SkillVector {
  final String name;
  final Set<String> skills;
  final List<String> lookingFor;

  const SkillVector({
    required this.name,
    required this.skills,
    required this.lookingFor,
  });
}

class MatchmakerEngine {
  /// Calculate compatibility score (0 to 100%) between a participant and a team/peer
  /// Considers skill overlap penalty (redundancy) and skill-gap fulfillment (complementarity).
  static int calculateCompatibility({
    required Set<String> userSkills,
    required List<String> userLookingFor,
    required Set<String> targetSkills,
    required List<String> targetLookingFor,
  }) {
    if (userSkills.isEmpty || targetSkills.isEmpty) return 50;

    // 1. Complementarity: Does target have what user is looking for?
    int userNeedFulfilled = 0;
    for (final need in userLookingFor) {
      if (targetSkills.contains(need)) {
        userNeedFulfilled++;
      }
    }
    final double userNeedRatio = userLookingFor.isNotEmpty 
        ? userNeedFulfilled / userLookingFor.length 
        : 0.5;

    // 2. Mutual fulfillment: Does user have what target is looking for?
    int targetNeedFulfilled = 0;
    for (final need in targetLookingFor) {
      if (userSkills.contains(need)) {
        targetNeedFulfilled++;
      }
    }
    final double targetNeedRatio = targetLookingFor.isNotEmpty 
        ? targetNeedFulfilled / targetLookingFor.length 
        : 0.5;

    // 3. Redundancy penalty (too much exact overlap is less complementary)
    final int overlap = userSkills.intersection(targetSkills).length;
    final double overlapRatio = overlap / (userSkills.length + targetSkills.length);
    final double balanceFactor = 1.0 - (overlapRatio * 0.3); // Minor penalty for high duplicate skills

    final double rawScore = ((userNeedRatio * 0.5) + (targetNeedRatio * 0.5)) * balanceFactor * 100;
    return rawScore.clamp(20, 99).toInt();
  }
}
