import 'package:flutter/material.dart';

import '../config/sl_config.dart';
import '../theme/plotweaver_theme.dart';

extension ThemeExtension on BuildContext {
  PlotweaverTheme get currentTheme =>
      sl<PlotweaverThemeSelector>().currentTheme;

  PlotweaverColors get colors => currentTheme.colors;

  PlotweaverTexts get textStyle => currentTheme.texts;
}
