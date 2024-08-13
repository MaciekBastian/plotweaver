part of 'current_project_bloc.dart';

@freezed
class CurrentProjectEvent with _$CurrentProjectEvent {
  const factory CurrentProjectEvent.openProject() = _OpenProject;
}
