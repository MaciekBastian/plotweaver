import 'package:injectable/injectable.dart';

import '../../../core/get_it/get_it.dart';
import '../../../domain/global/models/command.dart';
import '../../../domain/global/services/command_dispatcher.dart';
import '../../characters/cubit/characters_cubit.dart';
import '../../plots/cubit/plots_cubit.dart';
import '../../project/cubit/project_cubit.dart';
import '../cubit/view_cubit.dart';
import '../models/tab_model.dart';
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
        if (openedTab.type == TabType.character) {
          final hasUnsaved = getIt<CharactersCubit>().state.hasUnsavedChanges;
          return hasUnsaved;
        }
        if (openedTab.type == TabType.plot) {
          final hasUnsaved = getIt<PlotsCubit>().state.hasUnsavedChanges;
          return hasUnsaved;
        }
        return true;
      case PlotweaverCommand.delete:
        if (openedTab == null) {
          return false;
        }
        if (openedTab.type == TabType.character &&
            openedTab.associatedContentId != null) {
          return true;
        }
        if (openedTab.type == TabType.plot &&
            openedTab.associatedContentId != null) {
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
        if (openedTab.type == TabType.plot) {
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
          break;
        }
        if (openedTab.type == TabType.character) {
          await getIt<CharactersCubit>().save();
          break;
        }
        if (openedTab.type == TabType.plot) {
          await getIt<PlotsCubit>().save();
          break;
        }
        break;
      case PlotweaverCommand.delete:
        if (openedTab == null) {
          break;
        }
        if (openedTab.type == TabType.character &&
            openedTab.associatedContentId != null) {
          getIt<ViewCubit>().closeTab(openedTab.id);
          getIt<CharactersCubit>().delete(openedTab.associatedContentId!);
          break;
        }
        if (openedTab.type == TabType.plot &&
            openedTab.associatedContentId != null) {
          getIt<ViewCubit>().closeTab(openedTab.id);
          getIt<PlotsCubit>().delete(openedTab.associatedContentId!);
          break;
        }
        break;
      case PlotweaverCommand.add:
        if (openedTab == null) {
          break;
        }
        if (openedTab.type == TabType.character) {
          final character = getIt<CharactersCubit>().createNew();
          getIt<ViewCubit>().openTab(
            TabModel(
              id: 'character_${character.id}',
              title: character.name,
              type: TabType.character,
              associatedContentId: character.id,
            ),
          );
          break;
        }
        if (openedTab.type == TabType.plot) {
          final plot = getIt<PlotsCubit>().createNew();
          getIt<ViewCubit>().openTab(
            TabModel(
              id: 'character_${plot.id}',
              title: plot.name,
              type: TabType.plot,
              associatedContentId: plot.id,
            ),
          );
          break;
        }
        break;
    }
  }
}
