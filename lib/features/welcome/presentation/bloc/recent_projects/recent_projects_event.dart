part of 'recent_projects_bloc.dart';

@freezed
class RecentProjectsEvent with _$RecentProjectsEvent {
  const factory RecentProjectsEvent.loadRecent() = _LoadRecent;
}
