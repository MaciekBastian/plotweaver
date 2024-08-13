import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_sidebar_bloc.freezed.dart';
part 'project_sidebar_event.dart';
part 'project_sidebar_state.dart';

class ProjectSidebarBloc
    extends Bloc<ProjectSidebarEvent, ProjectSidebarState> {
  ProjectSidebarBloc() : super(const _Visible()) {
    on<_ChangeWidth>(_onChangeWidth);
    on<_ToggleVisibility>(_onToggleVisibility);
  }

  void _onChangeWidth(_ChangeWidth event, Emitter<ProjectSidebarState> emit) {
    if (state is _Visible) {
      emit(_Visible(width: event.width));
    } else {
      emit(_Hidden(cachedWidth: event.width));
    }
  }

  void _onToggleVisibility(
    _ToggleVisibility event,
    Emitter<ProjectSidebarState> emit,
  ) {
    // TODO: visibility change
  }
}
