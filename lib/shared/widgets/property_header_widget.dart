import 'package:flutter/material.dart';

import '../../core/extensions/theme_extension.dart';

class PropertyHeaderWidget extends StatelessWidget {
  const PropertyHeaderWidget({
    required this.description,
    required this.icon,
    required this.title,
    super.key,
  });

  final Widget icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon is Icon)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 10, right: 5),
            child: Icon(
              (icon as Icon).icon,
              size: 16,
              color: context.colors.propertyIconColor,
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyle.propertyTitle,
              ),
              Text(
                description,
                style: context.textStyle.propertyDescription,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
