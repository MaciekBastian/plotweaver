part of 'project_cubit.dart';

@freezed
class ProjectState with _$ProjectState {
  factory ProjectState({
    FileSnippetModel? openedProject,
    @Default([]) List<FileSnippetModel> recent,
  }) = _ProjectState;
}
