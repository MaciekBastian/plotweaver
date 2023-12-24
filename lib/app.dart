import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import 'core/get_it/get_it.dart';
import 'core/router/router.dart';

class Plotweaver extends StatelessWidget {
  const Plotweaver({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();
    return MacosApp.router(
      routerConfig: router.config(),
      theme: MacosThemeData(
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Plotweaver',
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
