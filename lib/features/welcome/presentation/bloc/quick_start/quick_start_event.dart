part of 'quick_start_bloc.dart';

@freezed
class QuickStartEvent with _$QuickStartEvent {
  const factory QuickStartEvent.openProject() = _OpenProject;
}
