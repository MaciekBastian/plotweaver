import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show InkWell, Colors, Material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../core/constants/colors.dart';
import '../../../core/get_it/get_it.dart';
import '../../../core/styles/text_styles.dart';
import '../../../domain/global/models/command.dart';
import '../../../domain/global/services/command_dispatcher.dart';
import '../../../infrastructure/global/cubit/view_cubit.dart';
import '../../../infrastructure/global/models/tab_model.dart';
import '../../../infrastructure/global/models/tab_type.dart';

class TabSwitcherWidget extends StatelessWidget {
  const TabSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewCubit, ViewState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 35,
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      children: state.openedTabs.map((tab) {
                        late final IconData icon;
                        switch (tab.type) {
                          case TabType.project:
                            icon = CupertinoIcons.doc;
                          case TabType.character:
                            icon = CupertinoIcons.person;
                          case TabType.plot:
                            icon = CupertinoIcons.helm;
                          case TabType.fragment:
                            icon = CupertinoIcons.collections;
                          case TabType.timeline:
                            icon = CupertinoIcons.time;
                        }

                        return _TabWidget(
                          icon: icon,
                          state: state,
                          tab: tab,
                          key: Key('opened_tab_${tab.id}'),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 3),
              color: getIt<AppColors>().dividerColor,
            ),
          ],
        );
      },
    );
  }
}

class _TabWidget extends StatelessWidget {
  const _TabWidget({
    required this.tab,
    required this.icon,
    required this.state,
    super.key,
  });

  final IconData icon;
  final ViewState state;
  final TabModel tab;

  @override
  Widget build(BuildContext context) {
    final currentTab = BlocProvider.of<ViewCubit>(context).currentTab;

    return Container(
      color: tab.id == currentTab?.id
          ? CupertinoColors.activeBlue.withOpacity(0.2)
          : Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: getIt<AppColors>().dividerColor.withOpacity(0.3),
          onTap: () {
            BlocProvider.of<ViewCubit>(context).openTab(tab);
          },
          child: SizedBox(
            width: 200,
            child: Row(
              children: [
                const SizedBox(width: 5),
                if (state.openedTabs.length > 1)
                  MacosIconButton(
                    hoverColor:
                        getIt<AppColors>().dividerColor.withOpacity(0.5),
                    mouseCursor: SystemMouseCursors.click,
                    icon: const MacosIcon(CupertinoIcons.clear),
                    onPressed: () {
                      getIt<CommandDispatcher>()
                          .sendIntent(PlotweaverCommand.save);
                      BlocProvider.of<ViewCubit>(context).closeTab(tab.id);
                    },
                  ),
                const SizedBox(width: 5),
                MacosIcon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    tab.title,
                    style: PlotweaverTextStyles.body,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 1,
                  height: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: getIt<AppColors>().dividerColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
