part of 'project_info_editor_bloc.dart';

@freezed
sealed class ProjectInfoEditorState with _$ProjectInfoEditorState {
  const factory ProjectInfoEditorState.loading() =
      ProjectInfoEditorStateLoading;
  const factory ProjectInfoEditorState.success(
    ProjectEntity projectInfo,
    GeneralEntity generalInfo,
  ) = ProjectInfoEditorStateSuccess;
  const factory ProjectInfoEditorState.failure(PlotweaverError error) =
      ProjectInfoEditorStateFailure;
  const factory ProjectInfoEditorState.modified(
    ProjectEntity projectInfo,
    GeneralEntity generalInfo,
  ) = ProjectInfoEditorStateModified;
}
