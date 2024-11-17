class DiagramEstimation{
  final int businessRequirements;
  final int structure;
  final int clear;
  final int extension;
  final String? diagram;

  const DiagramEstimation({
    required this.businessRequirements,
    required this.structure,
    required this.clear,
    required this.extension,
    this.diagram,
  });

  factory DiagramEstimation.fromJson(Map<String, dynamic> map) {
    return DiagramEstimation(
      businessRequirements: map['bussiness_requirements'] as int,
      structure: map['structure'] as int,
      clear: map['clear'] as int,
      extension: map['extension'] as int,
      diagram: map['digram'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessRequirements': this.businessRequirements,
      'structure': this.structure,
      'clear': this.clear,
      'extension': this.extension,
      'diagram': this.diagram,
    };
  }
}