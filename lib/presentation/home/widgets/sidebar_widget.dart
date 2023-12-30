import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../domain/characters/models/character_snippet.dart';
import '../../../domain/fragments/extensions/list_fragments_extension.dart';
import '../../../domain/fragments/models/fragment_snippet.dart';
import '../../../domain/plots/models/plot_snippet.dart';
import '../../../domain/project/models/project_template.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../infrastructure/characters/cubit/characters_cubit.dart';
import '../../../infrastructure/fragments/cubit/fragments_cubit.dart';
import '../../../infrastructure/global/cubit/view_cubit.dart';
import '../../../infrastructure/global/models/tab_model.dart';
import '../../../infrastructure/global/models/tab_type.dart';
import '../../../infrastructure/plots/cubit/plots_cubit.dart';
import '../../../infrastructure/project/cubit/project_cubit.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: in the future, wrap with multiple bloc builders for characters, fragments etc.
    return BlocBuilder<ViewCubit, ViewState>(
      bloc: BlocProvider.of<ViewCubit>(context),
      builder: (context, viewState) {
        return BlocBuilder<FragmentsCubit, FragmentsState>(
          bloc: BlocProvider.of<FragmentsCubit>(context),
          builder: (context, fragmentsState) {
            return BlocBuilder<PlotsCubit, PlotsState>(
              bloc: BlocProvider.of<PlotsCubit>(context),
              builder: (context, plotsState) {
                return BlocBuilder<CharactersCubit, CharactersState>(
                  bloc: BlocProvider.of<CharactersCubit>(context),
                  builder: (context, charactersState) {
                    final characters = [...charactersState.characters]
                      ..sort((a, b) => a.name.compareTo(b.name));

                    final plots = [...plotsState.plots]
                      ..sort((a, b) => a.name.compareTo(b.name));

                    final fragments = [...fragmentsState.fragments]
                        .getFragments()
                      ..sort((a, b) => a.number.compareTo(b.number));

                    final tabs = [
                      // data not specified, as opening this tab is handled by the cubit
                      TabModel(id: '', title: '', type: TabType.project),
                      if (charactersState.characters.isEmpty)
                        // data not specified, without content id this is treated as create new character button
                        TabModel(id: '', title: '', type: TabType.character)
                      else
                        ...characters
                            .map(
                              (e) => TabModel(
                                id: 'character_${e.id}',
                                title: e.name,
                                type: TabType.character,
                                associatedContentId: e.id,
                              ),
                            )
                            .toList(),
                      if (plotsState.plots.isEmpty)
                        // data not specified, without content id this is treated as create new plot button
                        TabModel(id: '', title: '', type: TabType.plot)
                      else
                        ...plots
                            .map(
                              (e) => TabModel(
                                id: 'plot_${e.id}',
                                title: e.name,
                                type: TabType.plot,
                                associatedContentId: e.id,
                              ),
                            )
                            .toList(),
                      if (fragments.isEmpty)
                        // data not specified, without content id this is treated as create new fragment button
                        TabModel(id: '', title: '', type: TabType.fragment)
                      else
                        ...fragments
                            .map(
                              (e) => TabModel(
                                id: 'fragment_${e.id}',
                                title: e.name,
                                type: TabType.fragment,
                                associatedContentId: e.id,
                              ),
                            )
                            .toList(),
                    ];

                    return _buildSidebarItems(
                      context: context,
                      tabs: tabs,
                      viewState: viewState,
                      plots: plots,
                      characters: characters,
                      fragments: fragments,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  SidebarItems _buildSidebarItems({
    required List<CharacterSnippet> characters,
    required List<PlotSnippet> plots,
    required List<FragmentSnippet> fragments,
    required BuildContext context,
    required List<TabModel> tabs,
    required ViewState viewState,
  }) {
    final currentTab = BlocProvider.of<ViewCubit>(context).currentTab;
    final currentTabIndex = tabs.indexWhere(
      (element) =>
          element.type == currentTab?.type &&
          element.associatedContentId == currentTab?.associatedContentId,
    );

    return SidebarItems(
      itemSize: SidebarItemSize.medium,
      cursor: SystemMouseCursors.click,
      items: [
        SidebarItem(
          label: Text(LocaleKeys.home_project.tr()),
          leading: const MacosIcon(CupertinoIcons.doc),
        ),
        SidebarItem(
          label: Text(LocaleKeys.home_characters.tr()),
          leading: const MacosIcon(CupertinoIcons.person_3),
          trailing: Text('${characters.length}'),
          disclosureItems: characters.isEmpty
              ? null
              : characters.map((e) {
                  return SidebarItem(
                    label: Expanded(
                      child: Text(
                        e.name,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    leading: const MacosIcon(CupertinoIcons.person),
                  );
                }).toList(),
        ),
        SidebarItem(
          label: Text(LocaleKeys.home_plots.tr()),
          leading: const MacosIcon(Icons.sailing_outlined),
          trailing: Text('${plots.length}'),
          disclosureItems: plots.isEmpty
              ? null
              : plots.map((e) {
                  return SidebarItem(
                    label: Expanded(
                      child: Text(
                        e.name,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    leading: const MacosIcon(CupertinoIcons.helm),
                  );
                }).toList(),
        ),
        SidebarItem(
          label: BlocBuilder<ProjectCubit, ProjectState>(
            bloc: BlocProvider.of<ProjectCubit>(context),
            builder: (context, state) {
              final template =
                  state.projectInfo?.template ?? ProjectTemplate.book;

              if (template == ProjectTemplate.book) {
                return Text(
                  LocaleKeys.home_parts.tr(),
                );
              } else if (template == ProjectTemplate.movie) {
                return Text(
                  LocaleKeys.home_acts.tr(),
                );
              } else if (template == ProjectTemplate.series) {
                return Text(
                  LocaleKeys.home_episodes.tr(),
                );
              }
              return const Text('');
            },
          ),
          leading: const MacosIcon(Icons.library_books_rounded),
          trailing: Text('${fragments.length}'),
          disclosureItems: fragments.isEmpty
              ? null
              : fragments.map((e) {
                  return SidebarItem(
                    label: Expanded(
                      child: Text(
                        e.name,
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    leading: const MacosIcon(CupertinoIcons.collections),
                  );
                }).toList(),
        ),
        SidebarItem(
          label: Text(LocaleKeys.home_timeline.tr()),
          leading: const MacosIcon(CupertinoIcons.time),
        ),
      ],
      currentIndex: currentTabIndex == -1 ? 0 : currentTabIndex,
      onChanged: (value) {
        if (value >= tabs.length) {
          return;
        }
        final tab = tabs[value];
        if (tab.type == TabType.project) {
          BlocProvider.of<ViewCubit>(context).openProjectTab();
        } else if (tab.type == TabType.character) {
          if (tab.associatedContentId == null) {
            final character = BlocProvider.of<CharactersCubit>(
              context,
            ).createNew();
            BlocProvider.of<ViewCubit>(context).openTab(
              TabModel(
                id: 'character_${character.id}',
                title: character.name,
                type: TabType.character,
                associatedContentId: character.id,
              ),
            );
          } else {
            BlocProvider.of<ViewCubit>(context).openTab(tab);
          }
        } else if (tab.type == TabType.plot) {
          if (tab.associatedContentId == null) {
            final plot = BlocProvider.of<PlotsCubit>(context).createNew();
            BlocProvider.of<ViewCubit>(context).openTab(
              TabModel(
                id: 'plot_${plot.id}',
                title: plot.name,
                type: TabType.plot,
                associatedContentId: plot.id,
              ),
            );
          } else {
            BlocProvider.of<ViewCubit>(context).openTab(tab);
          }
        } else if (tab.type == TabType.fragment) {
          if (tab.associatedContentId == null) {
            final fragment =
                BlocProvider.of<FragmentsCubit>(context).createNew();

            BlocProvider.of<ViewCubit>(context).openTab(
              TabModel(
                id: 'fragment_${fragment.id}',
                title: fragment.name,
                type: TabType.fragment,
                associatedContentId: fragment.id,
              ),
            );
          } else {
            BlocProvider.of<ViewCubit>(context).openTab(tab);
          }
        }
      },
    );
  }
}
