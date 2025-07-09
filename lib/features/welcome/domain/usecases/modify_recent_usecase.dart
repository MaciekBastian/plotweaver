import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/welcome_repository.dart';
import '../entities/recent_project_entity.dart';

@lazySingleton
class ModifyRecentUsecase {
  const ModifyRecentUsecase(this._welcomeRepository);

  final WelcomeRepository _welcomeRepository;

  Future<Option<PlotweaverError>> call(RecentProjectEntity entity) =>
      _welcomeRepository.modifyRecent(entity);
}
