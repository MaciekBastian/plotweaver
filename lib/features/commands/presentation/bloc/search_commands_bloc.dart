import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/search_command_suggestion.dart';

part 'search_commands_bloc.freezed.dart';
part 'search_commands_event.dart';
part 'search_commands_state.dart';

class SearchCommandsBloc
    extends Bloc<SearchCommandsEvent, SearchCommandsState> {
  SearchCommandsBloc() : super(const _SearchCommandsState()) {
    on<_Search>(_onSearch);
  }

  void _onSearch(_Search event, Emitter<SearchCommandsState> emit) {
    // TODO:
  }
}
