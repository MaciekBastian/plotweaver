import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/characters_repository.dart';
import '../entities/character_entity.dart';

@lazySingleton
class GetCharacterUsecase {
  const GetCharacterUsecase(this._charactersRepository);

  final CharactersRepository _charactersRepository;

  Future<Either<PlotweaverError, CharacterEntity>> call({
    required String projectIdentifier,
    required String characterId,
  }) =>
      _charactersRepository.getCharacter(
        characterId: characterId,
        projectIdentifier: projectIdentifier,
      );
}
