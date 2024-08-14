import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../domain/entities/project_entity.dart';
import '../../../domain/usecases/get_opened_project_usecase.dart';

part 'project_info_editor_bloc.freezed.dart';
part 'project_info_editor_event.dart';
part 'project_info_editor_state.dart';

class ProjectInfoEditorBloc
    extends Bloc<ProjectInfoEditorEvent, ProjectInfoEditorState> {
  ProjectInfoEditorBloc(this._getOpenedProjectUsecase)
      : super(const _Loading()) {
    on<_Modify>(_onModify);
    on<_Setup>(_onSetup);
  }

  final GetOpenedProjectUsecase _getOpenedProjectUsecase;

  void _onModify(_Modify event, Emitter<ProjectInfoEditorState> emit) {}

  Future<void> _onSetup(
    _Setup event,
    Emitter<ProjectInfoEditorState> emit,
  ) async {
    if (state is _Loading || state is _Failure) {
      final resp = await _getOpenedProjectUsecase.call(event.identifier);

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
