import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../features/project/domain/enums/project_enums.dart';
import 'app_themes/light_theme.dart';

abstract class PlotweaverTheme {
  PlotweaverColors get colors;
  PlotweaverTexts get texts;
}

abstract class PlotweaverColors {
  Color get scaffoldBackgroundColor;
  Color get onScaffoldBackgroundColor;
  Color get onScaffoldBackgroundHeader;
  Color get topBarBackgroundColor;
  Color get onTopBarBackgroundColor;
  Color get textFieldBackgroundColor;
  Color get onTextFieldColor;
  Color get clickableHoverOverlayColor;
  Color get clickableFocusOverlayColor;
  Color get dividerColor;
  Color get link;
  Color get onLink;
  Color get disabled;
  Color get error;
  Color get shadedBackgroundColor;
  BoxShadow get overlaysBoxShadow;
  Color get propertyIconColor;
  Map<ProjectStatus, Color> get projectStatusColors;
}

abstract class PlotweaverTexts {
  TextStyle get h1;
  TextStyle get h2;
  TextStyle get h3;
  TextStyle get h4;
  TextStyle get h5;
  TextStyle get h6;
  TextStyle get body;
  TextStyle get caption;
  TextStyle get button;
  TextStyle get propertyTitle;
  TextStyle get propertyDescription;
}

abstract class PlotweaverThemeSelector {
  Future<void> initialize();

  PlotweaverTheme get currentTheme;
}

@Singleton(as: PlotweaverThemeSelector)
class PlotweaverThemeSelectorImpl implements PlotweaverThemeSelector {
  PlotweaverTheme _currentTheme = PlotweaverLightTheme();

  @override
  PlotweaverTheme get currentTheme => _currentTheme;

  @override
  Future<void> initialize() async {
    // TODO: add theme checking (future)
    _currentTheme = PlotweaverLightTheme();
  }
}
