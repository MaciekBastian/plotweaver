import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/project_repository.dart';

@lazySingleton
class RollBackProjectUsecase {
  const RollBackProjectUsecase(this._projectRepository);

  final ProjectRepository _projectRepository;

  Future<Option<PlotweaverError>> call(String identifier) =>
      _projectRepository.rollBackProject(identifier);
}
