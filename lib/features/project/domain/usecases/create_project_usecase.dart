import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/project_repository.dart';
import '../entities/project_entity.dart';

@lazySingleton
class CreateProjectUsecase {
  const CreateProjectUsecase(this._projectRepository);

  final ProjectRepository _projectRepository;

  Future<Either<PlotweaverError, (ProjectEntity, String, String)?>> call(
    String projectName,
  ) =>
      _projectRepository.createProject(projectName);
}
