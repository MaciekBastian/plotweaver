part of 'project_files_cubit.dart';

@freezed
class ProjectFilesState with _$ProjectFilesState {
  const factory ProjectFilesState.active({
    required String projectIdentifier,
    @Default([]) List<ProjectFileEntity> projectFiles,
  }) = _Active;
  const factory ProjectFilesState.loading() = _Loading;
}
