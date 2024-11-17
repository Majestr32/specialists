import 'package:specialists_analyzer/domain/entities/specialist_estimation.dart';

class SpecialistEntity{
  final String id;
  final String name;
  final String challengeId;
  final SpecialistEstimation? estimation;

  const SpecialistEntity({
    required this.id,
    required this.name,
    required this.challengeId,
    this.estimation
  });

  factory SpecialistEntity.fromJson(Map<String, dynamic> map) {
    return SpecialistEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      challengeId: map['challengeId'] as String,
      estimation: map['estimation'] != null ? SpecialistEstimation.fromJson((map['estimation'] as Map).cast<String,dynamic>()) : null
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialistEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          challengeId == other.challengeId &&
          estimation == other.estimation;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ challengeId.hashCode ^ estimation.hashCode;
}