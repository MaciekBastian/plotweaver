import 'package:injectable/injectable.dart';

import '../../../domain/global/services/native_file_service.dart';
import '../../../domain/project/models/file_snippet_model.dart';
import '../../../domain/project/repository/project_repository.dart';
import '../../../domain/project/services/project_local_storage_service.dart';

@LazySingleton(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  ProjectRepositoryImpl(this._localStorageService, this._fileService);

  final ProjectLocalStorageService _localStorageService;
  final NativeFileService _fileService;

  @override
  Future<void> addToRecent(FileSnippetModel file) =>
      _localStorageService.addToRecentFiles(file);

  @override
  Future<List<FileSnippetModel>> getRecent() =>
      _localStorageService.getRecentFiles();

  @override
  Future<FileSnippetModel?> pickFile() async {
    final file = await _fileService.pickFile();
    if (file == null) {
      return null;
    }
    return file;
  }
}
