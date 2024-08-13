import 'package:flutter/material.dart';

import '../../core/errors/plotweaver_errors.dart';
import '../../core/extensions/theme_extension.dart';
import '../../generated/l10n.dart';
import 'clickable_widget.dart';

class FatalErrorWidget extends StatelessWidget {
  const FatalErrorWidget({
    this.error,
    this.onRetry,
    super.key,
  });

  final PlotweaverError? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          error?.message ?? S.of(context).unknown_error,
          style: context.textStyle.body.copyWith(
            color: context.colors.error,
          ),
        ),
        const SizedBox(height: 10),
        if (onRetry != null)
          Container(
            decoration: BoxDecoration(
              color: context.colors.shadedBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClickableWidget(
              onTap: onRetry,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Text(
                  S.of(context).try_again,
                  style: context.textStyle.button,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
