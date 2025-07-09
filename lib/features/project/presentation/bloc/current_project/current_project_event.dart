part of 'current_project_bloc.dart';

@freezed
class CurrentProjectEvent with _$CurrentProjectEvent {
  const factory CurrentProjectEvent.openProject(CurrentProjectEntity project) =
      _OpenProject;

  const factory CurrentProjectEvent.save({
    required List<String>? tabs,
    void Function(bool wasSaveSuccessful, PlotweaverError? error)? then,
    void Function(bool wasSaveSuccessful, PlotweaverError? error)? afterEach,
  }) = _Save;

  const factory CurrentProjectEvent.rollBack({
    required List<String>? tabs,
    void Function(bool wasSaveSuccessful, PlotweaverError? error)? then,
    void Function(bool wasSaveSuccessful, PlotweaverError? error)? afterEach,
  }) = _RollBack;

  const factory CurrentProjectEvent.toggleUnsavedChangesForTab(String tabId) =
      _ToggleUnsavedChanges;
}
