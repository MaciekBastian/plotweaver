import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../generated/locale_keys.g.dart';
import '../models/tab_model.dart';
import '../models/tab_type.dart';

part 'view_state.dart';
part 'view_cubit.freezed.dart';

@singleton
class ViewCubit extends Cubit<ViewState> {
  ViewCubit() : super(ViewState());

  TabModel? get currentTab {
    if (state.currentTabId == null) {
      return null;
    } else {
      return state.openedTabs.firstWhere((tab) => tab.id == state.currentTabId);
    }
  }

  String openProjectTab() {
    openTab(
      TabModel(
        id: 'project',
        title: LocaleKeys.home_project.tr(),
        type: TabType.project,
      ),
    );
    return 'project';
  }

  void openTab(TabModel tab) {
    if (currentTab?.id == tab.id) {
      leavePreviewState(tab.id);
      return;
    }
    if (state.openedTabs.any((element) => element.id == tab.id)) {
      emit(state.copyWith(currentTabId: tab.id));
      return;
    }
    final currentIndex = state.openedTabs.indexWhere(
      (el) => el.id == currentTab?.id,
    );
    late int index;
    if (currentTab == null || currentIndex == -1) {
      index = 0;
    } else if (currentTab!.isPreview) {
      index = currentIndex;
    } else {
      index = currentIndex + 1;
    }

    final tabs = [...state.openedTabs]
      ..removeWhere((element) => element.isPreview)
      ..insert(index, tab);

    emit(state.copyWith(currentTabId: tab.id, openedTabs: tabs));
  }

  void closeTab(String tabId) {
    if (state.openedTabs.any((element) => element.id == tabId)) {
      final index = state.openedTabs.indexWhere((el) => el.id == tabId);
      final newOpenedTabs = [...state.openedTabs]..removeAt(index);
      if (newOpenedTabs.isEmpty) {
        emit(ViewState());
        openProjectTab();
      } else {
        final newCurrent = switchToNewTabBeforeClosing(tabId);
        emit(
          state.copyWith(openedTabs: newOpenedTabs, currentTabId: newCurrent),
        );
      }
    }
  }

  void closeOtherTabs() {
    if (state.openedTabs.length > 1) {
      final tab = currentTab;
      if (tab == null) {
        return;
      }
      final pinnedTabs =
          state.openedTabs.where((element) => element.isPinned).toList();
      emit(
        ViewState(
          currentTabId: tab.id,
          openedTabs: {...pinnedTabs, tab}.toList(),
        ),
      );
    }
  }

  String? switchToNewTabBeforeClosing(String tabId) {
    if (state.openedTabs.any((element) => element.id == tabId)) {
      final index = state.openedTabs.indexWhere((el) => el.id == tabId);
      final newOpenedTabs = [...state.openedTabs]..removeAt(index);
      if (newOpenedTabs.isEmpty) {
        return openProjectTab();
      } else {
        final newOpened = newOpenedTabs.length == index
            ? newOpenedTabs[newOpenedTabs.length - 1]
            : newOpenedTabs[index];
        final newCurrent =
            state.currentTabId != tabId ? state.currentTabId : newOpened.id;
        emit(state.copyWith(currentTabId: newCurrent));
        return newCurrent;
      }
    } else {
      return null;
    }
  }

  void changeTabOrder(int oldIndex, int newIndex) {
    final newOpened = [...state.openedTabs];
    final removed = newOpened.removeAt(oldIndex);
    newOpened.insert(newIndex, removed.copyWith(isPreview: false));

    emit(
      state.copyWith(
        openedTabs: newOpened,
        currentTabId: removed.id,
      ),
    );
  }

  void leavePreviewState([String? tabId]) {
    if (tabId == null) {
      if (state.currentTabId == null) {
        return;
      } else {
        tabId = state.currentTabId;
      }
    }
    final tab = state.openedTabs.where((el) => el.id == tabId).firstOrNull;
    if (tab == null) {
      return;
    }
    if (!tab.isPreview) {
      return;
    }
    final newTab = tab.copyWith(isPreview: false);
    final index = state.openedTabs.indexOf(tab);
    final newOpenedTabs = [...state.openedTabs]
      ..remove(tab)
      ..insert(index, newTab);

    emit(state.copyWith(openedTabs: newOpenedTabs));
  }

  void toggleCurrentTabPinState() {
    final tab = currentTab;
    if (tab != null) {
      final index = state.openedTabs.indexOf(tab);
      if (index.isNegative) {
        return;
      }
      final newOpened = [...state.openedTabs]
        ..removeAt(index)
        ..insert(
          tab.isPinned ? index : 0,
          tab.copyWith(isPinned: !tab.isPinned, isPreview: false),
        );
      emit(state.copyWith(openedTabs: newOpened));
    }
  }
}
