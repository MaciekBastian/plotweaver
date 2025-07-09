part of 'project_files_cubit.dart';

@freezed
sealed class ProjectFilesState with _$ProjectFilesState {
  const factory ProjectFilesState.active({
    required String projectIdentifier,
    @Default([]) List<ProjectFileEntity> projectFiles,
  }) = ProjectFilesStateActive;
  const factory ProjectFilesState.loading() = ProjectFilesStateLoading;
}
