import 'dart:ui';

import 'package:injectable/injectable.dart';

@singleton
class AppColors {
  late final Color background;
  late final Color textGrey;
  late final Color dividerColor;

  void init() {
    background = _LightTheme.background;
    textGrey = _LightTheme.textGrey;
    dividerColor = _LightTheme.dividerColor;
  }
}

class _LightTheme {
  static const background = Color(0xFFFFFFFF);
  static const textGrey = Color(0xFF0f6060);
  static const dividerColor = Color(0xFFDFDFDF);
}
