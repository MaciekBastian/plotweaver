import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:window_manager/window_manager.dart';

Future<void> configureWindow() async {
  await windowManager.ensureInitialized();
  await windowManager.setSize(const Size(1400, 800));
  await windowManager.setMinimumSize(const Size(1200, 750));
  await windowManager.center();
  await windowManager.setTitle('Plotweaver');

  if (Platform.isMacOS) {
    const config = MacosWindowUtilsConfig(
      toolbarStyle: NSWindowToolbarStyle.unified,
    );
    await config.apply();
  }
}
