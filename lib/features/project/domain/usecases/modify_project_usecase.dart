import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/project_repository.dart';
import '../entities/project_entity.dart';

@lazySingleton
class ModifyProjectUsecase {
  const ModifyProjectUsecase(this._projectRepository);

  final ProjectRepository _projectRepository;

  Future<Option<PlotweaverError>> call(
    String identifier,
    ProjectEntity project,
  ) =>
      _projectRepository.modifyProject(identifier, project);
}
