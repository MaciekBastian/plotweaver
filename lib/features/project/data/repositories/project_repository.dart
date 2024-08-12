import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../domain/entities/project_entity.dart';

abstract class ProjectRepository {
  /// Returns PlotweaverError on exception, and ProjectEntity if file was opened successfully. Null if cancelled by the user
  Future<Either<PlotweaverError, ProjectEntity?>> openProject();
}

@Singleton(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  @override
  Future<Either<PlotweaverError, ProjectEntity?>> openProject() async {
    throw UnimplementedError();
  }
}
