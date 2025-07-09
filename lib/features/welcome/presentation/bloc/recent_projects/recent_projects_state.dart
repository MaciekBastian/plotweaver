part of 'recent_projects_bloc.dart';

@freezed
sealed class RecentProjectsState with _$RecentProjectsState {
  const factory RecentProjectsState.initial() = RecentProjectsStateInitial;
  const factory RecentProjectsState.loading() = RecentProjectsStateLoading;
  const factory RecentProjectsState.empty() = RecentProjectsStateEmpty;
  const factory RecentProjectsState.success(
    List<RecentProjectEntity> projects,
  ) = RecentProjectsStateSuccess;
  const factory RecentProjectsState.failure(PlotweaverError error) =
      RecentProjectsStateFailure;
}
