import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/images.dart';
import '../../../core/get_it/get_it.dart';
import '../../../core/styles/text_styles.dart';
import '../../../generated/locale_keys.g.dart';

class CharacterTabRightPane extends StatelessWidget {
  const CharacterTabRightPane({
    required this.edit,
    required this.appearanceController,
    required this.appearanceFocus,
    required this.descriptionController,
    required this.descriptionFocus,
    required this.goalsController,
    required this.goalsFocus,
    required this.lessonController,
    required this.lessonFocus,
    super.key,
  });

  final VoidCallback edit;
  final TextEditingController descriptionController;
  final TextEditingController appearanceController;
  final TextEditingController goalsController;
  final TextEditingController lessonController;
  final FocusNode descriptionFocus;
  final FocusNode appearanceFocus;
  final FocusNode goalsFocus;
  final FocusNode lessonFocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const MacosIcon(CupertinoIcons.text_alignleft),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_description.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.character_editor_description_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: descriptionController,
            focusNode: descriptionFocus,
            onChanged: (value) {
              edit();
            },
            minLines: 5,
            maxLines: 15,
            placeholder: LocaleKeys.character_editor_description.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.person_alt),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_appearance.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.character_editor_appearance_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: appearanceController,
            focusNode: appearanceFocus,
            onChanged: (value) {
              edit();
            },
            minLines: 5,
            maxLines: 15,
            placeholder: LocaleKeys.character_editor_appearance.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.flag),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_goals.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.character_editor_goals_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: goalsController,
            focusNode: goalsFocus,
            onChanged: (value) {
              edit();
            },
            minLines: 5,
            maxLines: 15,
            placeholder: LocaleKeys.character_editor_goals.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            SvgPicture.asset(
              PlotweaverImages.tacticIcon,
              height: 18,
              colorFilter: const ColorFilter.mode(
                CupertinoColors.activeBlue,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_lesson.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.character_editor_lesson_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: lessonController,
            focusNode: lessonFocus,
            onChanged: (value) {
              edit();
            },
            minLines: 5,
            maxLines: 15,
            placeholder: LocaleKeys.character_editor_lesson.tr(),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
