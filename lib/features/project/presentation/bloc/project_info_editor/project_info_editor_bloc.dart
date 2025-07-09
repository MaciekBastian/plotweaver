import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../../../core/extensions/dartz_extension.dart';
import '../../../../weave_file/domain/entities/general_entity.dart';
import '../../../data/data_sources/project_data_source.dart';
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
  )   : _projectDataSource = ProjectDataSource(),
        super(const ProjectInfoEditorStateLoading()) {
    on<_Modify>(_onModify);
    on<_Setup>(_onSetup);
  }

  String? _identifier;

  final GetOpenedProjectUsecase _getOpenedProjectUsecase;
  final ModifyProjectUsecase _modifyProjectUsecase;
  final CurrentProjectBloc _currentProjectBloc;
  final ProjectDataSource _projectDataSource;

  void _onModify(_Modify event, Emitter<ProjectInfoEditorState> emit) {
    if (_identifier == null) {
      return;
    }
    _modifyProjectUsecase.call(_identifier!, event.project);
    _currentProjectBloc.add(
      CurrentProjectEvent.toggleUnsavedChangesForTab(event.tabId),
    );
    if (state is ProjectInfoEditorStateSuccess) {
      emit(
        ProjectInfoEditorStateModified(
          event.project,
          (state as ProjectInfoEditorStateSuccess).generalInfo,
        ),
      );
    } else if (state is ProjectInfoEditorStateModified) {
      emit(
        (state as ProjectInfoEditorStateModified).copyWith(
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
    if (state is ProjectInfoEditorStateLoading ||
        state is ProjectInfoEditorStateFailure ||
        event.force) {
      final general = await _projectDataSource.getGeneral(_identifier!);
      if (general.isLeft()) {
        emit(ProjectInfoEditorStateFailure(general.asLeft()));
      }
      final resp = await _getOpenedProjectUsecase.call(_identifier!);

      resp.fold(
        (error) {
          emit(ProjectInfoEditorStateFailure(error));
        },
        (project) {
          emit(ProjectInfoEditorStateSuccess(project, general.asRight()));
        },
      );
    }
  }
}
