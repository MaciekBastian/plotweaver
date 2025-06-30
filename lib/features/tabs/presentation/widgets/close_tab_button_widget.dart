import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../domain/commands/tab_intent.dart';
import '../../domain/entities/tab_entity.dart';

class CloseTabButton extends StatefulWidget {
  const CloseTabButton({
    required this.tab,
    required this.isUnsaved,
    required this.tabName,
    super.key,
  });

  final TabEntity tab;
  final String tabName;
  final bool isUnsaved;

  @override
  State<CloseTabButton> createState() => _CloseTabButtonState();
}

class _CloseTabButtonState extends State<CloseTabButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!_hovering) {
          setState(() {
            _hovering = true;
          });
        }
      },
      onExit: (_) {
        if (_hovering) {
          setState(() {
            _hovering = false;
          });
        }
      },
      child: ClickableWidget(
        onTap: () {
          Actions.invoke(
            context,
            TabIntent.close(widget.tab),
          );
        },
        child: SizedBox(
          width: 25,
          height: 25,
          child: Icon(
            _hovering
                ? Icons.close
                : widget.isUnsaved
                    ? Icons.circle
                    : Icons.close,
            color: context.colors.disabled,
            size: 18,
          ),
        ),
      ),
    );
  }
}
