import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_project_entity.freezed.dart';
part 'recent_project_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
@Freezed(fromJson: false, toJson: false)
class RecentProjectEntity with _$RecentProjectEntity {
  factory RecentProjectEntity({
    required String path,
    required String projectName,
    required DateTime lastAccess,
  }) = _RecentProjectEntity;

  const RecentProjectEntity._();

  factory RecentProjectEntity.placeholder() => _RecentProjectEntity(
        path: List.generate(32, (i) => i.toString()).join(),
        projectName: List.generate(10, (i) => i.toString()).join(),
        lastAccess: DateTime(2000),
      );

  factory RecentProjectEntity.fromJson(Map<String, dynamic> json) =>
      _$RecentProjectEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RecentProjectEntityToJson(this);
}
