import 'package:flutter/material.dart';

import '../../core/extensions/theme_extension.dart';

class TextPropertyWidget extends StatelessWidget {
  const TextPropertyWidget({
    required this.icon,
    required this.controller,
    required this.description,
    required this.focusNode,
    required this.onChange,
    required this.title,
    this.hint,
    this.maxLines,
    this.minLines = 1,
    super.key,
  });

  final Widget icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChange;
  final String title;
  final String description;
  final String? hint;
  final int minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
            Column(
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
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          focusNode: focusNode,
          scrollPadding: EdgeInsets.zero,
          style: context.textStyle.body,
          minLines: minLines,
          maxLines: maxLines,
          onChanged: (_) {
            onChange();
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.colors.dividerColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.colors.dividerColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.colors.link,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            hintStyle: context.textStyle.caption.copyWith(
              color: context.colors.dividerColor,
            ),
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 15,
            ),
          ),
        ),
      ],
    );
  }
}
