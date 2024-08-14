part of 'tabs_cubit.dart';

@freezed
class TabsState with _$TabsState {
  const factory TabsState({
    @Default([]) List<TabEntity> openedTabs,
    String? openedTabId,
  }) = _TabsState;
}
