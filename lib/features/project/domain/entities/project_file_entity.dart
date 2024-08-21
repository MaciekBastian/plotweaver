import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/file_bundle_type.dart';

part 'project_file_entity.freezed.dart';

@Freezed(
  toJson: false,
  fromJson: false,
)
class ProjectFileEntity with _$ProjectFileEntity {
  factory ProjectFileEntity.projectFile() = _ProjectFile;

  factory ProjectFileEntity.characterFile({
    required String characterId,
  }) = _CharacterFile;

  factory ProjectFileEntity.placeholder() = _Placeholder;

  factory ProjectFileEntity.fileBundle({
    required List<ProjectFileEntity> files,
    required FileBundleType type,
  }) = _FileBundle;

  const ProjectFileEntity._();
}
