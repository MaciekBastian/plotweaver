enum CharacterGender {
  unspecified('unspecified'),
  male('male'),
  female('female'),
  other('other');

  const CharacterGender(this.codeName);
  final String codeName;

  static CharacterGender fromCodeName(String code) =>
      CharacterGender.values.firstWhere((element) => element.codeName == code);
}

enum CharacterStatus {
  unspecified('unspecified'),
  alive('alive'),
  deceased('deceased'),
  unknown('unknown');

  const CharacterStatus(this.codeName);
  final String codeName;

  static CharacterStatus fromCodeName(String code) =>
      CharacterStatus.values.firstWhere((element) => element.codeName == code);
}
