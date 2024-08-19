part of 'project_sidebar_bloc.dart';

@freezed
class ProjectSidebarEvent with _$ProjectSidebarEvent {
  const factory ProjectSidebarEvent.toggleVisibility() = _ToggleVisibility;
  const factory ProjectSidebarEvent.changeWidth(double width) = _ChangeWidth;
}
