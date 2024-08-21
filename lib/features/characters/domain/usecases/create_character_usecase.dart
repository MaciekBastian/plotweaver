import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../data/repositories/characters_repository.dart';
import '../entities/character_entity.dart';

@lazySingleton
class CreateCharacterUsecase {
  const CreateCharacterUsecase(this._charactersRepository);

  final CharactersRepository _charactersRepository;

  Future<Option<PlotweaverError>> call({
    required String projectIdentifier,
    required CharacterEntity character,
  }) =>
      _charactersRepository.createCharacter(
        character: character,
        projectIdentifier: projectIdentifier,
      );
}
