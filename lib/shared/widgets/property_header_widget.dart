import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/extensions/theme_extension.dart';

class PropertyHeaderWidget extends StatelessWidget {
  const PropertyHeaderWidget({
    required this.icon,
    required this.title,
    this.description,
    super.key,
  });

  final Widget icon;
  final String title;
  final String? description;

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
          )
        else if (icon is SvgPicture)
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 10, right: 5),
            child: SvgPicture(
              (icon as SvgPicture).bytesLoader,
              height: 16,
              colorFilter: ColorFilter.mode(
                context.colors.propertyIconColor,
                BlendMode.srcIn,
              ),
            ),
          )
        else
          icon,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyle.propertyTitle,
              ),
              if (description != null)
                Text(
                  description!,
                  style: context.textStyle.propertyDescription,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
