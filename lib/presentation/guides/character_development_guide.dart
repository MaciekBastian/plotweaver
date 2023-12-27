import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import '../../core/get_it/get_it.dart';
import '../../core/styles/text_styles.dart';
import '../../generated/locale_keys.g.dart';

class CharacterDevelopmentGuide extends StatelessWidget {
  const CharacterDevelopmentGuide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      children: [
        const SizedBox(height: 100),
        const Align(
          alignment: Alignment.centerLeft,
          child: MacosIcon(
            CupertinoIcons.person,
            size: 64,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          LocaleKeys.guides_character_development_content_header.tr(),
          style: PlotweaverTextStyles.headline1,
        ),
        const SizedBox(height: 5),
        Text(
          LocaleKeys.guides_character_development_content_subtitle.tr(),
          style: PlotweaverTextStyles.headline5,
        ),
        const SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys
                        .guides_character_development_content_section_1_title
                        .tr(),
                    style: PlotweaverTextStyles.headline4,
                  ),
                  const SizedBox(height: 5),
                  _buildRichText(
                    LocaleKeys
                        .guides_character_development_content_section_1_content
                        .tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              width: 1,
              height: 50,
              color: getIt<AppColors>().dividerColor,
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.guides_in_plotweaver.tr(),
                    style: PlotweaverTextStyles.fieldTitle,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.text_alignleft),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_description.tr(),
                        style: PlotweaverTextStyles.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.person_alt),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_appearance.tr(),
                        style: PlotweaverTextStyles.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: getIt<AppColors>().dividerColor,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.person),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.guides_in_character_tab.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys
                        .guides_character_development_content_section_2_title
                        .tr(),
                    style: PlotweaverTextStyles.headline4,
                  ),
                  const SizedBox(height: 5),
                  _buildRichText(
                    LocaleKeys
                        .guides_character_development_content_section_2_content
                        .tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              width: 1,
              height: 50,
              color: getIt<AppColors>().dividerColor,
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.guides_in_plotweaver.tr(),
                    style: PlotweaverTextStyles.fieldTitle,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.text_alignleft),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_description.tr(),
                        style: PlotweaverTextStyles.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: getIt<AppColors>().dividerColor,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.person),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.guides_in_character_tab.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys
                        .guides_character_development_content_section_3_title
                        .tr(),
                    style: PlotweaverTextStyles.headline4,
                  ),
                  const SizedBox(height: 5),
                  _buildRichText(
                    LocaleKeys
                        .guides_character_development_content_section_3_content
                        .tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              width: 1,
              height: 50,
              color: getIt<AppColors>().dividerColor,
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.guides_in_plotweaver.tr(),
                    style: PlotweaverTextStyles.fieldTitle,
                  ),
                  const SizedBox(height: 10),
                  // TODO: add elements
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys
                        .guides_character_development_content_section_4_title
                        .tr(),
                    style: PlotweaverTextStyles.headline4,
                  ),
                  const SizedBox(height: 5),
                  _buildRichText(
                    LocaleKeys
                        .guides_character_development_content_section_4_content
                        .tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              width: 1,
              height: 50,
              color: getIt<AppColors>().dividerColor,
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.guides_in_plotweaver.tr(),
                    style: PlotweaverTextStyles.fieldTitle,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.flag_fill),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_goals.tr(),
                        style: PlotweaverTextStyles.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(
                        PlotweaverImages.tacticIcon,
                        width: 20,
                        colorFilter: const ColorFilter.mode(
                          CupertinoColors.activeBlue,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_lesson.tr(),
                        style: PlotweaverTextStyles.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: getIt<AppColors>().dividerColor,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.person),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.guides_in_character_tab.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys
                        .guides_character_development_content_section_5_title
                        .tr(),
                    style: PlotweaverTextStyles.headline4,
                  ),
                  const SizedBox(height: 5),
                  _buildRichText(
                    LocaleKeys
                        .guides_character_development_content_section_5_content
                        .tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              width: 1,
              height: 50,
              color: getIt<AppColors>().dividerColor,
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.guides_in_plotweaver.tr(),
                    style: PlotweaverTextStyles.fieldTitle,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.flag_fill),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_goals.tr(),
                        style: PlotweaverTextStyles.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: getIt<AppColors>().dividerColor,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.person),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.guides_in_character_tab.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      SvgPicture.asset(
                        PlotweaverImages.swordsIcon,
                        width: 20,
                        colorFilter: const ColorFilter.mode(
                          CupertinoColors.activeBlue,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.plots_editor_conflict.tr(),
                        style: PlotweaverTextStyles.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: getIt<AppColors>().dividerColor,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.helm),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.guides_in_plot_tab.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys
                        .guides_character_development_content_section_6_title
                        .tr(),
                    style: PlotweaverTextStyles.headline4,
                  ),
                  const SizedBox(height: 5),
                  _buildRichText(
                    LocaleKeys
                        .guides_character_development_content_section_6_content
                        .tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Container(
              width: 1,
              height: 50,
              color: getIt<AppColors>().dividerColor,
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.guides_in_plotweaver.tr(),
                    style: PlotweaverTextStyles.fieldTitle,
                  ),
                  const SizedBox(height: 10),
                  // TODO: add elements
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Text(
          LocaleKeys.guides_summary.tr(),
          style: PlotweaverTextStyles.headline4,
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.activeBlue,
              ),
            ),
            Text(
              LocaleKeys.guides_character_development_content_summary_1.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.activeBlue,
              ),
            ),
            Text(
              LocaleKeys.guides_character_development_content_summary_2.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.activeBlue,
              ),
            ),
            Text(
              LocaleKeys.guides_character_development_content_summary_3.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.activeBlue,
              ),
            ),
            Text(
              LocaleKeys.guides_character_development_content_summary_4.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.activeBlue,
              ),
            ),
            Text(
              LocaleKeys.guides_character_development_content_summary_5.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.activeBlue,
              ),
            ),
            Text(
              LocaleKeys.guides_character_development_content_summary_6.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 100),
        const Text(
          '© Plotweaver, Maciej Bastian 2024',
          style: PlotweaverTextStyles.body,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildRichText(String input) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'\*(.*?)\*');
    final List<RegExpMatch> matches = regex.allMatches(input).toList();

    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: input.substring(currentIndex, match.start)));
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < input.length) {
      spans.add(TextSpan(text: input.substring(currentIndex)));
    }

    return Text.rich(
      TextSpan(children: spans),
      style: PlotweaverTextStyles.body2,
    );
  }
}
