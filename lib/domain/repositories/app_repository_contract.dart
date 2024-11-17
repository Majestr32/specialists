import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:specialists_analyzer/domain/entities/challenge.dart';
import 'package:specialists_analyzer/domain/entities/diagram.dart';
import 'package:specialists_analyzer/domain/entities/diagram_estimation.dart';
import 'package:specialists_analyzer/domain/entities/specialist.dart';

abstract class AppRepository{
  Stream<List<SpecialistEntity>> specialists({required String challengeId});
  Future<void> addSpecialist({required String challengeId, required String name});
  Future<void> removeSpecialist({required String id});
  Future<void> editSpecialist({required String name, required String id});
  Future<SpecialistEntity> fetchSpecialist({required String id});
  Future<void> estimateSpecialist({required String id, required String taskDescription});

  Stream<List<DiagramEntity>> diagrams({required String specialistId});
  Future<DiagramEntity> fetchDiagram({required String specialistId, required String diagramId});
  Future<List<DiagramEntity>> fetchDiagrams({required String specialistId});
  Future<void> addDiagram({required String fileName, required Uint8List bytes, required String specialistId});
  Future<void> removeDiagram({required String specialistId, required String diagramId});
  Future<DiagramEstimation> estimateDiagram({required String specialistId, required String diagramId, required String taskDescription});

  Stream<List<ChallengeEntity>> challenges({required String userId});
  Future<void> addChallenge({required String userId, required String name, required String requirements});
  Future<void> removeChallenge({required String id});
  Future<void> editChallenge({required String id, required String name, required String requirements});

  Stream<User?> get users;
  Future<void> signInWithGoogle();
  Future<void> signOut();
}