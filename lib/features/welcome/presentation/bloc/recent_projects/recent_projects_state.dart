part of 'recent_projects_bloc.dart';

@freezed
class RecentProjectsState with _$RecentProjectsState {
  const factory RecentProjectsState.initial() = _Initial;
  const factory RecentProjectsState.loading() = _Loading;
  const factory RecentProjectsState.empty() = _Empty;
  const factory RecentProjectsState.success(
    List<RecentProjectEntity> projects,
  ) = _Success;
  const factory RecentProjectsState.failure(PlotweaverError error) = _Failure;
}
