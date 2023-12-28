import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/images.dart';
import '../../../core/get_it/get_it.dart';
import '../../../core/router/router.gr.dart';
import '../../../core/styles/text_styles.dart';
import '../../../domain/guides/guide.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../infrastructure/global/cubit/view_cubit.dart';
import '../../../infrastructure/global/models/tab_type.dart';
import 'app_logo_widget.dart';

class ToolbarHelpButton extends StatelessWidget {
  const ToolbarHelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return HelpButton(
      onPressed: () {
        final currentTab = BlocProvider.of<ViewCubit>(context).currentTab;
        if (currentTab == null) {
          return;
        }
        showMacosSheet(
          context: context,
          builder: (context) {
            return _HelpSheet(
              tabType: currentTab.type,
            );
          },
        );
      },
    );
  }
}

class _HelpSheet extends StatelessWidget {
  const _HelpSheet({
    required this.tabType,
    Key? key,
  }) : super(key: key);

  final TabType tabType;

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      child: Column(
        children: [
          const SizedBox(height: 25),
          const AppLogoWidget(height: 64, width: 64),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: _buildView(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                color: getIt<AppColors>().background,
                onPressed: () {
                  late PlotweaverGuide guide;

                  switch (tabType) {
                    case TabType.project:
                      guide = PlotweaverGuide.characterDevelopment;
                    case TabType.character:
                      guide = PlotweaverGuide.characterDevelopment;
                    case TabType.plot:
                      guide = PlotweaverGuide.characterDevelopment;
                    case TabType.fragment:
                      guide = PlotweaverGuide.characterDevelopment;
                    case TabType.timeline:
                      guide = PlotweaverGuide.characterDevelopment;
                  }

                  Navigator.of(context).pop();
                  AutoRouter.of(context).replace(
                    GuideRoute(
                      initialGuide: guide,
                    ),
                  );
                },
                child: Text(
                  LocaleKeys.commands_read_more.tr(),
                  style: TextStyle(
                    color: getIt<AppColors>().text,
                  ),
                ),
              ),
              const SizedBox(width: 50),
              CupertinoButton.filled(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(LocaleKeys.commands_done.tr()),
              ),
            ],
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildView() {
    switch (tabType) {
      case TabType.project:
        return Container();
      case TabType.character:
        return Column(
          children: [
            const MacosIcon(
              CupertinoIcons.person,
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(
              LocaleKeys.character_editor_character.tr(),
              style: PlotweaverTextStyles.headline3,
            ),
            const SizedBox(height: 25),
            Text(
              LocaleKeys.character_editor_character_description.tr(),
              style: PlotweaverTextStyles.body.copyWith(
                color: getIt<AppColors>().textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            MacosListTile(
              leading: const MacosIcon(CupertinoIcons.flag_fill, size: 23),
              title: Text(LocaleKeys.character_editor_goals.tr()),
              subtitle: Text(
                LocaleKeys.character_editor_goals_description.tr(),
              ),
            ),
            const SizedBox(height: 25),
            MacosListTile(
              leading: SvgPicture.asset(
                PlotweaverImages.tacticIcon,
                width: 22,
                colorFilter: const ColorFilter.mode(
                  CupertinoColors.activeBlue,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.character_editor_lesson.tr()),
              subtitle: Text(
                LocaleKeys.character_editor_lesson_description.tr(),
              ),
            ),
            const SizedBox(height: 25),
            MacosListTile(
              leading: const MacosIcon(CupertinoIcons.hourglass, size: 22),
              title: Text(LocaleKeys.character_editor_episodic_characters.tr()),
              subtitle: Text(
                LocaleKeys.character_editor_episodic_characters_description
                    .tr(),
              ),
            ),
            const SizedBox(height: 25),
            MacosListTile(
              leading: const MacosIcon(
                Icons.diversity_1_rounded,
                size: 22,
              ),
              title: Text(LocaleKeys.character_editor_relationships.tr()),
              subtitle: Text(
                LocaleKeys.character_editor_relationships_description.tr(),
              ),
            ),
          ],
        );
      case TabType.plot:
        return Column(
          children: [
            const MacosIcon(
              CupertinoIcons.helm,
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(
              LocaleKeys.plots_editor_plot.tr(),
              style: PlotweaverTextStyles.headline3,
            ),
            const SizedBox(height: 25),
            Text(
              LocaleKeys.plots_editor_plot_description.tr(),
              style: PlotweaverTextStyles.body.copyWith(
                color: getIt<AppColors>().textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            MacosListTile(
              leading: SvgPicture.asset(
                PlotweaverImages.swordsIcon,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  CupertinoColors.activeBlue,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.plots_editor_conflict.tr()),
              subtitle: Text(
                LocaleKeys.plots_editor_conflict_description.tr(),
              ),
            ),
            const SizedBox(height: 25),
            MacosListTile(
              leading: SvgPicture.asset(
                PlotweaverImages.tacticIcon,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  CupertinoColors.activeBlue,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.plots_editor_result.tr()),
              subtitle: Text(
                LocaleKeys.plots_editor_result_description.tr(),
              ),
            ),
            const SizedBox(height: 25),
            MacosListTile(
              leading: const MacosIcon(CupertinoIcons.person_3, size: 24),
              title: Text(LocaleKeys.plots_editor_characters_involved.tr()),
              subtitle: Text(
                LocaleKeys.plots_editor_characters_involved_description.tr(),
              ),
            ),
            const SizedBox(height: 25),
            MacosListTile(
              leading: const MacosIcon(
                CupertinoIcons.list_bullet_indent,
                size: 24,
              ),
              title: Text(LocaleKeys.plots_editor_subplots.tr()),
              subtitle: Text(
                LocaleKeys.plots_editor_subplots_description.tr(),
              ),
            ),
          ],
        );
      case TabType.fragment:
        return Container();
      case TabType.timeline:
        return Container();
    }
  }
}
