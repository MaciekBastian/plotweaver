part of 'tabs_cubit.dart';

@freezed
class TabsState with _$TabsState {
  const factory TabsState({
    @Default([]) List<TabEntity> openedTabs,
    @Default([]) List<String> unsavedTabsIds,
    String? openedTabId,
  }) = _TabsState;
}
