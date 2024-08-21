import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../weave_file/domain/entities/save_intent_entity.dart';
import '../../../weave_file/domain/usecases/consolidate_and_save_weave_file_usecase.dart';
import '../../domain/entities/tab_entity.dart';

part 'tabs_cubit.freezed.dart';
part 'tabs_state.dart';

@LazySingleton()
class TabsCubit extends Cubit<TabsState> {
  TabsCubit(this._saveWeaveFileUsecase) : super(const TabsState());

  final ConsolidateAndSaveWeaveFileUsecase _saveWeaveFileUsecase;

  void openTab(TabEntity tab) {
    if (state.openedTabId == tab.tabId) {
      return;
    }
    if (state.openedTabs.any((el) => el.tabId == tab.tabId)) {
      emit(state.copyWith(openedTabId: tab.tabId));
    } else {
      emit(
        state.copyWith(
          openedTabId: tab.tabId,
          openedTabs: [...state.openedTabs, tab],
        ),
      );
    }
  }

  void closeTab(TabEntity tab) {
    if (state.openedTabs.any((el) => el.tabId == tab.tabId)) {
      final tabIndex =
          state.openedTabs.indexWhere((el) => el.tabId == tab.tabId);
      final newTabs = [...state.openedTabs]..removeAt(tabIndex);
      if (newTabs.isEmpty) {
        emit(const TabsState());
      } else {
        String? newId;
        if (tabIndex == 0) {
          newId = newTabs[0].tabId;
        } else if (newTabs.length >= tabIndex) {
          newId = newTabs[tabIndex - 1].tabId;
        } else {
          newId = newTabs[tabIndex].tabId;
        }
        emit(
          state.copyWith(
            openedTabs: newTabs,
            openedTabId: newId,
          ),
        );
      }
    }
  }

  TabEntity? getTab(String tabId) =>
      state.openedTabs.where((el) => el.tabId == tabId).firstOrNull;

  Future<Option<PlotweaverError>> saveTab(
    String tabId,
    SaveIntentEntity Function(TabEntity tab) getSaveIntent,
  ) async {
    final tab = state.openedTabs.where((el) => el.tabId == tabId).firstOrNull;

    if (tab != null) {
      final resp = await _saveWeaveFileUsecase.call(
        saveIntent: getSaveIntent(tab),
      );
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
    }
    final newUnsaved = [...state.unsavedTabsIds]..remove(tabId);
    emit(state.copyWith(unsavedTabsIds: newUnsaved));
    return const None();
  }

  void markTabAsUnsaved(String tabId) {
    if (state.unsavedTabsIds.contains(tabId)) {
      return;
    }
    final newUnsaved = [...state.unsavedTabsIds, tabId];
    emit(state.copyWith(unsavedTabsIds: newUnsaved));
  }
}
