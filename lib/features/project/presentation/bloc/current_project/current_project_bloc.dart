import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/config/sl_config.dart';
import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../../../core/extensions/dartz_extension.dart';
import '../../../../../core/handlers/error_handler.dart';
import '../../../../../shared/overlays/full_screen_alert.dart';
import '../../../../characters/domain/usecases/rollback_character_usecase.dart';
import '../../../../tabs/domain/entities/tab_entity.dart';
import '../../../../tabs/presentation/cubit/tabs_cubit.dart';
import '../../../../weave_file/domain/entities/save_intent_entity.dart';
import '../../../domain/entities/current_project_entity.dart';
import '../../../domain/usecases/roll_back_project_usecase.dart';

part 'current_project_bloc.freezed.dart';
part 'current_project_event.dart';
part 'current_project_state.dart';

class CurrentProjectBloc
    extends Bloc<CurrentProjectEvent, CurrentProjectState> {
  CurrentProjectBloc() : super(const CurrentProjectStateNoProject()) {
    on<_OpenProject>(_onOpenProject);
    on<_ToggleUnsavedChanges>(_onToggleUnsavedChanges);
    on<_Save>(_onSave);
    on<_RollBack>(_onRollBack);
  }

  Future<void> _onOpenProject(
    _OpenProject event,
    Emitter<CurrentProjectState> emit,
  ) async {
    emit(CurrentProjectStateProject(event.project));
  }

  Future<void> _onSave(
    _Save event,
    Emitter<CurrentProjectState> emit,
  ) async {
    if (state is CurrentProjectStateProject) {
      final changes = event.tabs ??
          (state as CurrentProjectStateProject).project.unsavedTabsIds;

      final response = await handleVoidAsyncOperation(
        () async => Future.forEach(
          changes,
          (element) async {
            final project = (state as CurrentProjectStateProject).project;
            final resp = await sl<TabsCubit>().saveTab(
              element,
              (tab) {
                return switch (tab) {
                  ProjectTab() => SaveIntentEntity(
                      path: project.path,
                      projectIdentifier: project.identifier,
                      saveProject: true,
                    ),
                  CharacterTab(:final characterId) => SaveIntentEntity(
                      path: project.path,
                      projectIdentifier: project.identifier,
                      saveCharactersIds: [characterId],
                    ),
                };
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

              emit(
                CurrentProjectStateProject(
                  project.copyWith(unsavedTabsIds: newUnsaved),
                ),
              );
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
    if (state is CurrentProjectStateProject) {
      final project = (state as CurrentProjectStateProject).project;

      final newUnsaved = [...project.unsavedTabsIds];

      if (project.unsavedTabsIds.contains(event.tabId)) {
        newUnsaved.removeWhere((el) => el == event.tabId);
      } else {
        newUnsaved.add(event.tabId);
        sl<TabsCubit>().markTabAsUnsaved(event.tabId);
      }

      emit(
        CurrentProjectStateProject(
          project.copyWith(unsavedTabsIds: newUnsaved),
        ),
      );
    }
  }

  Future<void> _onRollBack(
    _RollBack event,
    Emitter<CurrentProjectState> emit,
  ) async {
    if (state is CurrentProjectStateProject) {
      final changes = event.tabs ??
          (state as CurrentProjectStateProject).project.unsavedTabsIds;

      final response = await handleVoidAsyncOperation(
        () async => Future.forEach(
          changes,
          (element) async {
            final tab = sl<TabsCubit>().getTab(element);
            if (tab == null) {
              throw const UnknownError();
            }
            final Option<PlotweaverError> rollbackResp = await switch (tab) {
              ProjectTab() => sl<RollBackProjectUsecase>().call(
                  (state as CurrentProjectStateProject).project.identifier,
                ),
              CharacterTab(:final characterId) =>
                sl<RollbackCharacterUsecase>().call(
                  projectIdentifier:
                      (state as CurrentProjectStateProject).project.identifier,
                  characterId: characterId,
                ),
            };
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
