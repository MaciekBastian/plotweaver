import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/overlays/full_screen_alert.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../../characters/presentation/bloc/characters_editors_bloc.dart';
import '../../../project/presentation/bloc/current_project/current_project_bloc.dart';
import '../../../project/presentation/cubit/project_files_cubit.dart';
import '../../domain/entities/tab_entity.dart';
import '../cubit/tabs_cubit.dart';
import 'tab_widget.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      color: context.colors.shadedBackgroundColor,
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, state) {
          final currentTab = state.openedTabId == null
              ? null
              : context.read<TabsCubit>().getTab(state.openedTabId!);

          return Row(
            children: [
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: state.openedTabs.map((tab) {
                    return TabWidget(
                      tab: tab,
                      isSelected: state.openedTabId == tab.tabId,
                      isUnsaved: state.unsavedTabsIds.contains(tab.tabId),
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 20,
                ),
                height: 35,
                decoration: BoxDecoration(
                  color: context.colors.topBarBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.overlaysBoxShadow.color,
                      spreadRadius: -15,
                      blurRadius: 10,
                      offset: const Offset(-15, 0),
                    ),
                  ],
                ),
                child: _TabBarToolbar(currentTab: currentTab),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabBarToolbar extends StatelessWidget {
  const _TabBarToolbar({
    this.currentTab,
  });

  final TabEntity? currentTab;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClickableWidget(
          onTap: () {},
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            child: Icon(
              CupertinoIcons.pin,
              size: 13,
              color: context.colors.link,
            ),
          ),
        ),
        if (currentTab != null && currentTab is CharacterTab)
          Builder(
            builder: (context) {
              final character = context
                  .read<CharactersEditorsBloc>()
                  .getCharacter((currentTab! as CharacterTab).characterId);
              if (character == null) {
                return const SizedBox.shrink();
              }
              return Row(
                children: [
                  ClickableWidget(
                    onTap: () {
                      showFullscreenAlert(
                        options: [
                          AlertOption(
                            callback: () {
                              Navigator.of(context).pop();
                              final currentProjectState =
                                  context.read<CurrentProjectBloc>().state;
                              final path = currentProjectState
                                      is CurrentProjectStateProject
                                  ? currentProjectState.project.path
                                  : null;
                              if (path == null) {
                                return;
                              }
                              context.read<CharactersEditorsBloc>().add(
                                    CharactersEditorsEvent.delete(
                                      characterId: character.id,
                                      projectFilePath: path,
                                      then: (error) {
                                        if (error != null) {
                                          showFullscreenError(error);
                                        } else {
                                          context
                                              .read<ProjectFilesCubit>()
                                              .checkAndLoadAllFiles();
                                        }
                                      },
                                    ),
                                  );
                            },
                            title: S.of(context).delete_character,
                            isDestructive: true,
                          ),
                          AlertOption(
                            callback: () {
                              Navigator.of(context).pop();
                            },
                            title: S.of(context).cancel,
                            isSeparated: true,
                          ),
                        ],
                        title: S
                            .of(context)
                            .do_you_want_to_delete_character(character.name),
                        description: S.of(context).this_action_is_irreversible,
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.delete_outline,
                        size: 15,
                        color: context.colors.link,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
