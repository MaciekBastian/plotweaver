part of 'project_cubit.dart';

@freezed
class ProjectState with _$ProjectState {
  factory ProjectState({
    @Default([]) List<FileSnippetModel> recent,
  }) = _ProjectState;
}
