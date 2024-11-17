class ChallengeEntity{
  final String id;
  final String name;
  final String requirements;

  const ChallengeEntity({
    required this.id,
    required this.name,
    required this.requirements,
  });

  ChallengeEntity copyWith({
    String? id,
    String? name,
    String? requirements,
  }) {
    return ChallengeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      requirements: requirements ?? this.requirements,
    );
  }

  factory ChallengeEntity.fromJson(Map<String, dynamic> map) {
    return ChallengeEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      requirements: map['requirements'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          requirements == other.requirements;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ requirements.hashCode;
}