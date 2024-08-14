import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/tab_entity.dart';

part 'tabs_cubit.freezed.dart';
part 'tabs_state.dart';

class TabsCubit extends Cubit<TabsState> {
  TabsCubit() : super(const TabsState());

  void openTab(TabEntity tab) {
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
        late String newId;
        if (newTabs.length >= tabIndex) {
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
}
