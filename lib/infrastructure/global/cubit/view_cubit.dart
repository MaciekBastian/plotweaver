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

  void openProjectTab() {
    openTab(
      TabModel(
        id: 'project',
        title: LocaleKeys.home_project.tr(),
        type: TabType.project,
      ),
    );
  }

  void openTab(TabModel tab) {
    if (state.openedTabs.any((element) => element.id == tab.id)) {
      emit(state.copyWith(currentTabId: tab.id));
      return;
    }
    final tabs = [...state.openedTabs, tab];
    emit(state.copyWith(currentTabId: tab.id, openedTabs: tabs));
  }

  void closeTab(String tabId) {
    if (state.openedTabs.any((element) => element.id == tabId)) {
      final index = state.openedTabs.indexWhere((el) => el.id == tabId);
      final newOpenedTabs = [...state.openedTabs]..removeAt(index);
      if (newOpenedTabs.isEmpty) {
        emit(ViewState(currentTabId: null, openedTabs: []));
      } else {
        final newOpened = newOpenedTabs.length == index
            ? newOpenedTabs[newOpenedTabs.length - 1]
            : newOpenedTabs[index];
        emit(
          state.copyWith(
            openedTabs: newOpenedTabs,
            currentTabId: newOpened.id,
          ),
        );
      }
    }
  }
}
