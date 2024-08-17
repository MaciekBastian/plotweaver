import 'package:flutter/material.dart';

import '../plotweaver_theme.dart';

class PlotweaverLightTheme implements PlotweaverTheme {
  @override
  PlotweaverColors get colors => _PlotweaverLightThemeColors();

  @override
  PlotweaverTexts get texts => _PlotweaverLightThemeTexts();
}

class _PlotweaverLightThemeColors implements PlotweaverColors {
  @override
  Color get onScaffoldBackgroundColor => const Color(0xFF1F1F1F);

  @override
  Color get onScaffoldBackgroundHeader => const Color(0xFF000000);

  @override
  Color get onTopBarBackgroundColor => const Color(0xFF4A4F4F);

  @override
  Color get scaffoldBackgroundColor => const Color(0xFFFFFFFF);

  @override
  Color get topBarBackgroundColor => const Color(0xFFF0F8FF);

  @override
  Color get onTextFieldColor => const Color(0xFF000000);

  @override
  Color get textFieldBackgroundColor => const Color(0xFFDFDFDF);

  @override
  Color get clickableFocusOverlayColor =>
      const Color.fromARGB(120, 168, 168, 168);

  @override
  Color get clickableHoverOverlayColor =>
      const Color.fromARGB(60, 168, 168, 168);

  @override
  Color get dividerColor => const Color(0xFFCFCFCF);

  @override
  Color get link => const Color(0xFF3366CC);

  @override
  Color get onLink => const Color(0xFFFFFFFF);

  @override
  Color get disabled => const Color(0xFF606060);

  @override
  Color get error => const Color(0xFFFF3131);

  @override
  Color get shadedBackgroundColor => const Color(0xFFDFDFDF);

  @override
  BoxShadow get overlaysBoxShadow => const BoxShadow(
        color: Colors.black38,
        blurRadius: 5,
        spreadRadius: 3,
        offset: Offset(0, 4),
      );

  @override
  Color get propertyIconColor => const Color(0xFF3366CC);
}

class _PlotweaverLightThemeTexts implements PlotweaverTexts {
  @override
  TextStyle get h1 => TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: _PlotweaverLightThemeColors().onScaffoldBackgroundHeader,
      );

  @override
  TextStyle get h2 => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: _PlotweaverLightThemeColors().onScaffoldBackgroundHeader,
      );

  @override
  TextStyle get h3 => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: _PlotweaverLightThemeColors().onScaffoldBackgroundHeader,
      );

  @override
  TextStyle get h4 => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: _PlotweaverLightThemeColors().onScaffoldBackgroundHeader,
      );

  @override
  TextStyle get h5 => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: _PlotweaverLightThemeColors().onScaffoldBackgroundHeader,
      );

  @override
  TextStyle get h6 => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: _PlotweaverLightThemeColors().onScaffoldBackgroundHeader,
      );

  @override
  TextStyle get body => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.2,
        color: _PlotweaverLightThemeColors().onScaffoldBackgroundColor,
      );

  @override
  TextStyle get caption => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        letterSpacing: 0.2,
        color: _PlotweaverLightThemeColors().disabled,
      );

  @override
  TextStyle get button => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: _PlotweaverLightThemeColors().onScaffoldBackgroundColor,
      );

  @override
  TextStyle get propertyDescription => caption;

  @override
  TextStyle get propertyTitle => body.copyWith(fontWeight: FontWeight.bold);
}
