part of 'project_sidebar_bloc.dart';

@freezed
class ProjectSidebarState with _$ProjectSidebarState {
  const factory ProjectSidebarState.visible({
    @Default(350.0) double width,
  }) = _Visible;
  const factory ProjectSidebarState.hidden({
    @Default(350.0) double cachedWidth,
  }) = _Hidden;
}
