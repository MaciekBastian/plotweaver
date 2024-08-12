final class RegexConstants {
  const RegexConstants._();

  static RegExp get projectNameRegex => RegExp(
        r'^(?!^(CON|con|PRN|prn|AUX|aux|NUL|nul|COM|com[1-9]|LPT[1-9])(\..+)?$)[^<>:"/\\|?*\x00-\x1F]+[^<>:"/\\|?*\x00-\x1F\.\ ]{1,255}$',
      );
}
