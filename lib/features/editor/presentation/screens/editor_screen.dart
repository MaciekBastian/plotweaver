import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../../../project/presentation/bloc/project_info_editor/project_info_editor_bloc.dart';
import '../../../project/presentation/cubit/project_files_cubit.dart';
import '../../../project/presentation/screens/project_editor_tab.dart';
import '../../../tabs/presentation/cubit/tabs_cubit.dart';
import '../../../tabs/presentation/widgets/tab_bar_widget.dart';
import '../bloc/project_sidebar_bloc.dart';
import '../widgets/project_sidebar_widget.dart';
import 'blank_editor_tab.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectFilesCubit, ProjectFilesState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          active: (projectIdentifier, _) {
            // set up all blocs
            context
                .read<ProjectInfoEditorBloc>()
                .add(ProjectInfoEditorEvent.setup(projectIdentifier));
          },
        );
      },
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.map(active: (_) => false, loading: (_) => true),
          enableSwitchAnimation: true,
          child: BlocProvider(
            create: (context) => ProjectSidebarBloc(),
            child: AppScaffold(
              body: Row(
                children: [
                  const ProjectSidebarWidget(),
                  Expanded(
                    child: Column(
                      children: [
                        const TabBarWidget(),
                        Expanded(
                          child: BlocBuilder<TabsCubit, TabsState>(
                            builder: (context, state) {
                              final tab = state.openedTabs
                                  .where((el) => el.tabId == state.openedTabId)
                                  .firstOrNull;
                              if (tab == null) {
                                return const BlankEditorTab();
                              }

                              return tab.map(
                                projectTab: (_) => const ProjectEditorTab(),
                                characterTab: (_) => Container(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
