import 'package:injectable/injectable.dart';

import '../../../core/get_it/get_it.dart';
import '../../../domain/global/models/command.dart';
import '../../../domain/global/services/command_dispatcher.dart';
import '../../project/cubit/project_cubit.dart';
import '../cubit/view_cubit.dart';
import '../models/tab_type.dart';

@LazySingleton(as: CommandDispatcher)
class CommandDispatcherImpl implements CommandDispatcher {
  @override
  bool isCommandAvailable(PlotweaverCommand command) {
    final openedTab = getIt<ViewCubit>().currentTab;
    switch (command) {
      case PlotweaverCommand.save:
        if (openedTab == null) {
          return false;
        }
        if (openedTab.type == TabType.project) {
          final hasUnsaved = getIt<ProjectCubit>().state.hasUnsavedChanges;
          return hasUnsaved;
        }
        return true;
      case PlotweaverCommand.delete:
        if (openedTab == null) {
          return false;
        }
        if (openedTab.type == TabType.character) {
          return true;
        }
        return false;
      case PlotweaverCommand.add:
        if (openedTab == null) {
          return false;
        }
        if (openedTab.type == TabType.character) {
          return true;
        }
        return false;
    }
  }

  @override
  Future<void> sendIntent(PlotweaverCommand command) async {
    final openedTab = getIt<ViewCubit>().currentTab;
    switch (command) {
      case PlotweaverCommand.save:
        if (openedTab == null) {
          break;
        }
        if (openedTab.type == TabType.project) {
          await getIt<ProjectCubit>().save();
        }
        break;
      case PlotweaverCommand.delete:
        // TODO: implement
        break;
      case PlotweaverCommand.add:
        // TODO: implement
        break;
    }
  }
}
