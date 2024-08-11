import 'package:flutter/material.dart';

import '../../core/extensions/theme_extension.dart';

class ClickableWidget extends StatelessWidget {
  const ClickableWidget({
    required this.child,
    this.borderRadius,
    this.onDoubleTap,
    this.onTap,
    super.key,
    this.focusColor,
    this.hoverColor,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final Color? hoverColor;
  final Color? focusColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: hoverColor ?? context.colors.clickableHoverOverlayColor,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: focusColor ?? context.colors.clickableFocusOverlayColor,
        borderRadius: borderRadius,
        onDoubleTap: onDoubleTap,
        child: child,
      ),
    );
  }
}
