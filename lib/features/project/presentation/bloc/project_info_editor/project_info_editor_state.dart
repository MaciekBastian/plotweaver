part of 'project_info_editor_bloc.dart';

@freezed
class ProjectInfoEditorState with _$ProjectInfoEditorState {
  const factory ProjectInfoEditorState.loading() = _Loading;
  const factory ProjectInfoEditorState.success(ProjectEntity projectInfo) =
      _Success;
  const factory ProjectInfoEditorState.failure(PlotweaverError error) =
      _Failure;
  const factory ProjectInfoEditorState.modified(ProjectEntity projectInfo) =
      _Modified;
}
