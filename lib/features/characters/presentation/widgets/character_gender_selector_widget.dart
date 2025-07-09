import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/dropdown_property_widget.dart';
import '../../domain/enums/character_enums.dart';

class CharacterGenderSelectorWidget extends StatelessWidget {
  const CharacterGenderSelectorWidget({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final CharacterGender selected;
  final void Function(CharacterGender) onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownPropertyWidget(
      icon: const Icon(Icons.wc_rounded),
      title: S.of(context).character_gender,
      onSelected: onSelected,
      selected: selected,
      values: [
        DropdownElement(
          title: S.of(context).character_gender_unspecified,
          value: CharacterGender.unspecified,
          leading: Icon(
            CupertinoIcons.question,
            size: 15,
            color: context.colors.link,
          ),
        ),
        DropdownElement(
          title: S.of(context).character_gender_male,
          value: CharacterGender.male,
          leading: Icon(
            Icons.male_rounded,
            size: 18,
            color: context.colors.link,
          ),
        ),
        DropdownElement(
          title: S.of(context).character_gender_female,
          value: CharacterGender.female,
          leading: Icon(
            Icons.female_rounded,
            size: 18,
            color: context.colors.link,
          ),
        ),
        DropdownElement(
          title: S.of(context).character_gender_other,
          value: CharacterGender.other,
          leading: Icon(
            Icons.transgender_rounded,
            size: 18,
            color: context.colors.link,
          ),
        ),
      ],
    );
  }
}
