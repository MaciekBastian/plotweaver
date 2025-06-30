import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_project_entity.freezed.dart';

@Freezed(fromJson: false, toJson: false)
sealed class RecentProjectEntity with _$RecentProjectEntity {
  const factory RecentProjectEntity({
    required String path,
    required String projectName,
    required DateTime lastAccess,
  }) = _RecentProjectEntity;

  factory RecentProjectEntity.placeholder() => _RecentProjectEntity(
        path: List.generate(32, (i) => i.toString()).join(),
        projectName: List.generate(10, (i) => i.toString()).join(),
        lastAccess: DateTime(2000),
      );

  factory RecentProjectEntity.fromJson(Map<String, dynamic> json) =>
      _RecentProjectEntity(
        path: json['path'],
        projectName: json['project_name'],
        lastAccess: DateTime.parse(json['last_access'] as String),
      );

  const RecentProjectEntity._();

  Map<String, dynamic> toJson() => {
        'path': path,
        'project_name': projectName,
        'last_access': lastAccess.toIso8601String(),
      };
}
