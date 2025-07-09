enum CharacterStatus {
  unspecified('unspecified'),
  unknown('unknown'),
  alive('alive'),
  deceased('deceased');

  const CharacterStatus(this.code);
  final String code;

  static CharacterStatus fromCode(String code) =>
      CharacterStatus.values.firstWhere(
        (el) => el.code == code,
        orElse: () => CharacterStatus.unspecified,
      );
}

enum CharacterGender {
  unspecified('unspecified'),
  male('male'),
  female('female'),
  other('other');

  const CharacterGender(this.code);
  final String code;

  static CharacterGender fromCode(String code) =>
      CharacterGender.values.firstWhere(
        (el) => el.code == code,
        orElse: () => CharacterGender.unspecified,
      );
}
