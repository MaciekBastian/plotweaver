part of 'search_commands_bloc.dart';

@freezed
sealed class SearchCommandsState with _$SearchCommandsState {
  const factory SearchCommandsState({
    @Default([]) List<SearchCommandSuggestion> suggestions,
  }) = _SearchCommandsState;
}
