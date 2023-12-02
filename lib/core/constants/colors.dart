import 'dart:ui';

import 'package:injectable/injectable.dart';

@singleton
class AppColors {
  late final Color background;

  void init() {
    background = _LightTheme.background;
  }
}

class _LightTheme {
  static const background = Color(0xFFFFFFFF);
}
