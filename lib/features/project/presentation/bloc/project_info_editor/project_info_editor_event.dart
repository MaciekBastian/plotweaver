part of 'project_info_editor_bloc.dart';

@freezed
class ProjectInfoEditorEvent with _$ProjectInfoEditorEvent {
  const factory ProjectInfoEditorEvent.modify(ProjectEntity project) = _Modify;
  const factory ProjectInfoEditorEvent.setup(String identifier) = _Setup;
}
