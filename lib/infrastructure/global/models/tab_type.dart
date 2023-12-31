enum TabType {
  project('project'),
  character('character'),
  plot('plot'),
  fragment('fragment'),
  timeline('timeline');

  const TabType(this.codeName);
  final String codeName;

  static TabType fromCodeName(String codeName) =>
      TabType.values.firstWhere((element) => element.codeName == codeName);
}
