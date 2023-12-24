part of 'project_cubit.dart';

@freezed
class ProjectState with _$ProjectState {
  factory ProjectState({
    FileSnippetModel? openedProject,
    ProjectInfoModel? projectInfo,
    @Default(false) bool hasUnsavedChanges,
    @Default([]) List<FileSnippetModel> recent,
  }) = _ProjectState;
}
