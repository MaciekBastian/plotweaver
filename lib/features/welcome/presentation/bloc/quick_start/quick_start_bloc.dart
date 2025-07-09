import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../../project/domain/entities/project_entity.dart';
import '../../../../project/domain/usecases/create_project_usecase.dart';
import '../../../../project/domain/usecases/open_project_usecase.dart';
import '../../../domain/entities/recent_project_entity.dart';
import '../../../domain/usecases/delete_recent_usecase.dart';

part 'quick_start_bloc.freezed.dart';
part 'quick_start_event.dart';
part 'quick_start_state.dart';

class QuickStartBloc extends Bloc<QuickStartEvent, QuickStartState> {
  QuickStartBloc(
    this._openProjectUsecase,
    this._createProjectUsecase,
    this._deleteRecentUsecase,
  ) : super(const QuickStartStateInitial()) {
    on<_OpenProject>(_onOpenProject);
    on<_CreateProject>(_onCreateProject);
  }

  final OpenProjectUsecase _openProjectUsecase;
  final CreateProjectUsecase _createProjectUsecase;
  final DeleteRecentUsecase _deleteRecentUsecase;

  Future<void> _onOpenProject(
    _OpenProject event,
    Emitter<QuickStartState> emit,
  ) async {
    emit(QuickStartStateLocked(event.recent == null));
    final res = await _openProjectUsecase.call(event.recent?.path);

    await res.fold(
      (error) async {
        if (error is IOError && event.recent != null) {
          switch (error) {
            case IOParseError():
              break;
            case IOFileDoesNotExist():
              await _deleteRecentUsecase.call(event.recent!);
              break;
            case IOUnknownError():
              break;
          }
        }
        emit(QuickStartStateFailure(error));
      },
      (value) {
        if (value == null) {
          emit(const QuickStartStateInitial());
        } else {
          emit(QuickStartStateSuccess(value.$1, value.$2, value.$3));
        }
      },
    );
  }

  Future<void> _onCreateProject(
    _CreateProject event,
    Emitter<QuickStartState> emit,
  ) async {
    emit(const QuickStartStateLocked(true));
    final res = await _createProjectUsecase.call(event.projectName);

    res.fold(
      (error) {
        emit(QuickStartStateFailure(error));
      },
      (value) {
        if (value == null) {
          emit(const QuickStartStateInitial());
        } else {
          emit(QuickStartStateSuccess(value.$1, value.$2, value.$3));
        }
      },
    );
  }
}
