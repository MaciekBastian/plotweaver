import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/clickable_widget.dart';

class QuickStartWidget extends StatelessWidget {
  const QuickStartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.rocket_launch_outlined,
              size: 18,
              color: context.colors.onScaffoldBackgroundColor,
            ),
            const SizedBox(width: 5),
            Text(
              S.of(context).quick_start,
              style: context.textStyle.h6,
            ),
          ],
        ),
        Divider(color: context.colors.dividerColor),
        _QuickStartButton(
          icon: Icons.folder_outlined,
          onTap: () {},
          title: S.of(context).open_project,
        ),
        const SizedBox(height: 5),
        _QuickStartButton(
          icon: Icons.create_outlined,
          onTap: () {},
          title: S.of(context).create_project,
        ),
      ],
    );
  }
}

class _QuickStartButton extends StatelessWidget {
  const _QuickStartButton({
    required this.title,
    required this.onTap,
    required this.icon,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.colors.link,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: context.textStyle.button.copyWith(
                color: context.colors.link,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
