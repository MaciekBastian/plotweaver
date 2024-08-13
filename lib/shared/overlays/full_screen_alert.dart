import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants/images_constants.dart';
import '../../core/errors/plotweaver_errors.dart';
import '../../core/extensions/theme_extension.dart';
import '../../core/router/go_router.dart';
import '../../generated/l10n.dart';
import '../widgets/clickable_widget.dart';

void showFullscreenError(PlotweaverError? error) {
  final currentCtx = rootNavKey.currentContext;
  if (currentCtx != null) {
    showDialog(
      context: currentCtx,
      builder: (context) {
        return _FullScreenAlertWidget(
          description: error?.message ?? S.current.unknown_error,
          title: S.current.error_occurred,
          icon: Icons.error_outline,
          headerColor: context.colors.error,
          onClick: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _FullScreenAlertWidget extends StatelessWidget {
  const _FullScreenAlertWidget({
    required this.icon,
    required this.description,
    required this.onClick,
    required this.title,
    this.headerColor,
  });

  final IconData icon;
  final Color? headerColor;
  final String title;
  final String description;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.25,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                context.colors.overlaysBoxShadow,
              ],
              color: context.colors.scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  ImagesConstants.dreamer,
                  height: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: context.textStyle.h5.copyWith(
                    color: headerColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: context.textStyle.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ClickableWidget(
                  onTap: onClick,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    child: Text(
                      S.of(context).ok.toUpperCase(),
                      style: context.textStyle.button.copyWith(
                        color: context.colors.link,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
