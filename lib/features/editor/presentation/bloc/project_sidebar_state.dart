part of 'project_sidebar_bloc.dart';

@freezed
sealed class ProjectSidebarState with _$ProjectSidebarState {
  const factory ProjectSidebarState.visible({
    @Default(350.0) double width,
  }) = ProjectSidebarStateVisible;
  const factory ProjectSidebarState.hidden({
    @Default(350.0) double cachedWidth,
  }) = ProjectSidebarStateHidden;
}
