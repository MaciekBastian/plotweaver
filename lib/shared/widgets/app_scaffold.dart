import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/extensions/theme_extension.dart';
import '../../generated/l10n.dart';
import '../overlays/search_command_overlay.dart';
import 'clickable_widget.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.scaffoldKey,
    super.key,
  });

  final Widget body;
  final GlobalKey? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: context.colors.scaffoldBackgroundColor,
      body: Column(
        children: [
          if (Platform.isMacOS) const _MacOSTopBar(),
          // TODO: change to windows top bar
          if (Platform.isWindows) const _MacOSTopBar(),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}

class _MacOSTopBar extends StatelessWidget {
  const _MacOSTopBar();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: double.infinity,
      height: 30,
      color: context.colors.topBarBackgroundColor,
      child: Stack(
        children: [
          Positioned(
            top: 3,
            left: size.width * 0.33 - 25,
            child: ClickableWidget(
              onTap: () {},
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  Icons.keyboard_command_key,
                  size: 15,
                  color: context.colors.onTopBarBackgroundColor,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: size.width * 0.33,
              height: 20,
              decoration: BoxDecoration(
                color: context.colors.textFieldBackgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: ClickableWidget(
                onTap: () {
                  showCommandOverlay(context);
                },
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 15,
                      color: context.colors.onTopBarBackgroundColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      S.of(context).search,
                      style: context.textStyle.caption.copyWith(
                        color: context.colors.onTopBarBackgroundColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
