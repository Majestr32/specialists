import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:specialists_analyzer/domain/entities/challenge.dart';
import 'package:specialists_analyzer/domain/entities/diagram.dart';
import 'package:specialists_analyzer/domain/entities/specialist.dart';
import 'package:specialists_analyzer/domain/repositories/app_repository_contract.dart';

part 'specialists_diagrams_state.dart';

class SpecialistsDiagramsCubit extends Cubit<SpecialistsDiagramsState> {
  final AppRepository _appRepository;

  StreamSubscription? _specialistsSubscription;
  StreamSubscription? _diagramsSubscription;
  StreamSubscription? _challengesSubscription;

  SpecialistsDiagramsCubit({required AppRepository appRepository})
      : _appRepository = appRepository,
        super(SpecialistsDiagramsState.initial());

  Future<void> listenSpecialists({required String challengeId}) async {
    emit(SpecialistsDiagramsState.initial().copyWith(
        specialists: state.specialists,
        selectedChallengeId: challengeId,
        challenges: state.challenges));
    _specialistsSubscription?.cancel();
    _specialistsSubscription =
        _appRepository.specialists(challengeId: challengeId).listen((e) {
          e.sort((a,b) => (b.estimation?.average ?? 0).compareTo(a.estimation?.average ?? 0));
      emit(state.copyWith(specialists: e));
    });
  }

  Future<void> estimateSelectedDiagram() async {
    emit(state.copyWith(analyzingDiagram: true));
    final specialistId = state.selectedSpecialistId;
    final diagramId = state.selectedDiagramId;
    final taskDescription = state.selectedChallenge!.requirements;
    if (specialistId == null || diagramId == null) return;
    await _appRepository.estimateDiagram(
        specialistId: specialistId,
        diagramId: diagramId,
        taskDescription: taskDescription);
    emit(state.copyWith(analyzingDiagram: false));
  }

  Future<void> selectDiagram({required String diagramId}) async {
    emit(state.copyWith(selectedDiagramId: diagramId));
  }

  Future<void> addSpecialist({required String challengeId, required String name}) {
    return _appRepository.addSpecialist(name: name, challengeId: challengeId);
  }

  Future<void> editSpecialist({required String name, required String id}) {
    return _appRepository.editSpecialist(name: name, id: id);
  }

  Future<void> removeSpecialist({required String id}) {
    return _appRepository.removeSpecialist(id: id);
  }

  Future<void> removeDiagram({required String id}) async {
    if (state.selectedSpecialistId == null) return;
    emit(SpecialistsDiagramsState.initial().copyWith(
        challenges: state.challenges,
        selectedChallengeId: state.selectedChallengeId,
        specialists: state.specialists,
        selectedSpecialistId: state.selectedSpecialistId));
    return _appRepository.removeDiagram(
        specialistId: state.selectedSpecialistId!, diagramId: id);
  }

  Future<void> addDiagram(
      {required String fileName, required Uint8List bytes}) async {
    if (state.selectedSpecialistId == null) return;
    return _appRepository.addDiagram(
        fileName: fileName,
        bytes: bytes,
        specialistId: state.selectedSpecialistId!);
  }

  Future<void> listenDiagrams({required String specialistId}) async {
    emit(SpecialistsDiagramsState.initial().copyWith(
        specialists: state.specialists,
        selectedSpecialistId: specialistId,
        challenges: state.challenges,
        selectedChallengeId: state.selectedChallengeId));
    _diagramsSubscription?.cancel();
    _diagramsSubscription =
        _appRepository.diagrams(specialistId: specialistId).listen((e) {
      emit(state.copyWith(diagrams: e));
    });
  }

  Future<void> listenChallenges({required String userId}) async {
    _challengesSubscription?.cancel();
    _challengesSubscription =
        _appRepository.challenges(userId: userId).listen((e) {
      if (state.specialists == null && e.isNotEmpty) {
        listenSpecialists(challengeId: e.first.id);
      }
      emit(state.copyWith(challenges: e));
    });
  }

  Future<void> addChallenge(
      {required String userId,
      required String name,
      required String requirements}) {
    return _appRepository.addChallenge(
        userId: userId, name: name, requirements: requirements);
  }

  Future<void> removeChallenge({required String id}) {
    return _appRepository.removeChallenge(id: id);
  }

  Future<void> editChallenge({required String id, required String name, required String requirements}){
    return _appRepository.editChallenge(id: id, name: name, requirements: requirements);
  }

  Future<void> estimateSpecialist({required String id}) async{
    final taskDescription = state.selectedChallenge!.requirements;
    emit(state.copyWith(analyzingSpecialist: true));
    await _appRepository.estimateSpecialist(id: id, taskDescription: taskDescription);
    emit(state.copyWith(analyzingSpecialist: false));
  }

  @override
  Future<void> close() {
    _specialistsSubscription?.cancel();
    _diagramsSubscription?.cancel();
    return super.close();
  }
}
