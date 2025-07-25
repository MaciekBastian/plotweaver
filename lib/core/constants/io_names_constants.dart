final class PlotweaverIONamesConstants {
  const PlotweaverIONamesConstants._();

  static final fileNames = _PlotweaverFileNamesConstants();
  static final directoryNames = _PlotweaverDirectoryNamesConstants();
  static final fileExtensionNames = _PlotweaverFileExtensionNamesConstants();
}

final class _PlotweaverFileNamesConstants {
  final general = 'general';
  final project = 'project';
  final recentProjects = 'recent_projects';
  final rollback = '.rb_';
}

final class _PlotweaverDirectoryNamesConstants {
  final openedWeaveFiles = 'opened_weave_files';
  final preferences = 'pref';
  final characters = 'characters';
}

final class _PlotweaverFileExtensionNamesConstants {
  final json = 'json';
  final weave = 'weave';
}
