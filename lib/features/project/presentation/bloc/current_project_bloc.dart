import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/current_project_entity.dart';

part 'current_project_bloc.freezed.dart';
part 'current_project_event.dart';
part 'current_project_state.dart';

class CurrentProjectBloc
    extends Bloc<CurrentProjectEvent, CurrentProjectState> {
  CurrentProjectBloc() : super(const _NoProject()) {
    on<_OpenProject>(_onOpenProject);
  }

  Future<void> _onOpenProject(
    _OpenProject event,
    Emitter<CurrentProjectState> emit,
  ) async {
    emit(_Project(event.project));
  }
}
