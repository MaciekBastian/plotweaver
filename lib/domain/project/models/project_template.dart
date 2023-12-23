enum ProjectTemplate {
  book('book'),
  movie('movie'),
  series('series');

  const ProjectTemplate(this.codeName);
  final String codeName;

  static ProjectTemplate fromCodeName(String codeName) => ProjectTemplate.values
      .firstWhere((element) => element.codeName == codeName);
}
