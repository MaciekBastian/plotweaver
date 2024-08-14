import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_project_entity.freezed.dart';

@Freezed(
  fromJson: false,
  toJson: false,
)
class CurrentProjectEntity with _$CurrentProjectEntity {
  factory CurrentProjectEntity({
    required String projectName,
    required String identifier,
  }) = _CurrentProjectEntity;
}
