import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/project_repository.dart';
import '../entities/project_entity.dart';

@lazySingleton
class OpenProjectUsecase {
  const OpenProjectUsecase(this._projectRepository);

  final ProjectRepository _projectRepository;

  Future<Either<PlotweaverError, ProjectEntity?>> call([String? path]) =>
      _projectRepository.openProject(path);
}
