part of 'search_commands_bloc.dart';

@freezed
sealed class SearchCommandsEvent with _$SearchCommandsEvent {
  const factory SearchCommandsEvent.search(String query) = _Search;
}
