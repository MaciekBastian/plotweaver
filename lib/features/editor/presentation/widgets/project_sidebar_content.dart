import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../../project/domain/entities/project_file_entity.dart';
import '../../../project/domain/enums/file_bundle_type.dart';
import '../../../project/presentation/cubit/project_files_cubit.dart';
import '../../../tabs/domain/entities/tab_entity.dart';
import '../../../tabs/presentation/cubit/tabs_cubit.dart';
import '../../../tabs/presentation/widgets/tab_icons_and_names.dart';
import 'project_file_bundle_actions.dart';

class ProjectSidebarContent extends StatelessWidget {
  const ProjectSidebarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectFilesCubit, ProjectFilesState>(
      builder: (context, state) {
        return ListView(
          children: state.map(
            active: (value) {
              return value.projectFiles
                  .map((file) => mapProjectFileToSidebarFile(context, file))
                  .toList();
            },
            loading: (_) {
              final placeholders = [
                ProjectFileEntity.placeholder(),
                ProjectFileEntity.fileBundle(
                  type: FileBundleType.characters,
                  files: List.generate(
                    6,
                    (_) => ProjectFileEntity.placeholder(),
                  ),
                ),
                ProjectFileEntity.fileBundle(
                  type: FileBundleType.characters,
                  files: List.generate(
                    3,
                    (_) => ProjectFileEntity.placeholder(),
                  ),
                ),
                ProjectFileEntity.fileBundle(
                  type: FileBundleType.characters,
                  files: List.generate(
                    4,
                    (_) => ProjectFileEntity.placeholder(),
                  ),
                ),
              ];

              return placeholders
                  .map((file) => mapProjectFileToSidebarFile(context, file))
                  .toList();
            },
          ),
        );
      },
    );
  }

  Widget mapProjectFileToSidebarFile(
    BuildContext context,
    ProjectFileEntity file,
  ) {
    return file.when(
      projectFile: () {
        final tab = TabEntity.projectTab(tabId: 'project');
        return _ProjectSidebarFile(
          tab: tab,
          key: Key('sidebar_file_${tab.tabId}'),
          icon: getTabIcon(context, tab),
          title: getTabName(context, tab),
        );
      },
      placeholder: () {
        return _ProjectSidebarFile(
          icon: Container(),
          title: 'long placeholder text',
        );
      },
      characterFile: () {
        // TODO: adjust for characters feature
        final tab = TabEntity.characterTab(tabId: 'character');
        return _ProjectSidebarFile(
          tab: tab,
          key: Key('sidebar_file_${tab.tabId}'),
          icon: getTabIcon(context, tab),
          title: getTabName(context, tab),
        );
      },
      fileBundle: (List<ProjectFileEntity> files, FileBundleType type) {
        return Column(
          children: [
            _ProjectSidebarFile(
              icon: getFileBundleIcon(context, type),
              title: getFileBundleName(context, type),
              actions: ProjectFileBundleActions(type: type),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: files
                    .map(
                      (nestedFile) => mapProjectFileToSidebarFile(
                        context,
                        nestedFile,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProjectSidebarFile extends StatelessWidget {
  const _ProjectSidebarFile({
    required this.icon,
    required this.title,
    this.tab,
    this.actions,
    super.key,
  });

  final Widget icon;
  final String title;
  final TabEntity? tab;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TabsCubit, TabsState, String?>(
      selector: (state) {
        return state.openedTabId;
      },
      builder: (context, state) {
        return Skeleton.leaf(
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.colors.dividerColor),
              color: state == tab?.tabId && tab != null
                  ? context.colors.scaffoldBackgroundColor.withOpacity(0.5)
                  : context.colors.shadedBackgroundColor,
            ),
            child: ClickableWidget(
              onTap: () {
                if (tab != null) {
                  context.read<TabsCubit>().openTab(tab!);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    icon,
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        title,
                        style: context.textStyle.button.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                    if (actions != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: actions,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
