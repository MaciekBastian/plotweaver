import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../../project/domain/usecases/create_project_usecase.dart';
import '../../../../project/domain/usecases/open_project_usecase.dart';

part 'quick_start_bloc.freezed.dart';
part 'quick_start_event.dart';
part 'quick_start_state.dart';

class QuickStartBloc extends Bloc<QuickStartEvent, QuickStartState> {
  QuickStartBloc(
    this._openProjectUsecase,
    this._createProjectUsecase,
  ) : super(const _Initial()) {
    on<_OpenProject>(_onOpenProject);
    on<_CreateProject>(_onCreateProject);
  }

  final OpenProjectUsecase _openProjectUsecase;
  final CreateProjectUsecase _createProjectUsecase;

  Future<void> _onOpenProject(
    _OpenProject event,
    Emitter<QuickStartState> emit,
  ) async {
    emit(const _Locked());
    final res = await _openProjectUsecase.call();

    res.fold(
      (error) {
        emit(_Failure(error));
      },
      (value) {
        if (value == null) {
          emit(const _Initial());
        } else {
          emit(const _Success());
        }
      },
    );
  }

  Future<void> _onCreateProject(
    _CreateProject event,
    Emitter<QuickStartState> emit,
  ) async {
    emit(const _Locked());
    final res = await _createProjectUsecase.call(event.projectName);

    res.fold(
      (error) {
        emit(_Failure(error));
      },
      (value) {
        if (value == null) {
          emit(const _Initial());
        } else {
          emit(const _Success());
        }
      },
    );
  }
}
