part of 'plots_cubit.dart';

@freezed
class PlotsState with _$PlotsState {
  factory PlotsState({
    @Default(false) bool hasUnsavedChanges,
    @Default([]) List<PlotModel> openedPlots,
    @Default([]) List<PlotSnippet> plots,
  }) = _PlotsState;
}
