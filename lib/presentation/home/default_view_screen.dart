import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/constants/colors.dart';
import '../../core/get_it/get_it.dart';
import '../../core/styles/text_styles.dart';
import '../../domain/global/models/command.dart';
import '../../domain/global/services/command_dispatcher.dart';
import '../../generated/locale_keys.g.dart';
import '../../infrastructure/global/cubit/view_cubit.dart';
import '../../infrastructure/global/models/tab_model.dart';
import '../../infrastructure/global/models/tab_type.dart';
import '../characters/character_tab.dart';
import '../project/edit_project_tab.dart';
import 'widgets/app_logo_widget.dart';
import 'widgets/sidebar_widget.dart';
import 'widgets/tab_switcher_widget.dart';

@RoutePage(name: 'DefaultViewRoute')
class DefaultViewScreen extends StatelessWidget {
  const DefaultViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return BlocBuilder<ViewCubit, ViewState>(
      bloc: BlocProvider.of<ViewCubit>(context),
      builder: (context, state) {
        final currentTab = BlocProvider.of<ViewCubit>(context).currentTab;

        return MacosWindow(
          backgroundColor: getIt<AppColors>().background,
          sidebarState: NSVisualEffectViewState.followsWindowActiveState,
          sidebar: Sidebar(
            minWidth: 250,
            startWidth: mq.size.width * 0.2 < 250 ? 250 : mq.size.width * 0.2,
            maxWidth: mq.size.width * 0.3,
            shownByDefault: true,
            dragClosed: false,
            top: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppLogoWidget(
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      LocaleKeys.home_plotweaver.tr(),
                      style: PlotweaverTextStyles.headline6,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                MacosSearchField(
                  placeholder: LocaleKeys.home_search.tr(),
                  onChanged: (value) {
                    // TODO: perform search
                  },
                ),
              ],
            ),
            builder: (context, scrollController) {
              return const SidebarWidget();
            },
          ),
          child: MacosScaffold(
            toolBar: ToolBar(
              leading: Builder(
                builder: (context) {
                  if (currentTab == null) {
                    return const MacosIcon(CupertinoIcons.app);
                  }
                  late final IconData icon;
                  switch (currentTab.type) {
                    case TabType.project:
                      icon = CupertinoIcons.doc;
                    case TabType.character:
                      icon = CupertinoIcons.person;
                    case TabType.thread:
                      icon = CupertinoIcons.helm;
                    case TabType.fragment:
                      icon = CupertinoIcons.collections;
                    case TabType.timeline:
                      icon = CupertinoIcons.time;
                  }

                  return MacosIcon(icon);
                },
              ),
              title: Text(
                currentTab?.title ?? LocaleKeys.home_plotweaver.tr(),
              ),
              titleWidth: mq.size.width * 0.3,
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 15,
              ),
              enableBlur: true,
              actions: _getToolbarActions(context),
            ),
            children: [
              ContentArea(
                builder: (context, scrollController) {
                  return Column(
                    children: [
                      const TabSwitcherWidget(),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 5,
                            left: 15,
                            right: 5,
                          ),
                          child: _buildView(currentTab),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Builder _buildView(TabModel? currentTab) {
    return Builder(
      builder: (context) {
        if (currentTab == null) {
          return Container();
        }

        switch (currentTab.type) {
          case TabType.project:
            return const EditProjectTab();
          case TabType.character:
            return CharacterTab(
              key: Key(currentTab.id),
              characterId: currentTab.associatedContentId ?? '',
            );
          case TabType.thread:
            return Container();
          case TabType.fragment:
            return Container();
          case TabType.timeline:
            return Container();
        }
      },
    );
  }

  List<ToolbarItem> _getToolbarActions(BuildContext context) {
    return [
      ToolBarIconButton(
        label: LocaleKeys.commands_save.tr(),
        icon: const MacosIcon(CupertinoIcons.doc_checkmark),
        showLabel: true,
        onPressed: () {
          getIt<CommandDispatcher>().sendIntent(PlotweaverCommand.save);
        },
      ),
      const ToolBarSpacer(),
      ToolBarIconButton(
        label: LocaleKeys.commands_add.tr(),
        icon: const MacosIcon(CupertinoIcons.add_circled),
        showLabel: true,
        onPressed: () {
          getIt<CommandDispatcher>().sendIntent(PlotweaverCommand.add);
        },
      ),
      ToolBarIconButton(
        label: LocaleKeys.commands_delete.tr(),
        icon: const MacosIcon(CupertinoIcons.delete),
        showLabel: true,
        onPressed: () {
          final canDelete = getIt<CommandDispatcher>().isCommandAvailable(
            PlotweaverCommand.delete,
          );
          final currentTab = BlocProvider.of<ViewCubit>(context).currentTab;
          if (canDelete) {
            showMacosAlertDialog(
              context: context,
              builder: (context) {
                return MacosAlertDialog(
                  appIcon: const AppLogoWidget(
                    width: 64,
                    height: 64,
                  ),
                  title: Text(
                    LocaleKeys.alerts_do_you_want_to_delete.tr(
                      namedArgs: {
                        'name': currentTab?.title ?? '',
                      },
                    ),
                  ),
                  message: Text(
                    LocaleKeys.alerts_your_data_will_be_lost.tr(),
                    style: PlotweaverTextStyles.body,
                  ),
                  primaryButton: PushButton(
                    controlSize: ControlSize.large,
                    onPressed: () {
                      Navigator.of(context).pop();
                      getIt<CommandDispatcher>().sendIntent(
                        PlotweaverCommand.delete,
                      );
                    },
                    child: Text(LocaleKeys.alerts_delete.tr()),
                  ),
                  secondaryButton: PushButton(
                    controlSize: ControlSize.large,
                    secondary: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(LocaleKeys.alerts_cancel.tr()),
                  ),
                );
              },
            );
          }
        },
      ),
    ];
  }
}
