enum FragmentType {
  part('part'),
  act('act'),
  episode('episode');

  const FragmentType(this.codeName);
  final String codeName;

  static FragmentType fromCodeName(String codeName) =>
      FragmentType.values.firstWhere((element) => element.codeName == codeName);
}
