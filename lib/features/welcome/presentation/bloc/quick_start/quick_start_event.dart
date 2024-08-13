part of 'quick_start_bloc.dart';

@freezed
class QuickStartEvent with _$QuickStartEvent {
  const factory QuickStartEvent.openProject([RecentProjectEntity? recent]) =
      _OpenProject;
  const factory QuickStartEvent.createProject(String projectName) =
      _CreateProject;
}
