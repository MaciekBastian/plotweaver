import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/weave_file_repository.dart';
import '../entities/save_intent_entity.dart';

@lazySingleton
class ConsolidateAndSaveWeaveFileUsecase {
  const ConsolidateAndSaveWeaveFileUsecase(this._weaveFileRepository);

  final WeaveFileRepository _weaveFileRepository;

  Future<Option<PlotweaverError>> call({
    required SaveIntentEntity saveIntent,
  }) =>
      _weaveFileRepository.consolidateAndSaveToPath(saveIntent: saveIntent);
}
