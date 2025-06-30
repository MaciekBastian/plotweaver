import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/file_bundle_type.dart';

part 'project_file_entity.freezed.dart';

@Freezed(
  toJson: false,
  fromJson: false,
)
sealed class ProjectFileEntity with _$ProjectFileEntity {
  factory ProjectFileEntity.projectFile() = ProjectFileEntityProjectFile;

  factory ProjectFileEntity.characterFile({
    required String characterId,
  }) = ProjectFileEntityCharacterFile;

  factory ProjectFileEntity.placeholder() = ProjectFileEntityPlaceholder;

  factory ProjectFileEntity.fileBundle({
    required List<ProjectFileEntity> files,
    required FileBundleType type,
  }) = ProjectFileEntityFileBundle;

  const ProjectFileEntity._();
}
