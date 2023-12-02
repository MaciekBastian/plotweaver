import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'core/constants/colors.dart';
import 'core/get_it/get_it.dart';
import 'core/router/router.dart';

class Plotweaver extends StatelessWidget {
  const Plotweaver({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();
    return CupertinoApp.router(
      routerConfig: router.config(),
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        applyThemeToAll: true,
        scaffoldBackgroundColor: getIt<AppColors>().background,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Plotweaver',
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
