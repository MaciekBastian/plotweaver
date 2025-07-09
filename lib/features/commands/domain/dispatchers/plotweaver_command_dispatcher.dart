import 'package:flutter/material.dart';

import '../../../../core/config/sl_config.dart';
import '../../../tabs/domain/commands/actions/close_tab_action.dart';
import '../../../tabs/domain/commands/actions/open_tab_action.dart';
import '../../../tabs/domain/commands/actions/rollback_tab_action.dart';
import '../../../tabs/domain/commands/actions/save_tab_action.dart';
import '../../../tabs/domain/commands/actions/undo_tab_action.dart';
import '../../../tabs/domain/commands/tab_intent.dart';
import '../../../tabs/presentation/cubit/tabs_cubit.dart';

class PlotweaverCommandDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    final modifiedAction = _getAction(intent, action);
    return super.invokeAction(modifiedAction, intent, context);
  }

  @override
  (bool, Object?) invokeActionIfEnabled(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    final modifiedAction = _getAction(intent, action);
    return super.invokeActionIfEnabled(modifiedAction, intent, context);
  }

  Action<Intent> _getAction(Intent intent, Action defaultAction) {
    if (intent is TabIntent) {
      switch (intent) {
        case SaveTabIntent(:final tab):
          final tabsCubit = sl<TabsCubit>();
          final currentTabId = tabsCubit.state.openedTabId;
          final currentTab =
              currentTabId == null ? null : tabsCubit.getTab(currentTabId);

          return SaveTabAction(tab ?? currentTab);
        case RollbackTabIntent(:final tab):
          final tabsCubit = sl<TabsCubit>();
          final currentTabId = tabsCubit.state.openedTabId;
          final currentTab =
              currentTabId == null ? null : tabsCubit.getTab(currentTabId);

          return RollbackTabAction(tab ?? currentTab);
        case CloseTabIntent(:final tab):
          final tabsCubit = sl<TabsCubit>();
          final currentTabId = tabsCubit.state.openedTabId;
          final currentTab =
              currentTabId == null ? null : tabsCubit.getTab(currentTabId);

          return CloseTabAction(tab ?? currentTab);
        case OpenTabIntent(:final tab):
          return OpenTabAction(tab);
        case UndoTabIntent(:final tab):
          final tabsCubit = sl<TabsCubit>();
          final currentTabId = tabsCubit.state.openedTabId;
          final currentTab =
              currentTabId == null ? null : tabsCubit.getTab(currentTabId);

          return UndoTabAction(tab ?? currentTab);
      }
    }

    return defaultAction;
  }
}
