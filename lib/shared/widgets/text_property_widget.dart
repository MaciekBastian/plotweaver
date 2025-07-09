import 'package:flutter/material.dart';

import '../../core/extensions/theme_extension.dart';
import '../../features/editor/presentation/screens/editor_screen.dart';
import 'property_header_widget.dart';

class TextPropertyWidget extends StatelessWidget {
  const TextPropertyWidget({
    required this.icon,
    required this.controller,
    required this.focusNode,
    required this.onChange,
    required this.title,
    this.description,
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
  final String? description;
  final String? hint;
  final int minLines;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PropertyHeaderWidget(
          description: description,
          icon: icon,
          title: title,
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
          onTapOutside: (event) {
            editorFocusNode.requestFocus();
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
