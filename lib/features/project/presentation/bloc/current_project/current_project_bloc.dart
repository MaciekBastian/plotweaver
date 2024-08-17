import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/config/sl_config.dart';
import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../../../core/extensions/dartz_extension.dart';
import '../../../../../core/handlers/error_handler.dart';
import '../../../../../shared/overlays/full_screen_alert.dart';
import '../../../../tabs/presentation/cubit/tabs_cubit.dart';
import '../../../../weave_file/domain/entities/save_intent_entity.dart';
import '../../../domain/entities/current_project_entity.dart';
import '../../../domain/usecases/roll_back_project_usecase.dart';

part 'current_project_bloc.freezed.dart';
part 'current_project_event.dart';
part 'current_project_state.dart';

class CurrentProjectBloc
    extends Bloc<CurrentProjectEvent, CurrentProjectState> {
  CurrentProjectBloc() : super(const _NoProject()) {
    on<_OpenProject>(_onOpenProject);
    on<_ToggleUnsavedChanges>(_onToggleUnsavedChanges);
    on<_Save>(_onSave);
    on<_RollBack>(_onRollBack);
  }

  Future<void> _onOpenProject(
    _OpenProject event,
    Emitter<CurrentProjectState> emit,
  ) async {
    emit(_Project(event.project));
  }

  Future<void> _onSave(
    _Save event,
    Emitter<CurrentProjectState> emit,
  ) async {
    if (state is _Project) {
      final changes = event.tabs ?? (state as _Project).project.unsavedTabsIds;

      final response = await handleVoidAsyncOperation(
        () async => Future.forEach(
          changes,
          (element) async {
            final project = (state as _Project).project;
            final resp = await sl<TabsCubit>().saveTab(
              element,
              (tab) {
                return tab.map(
                  projectTab: (value) => SaveIntentEntity(
                    path: project.path,
                    projectIdentifier: project.identifier,
                    saveProject: true,
                  ),
                  characterTab: (value) => SaveIntentEntity(
                    path: project.path,
                    projectIdentifier: project.identifier,
                  ),
                );
              },
            );

            event.afterEach?.call(
              !resp.isNone(),
              resp.isSome() ? resp.asSome() : null,
            );

            if (resp.isSome()) {
              if (event.afterEach == null) {
                showFullscreenError(resp.asSome());
              }
              throw resp.asSome();
            } else {
              final newUnsaved = [...project.unsavedTabsIds]
                ..removeWhere((el) => el == element);

              emit(_Project(project.copyWith(unsavedTabsIds: newUnsaved)));
            }
          },
        ),
      );
      event.then?.call(
        response.isNone(),
        response.isSome() ? response.asSome() : null,
      );
    }
  }

  Future<void> _onToggleUnsavedChanges(
    _ToggleUnsavedChanges event,
    Emitter<CurrentProjectState> emit,
  ) async {
    if (state is _Project) {
      final project = (state as _Project).project;

      final newUnsaved = [...project.unsavedTabsIds];

      if (project.unsavedTabsIds.contains(event.tabId)) {
        newUnsaved.removeWhere((el) => el == event.tabId);
      } else {
        newUnsaved.add(event.tabId);
        sl<TabsCubit>().markTabAsUnsaved(event.tabId);
      }

      emit(_Project(project.copyWith(unsavedTabsIds: newUnsaved)));
    }
  }

  Future<void> _onRollBack(
    _RollBack event,
    Emitter<CurrentProjectState> emit,
  ) async {
    if (state is _Project) {
      final changes = event.tabs ?? (state as _Project).project.unsavedTabsIds;

      final response = await handleVoidAsyncOperation(
        () async => Future.forEach(
          changes,
          (element) async {
            final tab = sl<TabsCubit>().getTab(element);
            if (tab == null) {
              throw const UnknownError();
            }
            final Option<PlotweaverError> rollbackResp = await tab.map(
              projectTab: (value) => sl<RollBackProjectUsecase>().call(
                (state as _Project).project.identifier,
              ),
              characterTab: (value) async => const None(),
            );
            if (rollbackResp.isSome()) {
              throw rollbackResp.asSome();
            }
            await _onSave(
              _Save(
                tabs: [element],
                then: event.afterEach,
              ),
              emit,
            );
          },
        ),
      );
      event.then?.call(
        response.isNone(),
        response.isSome() ? response.asSome() : null,
      );
    }
  }
}
