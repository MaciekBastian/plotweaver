import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../domain/entities/project_entity.dart';
import '../../../domain/usecases/get_opened_project_usecase.dart';
import '../../../domain/usecases/modify_project_usecase.dart';
import '../current_project/current_project_bloc.dart';

part 'project_info_editor_bloc.freezed.dart';
part 'project_info_editor_event.dart';
part 'project_info_editor_state.dart';

class ProjectInfoEditorBloc
    extends Bloc<ProjectInfoEditorEvent, ProjectInfoEditorState> {
  ProjectInfoEditorBloc(
    this._getOpenedProjectUsecase,
    this._modifyProjectUsecase,
    this._currentProjectBloc,
  ) : super(const _Loading()) {
    on<_Modify>(_onModify);
    on<_Setup>(_onSetup);
  }

  String? _identifier;

  final GetOpenedProjectUsecase _getOpenedProjectUsecase;
  final ModifyProjectUsecase _modifyProjectUsecase;
  final CurrentProjectBloc _currentProjectBloc;

  void _onModify(_Modify event, Emitter<ProjectInfoEditorState> emit) {
    if (_identifier == null) {
      return;
    }
    _modifyProjectUsecase.call(_identifier!, event.project);
    _currentProjectBloc.add(
      CurrentProjectEvent.toggleUnsavedChangesForTab(event.tabId),
    );
    if (state is _Success) {
      emit(_Modified(event.project));
    } else if (state is _Modified) {
      emit(
        (state as _Modified).copyWith(
          projectInfo: event.project,
        ),
      );
    }
  }

  Future<void> _onSetup(
    _Setup event,
    Emitter<ProjectInfoEditorState> emit,
  ) async {
    _identifier ??= event.identifier;
    if (_identifier == null) {
      return;
    }
    if (state is _Loading || state is _Failure || event.force) {
      final resp = await _getOpenedProjectUsecase.call(_identifier!);

      resp.fold(
        (error) {
          emit(_Failure(error));
        },
        (project) {
          emit(_Success(project));
        },
      );
    }
  }
}
