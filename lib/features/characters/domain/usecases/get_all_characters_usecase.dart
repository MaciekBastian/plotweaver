import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/characters_repository.dart';
import '../entities/character_entity.dart';

@lazySingleton
class GetAllCharactersUsecase {
  const GetAllCharactersUsecase(this._charactersRepository);

  final CharactersRepository _charactersRepository;

  Future<Either<PlotweaverError, List<CharacterEntity>>> call({
    required String projectIdentifier,
  }) =>
      _charactersRepository.getAllCharacters(
        projectIdentifier: projectIdentifier,
      );
}
