class SpecialistEstimation{
  final double requirementsUnderstanding;
  final double structuringAndOrganization;
  final double logicAndCoherence;
  final String? comment;

  double get average => (requirementsUnderstanding * 3 + structuringAndOrganization + logicAndCoherence) / 5;

  const SpecialistEstimation({
    required this.requirementsUnderstanding,
    required this.structuringAndOrganization,
    required this.logicAndCoherence,
    this.comment,
  });

  SpecialistEstimation copyWith({
    double? requirementsUnderstanding,
    double? structuringAndOrganization,
    double? logicAndCoherence,
    String? comment,
  }) {
    return SpecialistEstimation(
      requirementsUnderstanding:
          requirementsUnderstanding ?? this.requirementsUnderstanding,
      structuringAndOrganization:
          structuringAndOrganization ?? this.structuringAndOrganization,
      logicAndCoherence: logicAndCoherence ?? this.logicAndCoherence,
      comment: comment ?? this.comment,
    );
  }

  factory SpecialistEstimation.fromJson(Map<String, dynamic> map) {
    return SpecialistEstimation(
      requirementsUnderstanding: (map['requirements_understanding'] as num).toDouble(),
      structuringAndOrganization: (map['structuring_and_organization'] as num).toDouble(),
      logicAndCoherence: (map['logic_and_coherence'] as num).toDouble(),
      comment: map['comment'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecialistEstimation &&
          runtimeType == other.runtimeType &&
          requirementsUnderstanding == other.requirementsUnderstanding &&
          structuringAndOrganization == other.structuringAndOrganization &&
          logicAndCoherence == other.logicAndCoherence &&
          comment == other.comment;

  @override
  int get hashCode =>
      requirementsUnderstanding.hashCode ^
      structuringAndOrganization.hashCode ^
      logicAndCoherence.hashCode ^
      comment.hashCode;
}