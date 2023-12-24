import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../domain/project/models/project_template.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../infrastructure/global/cubit/view_cubit.dart';
import '../../../infrastructure/global/models/tab_model.dart';
import '../../../infrastructure/global/models/tab_type.dart';
import '../../../infrastructure/project/cubit/project_cubit.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: in the future, wrap with multiple bloc builders for characters, fragments etc.
    return Builder(
      builder: (context) {
        final tabs = [
          // data not specified, as opening this tab is handled by the cubit
          TabModel(id: '', title: '', type: TabType.project),
        ];
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
              // TODO: add disclosure items for charactes in the project
            ),
            SidebarItem(
              label: Text(LocaleKeys.home_threads.tr()),
              leading: const MacosIcon(CupertinoIcons.helm),
              // TODO: add disclosure items for threads in the project
            ),
            SidebarItem(
              label: BlocBuilder<ProjectCubit, ProjectState>(
                bloc: BlocProvider.of<ProjectCubit>(context),
                builder: (context, state) {
                  final template = state.projectInfo!.template;

                  if (template == ProjectTemplate.book) {
                    return Text(
                      LocaleKeys.home_chapters.tr(),
                    );
                  } else if (template == ProjectTemplate.movie) {
                    return Text(
                      LocaleKeys.home_scenes.tr(),
                    );
                  } else if (template == ProjectTemplate.series) {
                    return Text(
                      LocaleKeys.home_episodes.tr(),
                    );
                  }
                  return const Text('');
                },
              ),
              leading: const MacosIcon(CupertinoIcons.collections),
              // TODO: add disclosure items for fragments in the project
            ),
            SidebarItem(
              label: Text(LocaleKeys.home_timeline.tr()),
              leading: const MacosIcon(CupertinoIcons.time),
            ),
          ],
          currentIndex: 0,
          onChanged: (value) {
            if (value > tabs.length) {
              return;
            }
            final tab = tabs[value];
            if (tab.type == TabType.project) {
              BlocProvider.of<ViewCubit>(context).openProjectTab();
              return;
            }
          },
        );
      },
    );
  }
}
