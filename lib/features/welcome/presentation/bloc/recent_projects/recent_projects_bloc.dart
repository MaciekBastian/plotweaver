import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../domain/entities/recent_project_entity.dart';
import '../../../domain/usecases/load_recent_usecase.dart';

part 'recent_projects_bloc.freezed.dart';
part 'recent_projects_event.dart';
part 'recent_projects_state.dart';

class RecentProjectsBloc
    extends Bloc<RecentProjectsEvent, RecentProjectsState> {
  RecentProjectsBloc(this._loadRecentUsecase) : super(const _Initial()) {
    on<_LoadRecent>(_onLoadRecent);
  }

  final LoadRecentUsecase _loadRecentUsecase;

  Future<void> _onLoadRecent(
    _LoadRecent e,
    Emitter<RecentProjectsState> emit,
  ) async {
    if (state is _Loading) {
      return;
    }
    emit(const _Loading());

    final resp = await _loadRecentUsecase.call();

    resp.fold(
      (error) {
        emit(_Failure(error));
      },
      (projects) {
        if (projects.isEmpty) {
          emit(const _Empty());
        } else {
          emit(_Success(projects));
        }
      },
    );
  }
}
