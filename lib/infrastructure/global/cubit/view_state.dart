part of 'view_cubit.dart';

@freezed
class ViewState with _$ViewState {
  factory ViewState({
    String? currentTabId,
    @Default([]) List<TabModel> openedTabs,
  }) = _ViewState;
}
