class SaveIntentEntity {
  SaveIntentEntity({
    required this.path,
    required this.projectIdentifier,
    this.saveProject = false,
    this.saveCharactersIds = const [],
    this.deleteCharactersIds = const [],
  });

  final String path;
  final String projectIdentifier;
  final bool saveProject;
  final List<String> saveCharactersIds;
  final List<String> deleteCharactersIds;
}
