import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../../../characters/presentation/bloc/characters_editors_bloc.dart';
import '../../../characters/presentation/screens/character_editor_tab.dart';
import '../../../project/presentation/bloc/project_info_editor/project_info_editor_bloc.dart';
import '../../../project/presentation/cubit/project_files_cubit.dart';
import '../../../project/presentation/screens/project_editor_tab.dart';
import '../../../tabs/domain/commands/plotweaver_tab_commands.dart';
import '../../../tabs/presentation/cubit/tabs_cubit.dart';
import '../../../tabs/presentation/widgets/tab_bar_widget.dart';
import '../bloc/project_sidebar_bloc.dart';
import '../widgets/project_sidebar_widget.dart';
import 'blank_editor_tab.dart';

final globalEditorKey = GlobalKey<ScaffoldState>(
  debugLabel: 'global editor key',
);
final editorFocusNode = FocusNode(debugLabel: 'editor page focus node');

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
  void dispose() {
    editorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: editorFocusNode,
      actions: {
        ...PlotweaverTabCommands().defaultActions,
      },
      autofocus: true,
      child: AppScaffold(
        scaffoldKey: globalEditorKey,
        body: BlocConsumer<ProjectFilesCubit, ProjectFilesState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              active: (projectIdentifier, _) {
                // set up all blocs
                context
                    .read<ProjectInfoEditorBloc>()
                    .add(ProjectInfoEditorEvent.setup(projectIdentifier));
                context
                    .read<CharactersEditorsBloc>()
                    .add(CharactersEditorsEvent.setup(projectIdentifier));
              },
            );
          },
          listenWhen: (previous, current) =>
              previous.maybeWhen(
                orElse: () => false,
                loading: () => true,
              ) &&
              current.maybeMap(
                orElse: () => false,
                active: (_) => true,
              ),
          builder: (context, state) {
            return Skeletonizer(
              enabled: state.map(active: (_) => false, loading: (_) => true),
              enableSwitchAnimation: true,
              child: BlocProvider(
                create: (context) => ProjectSidebarBloc(),
                child: Row(
                  children: [
                    const ProjectSidebarWidget(),
                    Expanded(
                      child: Column(
                        children: [
                          const TabBarWidget(),
                          _buildEditorView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Expanded _buildEditorView() {
    return Expanded(
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, state) {
          final tab = state.openedTabs
              .where((el) => el.tabId == state.openedTabId)
              .firstOrNull;
          if (tab == null) {
            return const BlankEditorTab();
          }

          return tab.map(
            projectTab: (_) => const ProjectEditorTab(
              key: Key('project_editor_tab_view'),
            ),
            characterTab: (tab) => CharacterEditorTab(
              characterId: tab.characterId,
              key: Key('character_editor_tab_${tab.characterId}'),
            ),
          );
        },
      ),
    );
  }
}
