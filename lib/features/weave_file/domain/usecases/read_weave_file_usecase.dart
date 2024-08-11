import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/weave_file_repository.dart';

@lazySingleton
class ReadWeaveFileUsecase {
  const ReadWeaveFileUsecase(this._weaveFileRepository);

  final WeaveFileRepository _weaveFileRepository;

  Future<Either<PlotweaverError, String>> call(String path) =>
      _weaveFileRepository.readFile(path);
}
