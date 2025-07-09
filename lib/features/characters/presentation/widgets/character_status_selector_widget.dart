import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/dropdown_property_widget.dart';
import '../../domain/enums/character_enums.dart';

class CharacterStatusSelectorWidget extends StatelessWidget {
  const CharacterStatusSelectorWidget({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final CharacterStatus selected;
  final void Function(CharacterStatus) onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownPropertyWidget(
      icon: const Icon(CupertinoIcons.timelapse),
      title: S.of(context).character_status,
      description: S.of(context).character_status_hint,
      onSelected: onSelected,
      selected: selected,
      values: [
        DropdownElement(
          title: S.of(context).character_status_unspecified,
          value: CharacterStatus.unspecified,
          leading: Icon(
            CupertinoIcons.question,
            size: 15,
            color: context.colors.link,
          ),
        ),
        DropdownElement(
          title: S.of(context).character_status_unknown,
          value: CharacterStatus.unknown,
          leading: Icon(
            Icons.help_outline,
            size: 18,
            color: context.colors.link,
          ),
        ),
        DropdownElement(
          title: S.of(context).character_status_alive,
          value: CharacterStatus.alive,
          leading: Icon(
            Icons.stream,
            size: 18,
            color: context.colors.link,
          ),
        ),
        DropdownElement(
          title: S.of(context).character_status_deceased,
          value: CharacterStatus.deceased,
          leading: Icon(
            Icons.local_florist_outlined,
            size: 18,
            color: context.colors.link,
          ),
        ),
      ],
    );
  }
}
