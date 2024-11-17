part of 'specialists_diagrams_cubit.dart';

class SpecialistsDiagramsState {
  final List<ChallengeEntity>? challenges;
  final List<SpecialistEntity>? specialists;
  final String? selectedChallengeId;
  final String? selectedSpecialistId;
  final String? selectedDiagramId;
  final List<DiagramEntity>? diagrams;
  final bool analyzingDiagram;
  final bool analyzingSpecialist;

  DiagramEntity? get selectedDiagram =>
      diagrams != null && selectedDiagramId != null
          ? diagrams!.where((e) => e.id == selectedDiagramId).firstOrNull
          : null;

  ChallengeEntity? get selectedChallenge =>
      (challenges != null && selectedChallengeId != null
          ? challenges!.where((e) => e.id == selectedChallengeId).firstOrNull
          : null) ?? challenges?.firstOrNull;

  SpecialistsDiagramsState({
    this.challenges,
    this.selectedSpecialistId,
    this.selectedChallengeId,
    this.selectedDiagramId,
    this.specialists,
    this.diagrams,
    this.analyzingSpecialist = false,
    this.analyzingDiagram = false,
  });

  factory SpecialistsDiagramsState.initial() {
    return SpecialistsDiagramsState();
  }

  SpecialistsDiagramsState copyWith({
    List<ChallengeEntity>? challenges,
    List<SpecialistEntity>? specialists,
    String? selectedChallengeId,
    String? selectedSpecialistId,
    String? selectedDiagramId,
    List<DiagramEntity>? diagrams,
    bool? analyzingDiagram,
    bool? analyzingSpecialist,
  }) {
    return SpecialistsDiagramsState(
      challenges: challenges ?? this.challenges,
      specialists: specialists ?? this.specialists,
      selectedChallengeId: selectedChallengeId ?? this.selectedChallengeId,
      selectedSpecialistId: selectedSpecialistId ?? this.selectedSpecialistId,
      selectedDiagramId: selectedDiagramId ?? this.selectedDiagramId,
      diagrams: diagrams ?? this.diagrams,
      analyzingDiagram: analyzingDiagram ?? this.analyzingDiagram,
      analyzingSpecialist: analyzingSpecialist ?? this.analyzingSpecialist,
    );
  }
}
