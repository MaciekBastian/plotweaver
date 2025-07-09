import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants/images_constants.dart';
import '../../core/errors/plotweaver_errors.dart';
import '../../core/extensions/theme_extension.dart';
import '../../core/router/go_router.dart';
import '../../generated/l10n.dart';
import '../widgets/clickable_widget.dart';

void showFullscreenError(PlotweaverError? error, [BuildContext? context]) {
  final currentCtx = context ?? rootNavKey.currentContext;
  if (currentCtx != null) {
    showDialog(
      context: currentCtx,
      builder: (context) {
        return _FullScreenAlertWidget(
          description: error?.message ?? S.current.unknown_error,
          title: S.current.error_occurred,
          icon: SvgPicture.asset(
            ImagesConstants.dreamer,
            height: 80,
          ),
          headerColor: context.colors.error,
          options: [
            AlertOption(
              callback: () {
                Navigator.of(context).pop();
              },
              title: S.of(context).ok,
            ),
          ],
        );
      },
    );
  }
}

class AlertOption {
  AlertOption({
    required this.callback,
    required this.title,
    this.isDestructive = false,
    this.isSeparated = false,
    this.isDefault = false,
  });

  final String title;
  final VoidCallback callback;
  final bool isDestructive;
  final bool isDefault;
  final bool isSeparated;
}

void showFullscreenAlert({
  required List<AlertOption> options,
  required String title,
  required String description,
  bool showCancelButton = false,
  BuildContext? context,
}) {
  final currentCtx = context ?? rootNavKey.currentContext;
  if (currentCtx != null) {
    showDialog(
      context: currentCtx,
      builder: (context) {
        return _FullScreenAlertWidget(
          description: description,
          title: title,
          icon: SvgPicture.asset(
            ImagesConstants.warning,
            height: 80,
          ),
          headerColor: context.colors.onScaffoldBackgroundHeader,
          options: [
            ...options,
            if (showCancelButton)
              AlertOption(
                callback: () {
                  Navigator.of(context).pop();
                },
                title: S.of(context).cancel,
                isSeparated: true,
              ),
          ],
        );
      },
    );
  }
}

class _FullScreenAlertWidget extends StatelessWidget {
  const _FullScreenAlertWidget({
    required this.icon,
    required this.description,
    required this.title,
    this.headerColor,
    this.options,
  });

  final Widget icon;
  final Color? headerColor;
  final String title;
  final String description;
  final List<AlertOption>? options;

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
                icon,
                const SizedBox(height: 20),
                Text(
                  title,
                  style: context.textStyle.h5.copyWith(
                    color: headerColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: context.textStyle.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (options != null)
                  ...options!.map(
                    (e) => Container(
                      width: size.width * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: e.isDefault
                            ? context.colors.link
                            : context.colors.topBarBackgroundColor,
                      ),
                      margin: EdgeInsets.only(
                        top: e.isSeparated ? 20 : 5,
                      ),
                      child: ClickableWidget(
                        onTap: e.callback,
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          child: Text(
                            e.title,
                            style: context.textStyle.button.copyWith(
                              color: e.isDestructive
                                  ? context.colors.error
                                  : e.isDefault
                                      ? context.colors.onLink
                                      : context.colors.link,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            textAlign: TextAlign.center,
                          ),
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
