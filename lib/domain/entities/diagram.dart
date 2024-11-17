import 'package:specialists_analyzer/domain/entities/diagram_estimation.dart';

class DiagramEntity {
  final String id;
  final String name;
  final String imgUrl;
  final String imgRef;
  final DiagramEstimation? estimation;

  const DiagramEntity(
      {required this.id,
      required this.name,
      required this.imgRef,
      required this.imgUrl,
      this.estimation});

  factory DiagramEntity.fromJson(Map<String, dynamic> map) {
    return DiagramEntity(
        id: map['id'] as String,
        name: map['name'] as String,
        imgRef: map['imgRef'] as String,
        imgUrl: map['imgUrl'] as String,
        estimation: map['estimation'] != null
            ? DiagramEstimation.fromJson(
                (map['estimation'] as Map).cast<String, dynamic>())
            : null);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagramEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
