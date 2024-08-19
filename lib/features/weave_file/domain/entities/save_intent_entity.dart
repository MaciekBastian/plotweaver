class SaveIntentEntity {
  SaveIntentEntity({
    required this.path,
    required this.projectIdentifier,
    this.saveProject = false,
  });

  final String path;
  final String projectIdentifier;
  final bool saveProject;
}
