import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../domain/entities/character_entity.dart';

abstract class CharactersRepository {
  Future<Either<PlotweaverError, List<CharacterEntity>>> getAllCharacters({
    required String projectIdentifier,
  });

  Future<Either<PlotweaverError, CharacterEntity>> getCharacter({
    required String projectIdentifier,
    required String characterId,
  });

  Future<Option<PlotweaverError>> createCharacter({
    required String projectIdentifier,
    required CharacterEntity character,
  });

  Future<Option<PlotweaverError>> modifyCharacter({
    required String projectIdentifier,
    required CharacterEntity character,
  });

  Future<Option<PlotweaverError>> deleteCharacter({
    required String projectIdentifier,
    required CharacterEntity character,
  });

  Future<Option<PlotweaverError>> rollbackCharacter({
    required String projectIdentifier,
    required String characterId,
  });
}

@LazySingleton(as: CharactersRepository)
class CharactersRepositoryImpl implements CharactersRepository {
  @override
  Future<Option<PlotweaverError>> createCharacter({
    required String projectIdentifier,
    required CharacterEntity character,
  }) {
    // TODO: implement createCharacter
    throw UnimplementedError();
  }

  @override
  Future<Option<PlotweaverError>> deleteCharacter({
    required String projectIdentifier,
    required CharacterEntity character,
  }) {
    // TODO: implement deleteCharacter
    throw UnimplementedError();
  }

  @override
  Future<Either<PlotweaverError, List<CharacterEntity>>> getAllCharacters({
    required String projectIdentifier,
  }) {
    // TODO: implement getAllCharacters
    throw UnimplementedError();
  }

  @override
  Future<Either<PlotweaverError, CharacterEntity>> getCharacter({
    required String projectIdentifier,
    required String characterId,
  }) {
    // TODO: implement getCharacter
    throw UnimplementedError();
  }

  @override
  Future<Option<PlotweaverError>> modifyCharacter({
    required String projectIdentifier,
    required CharacterEntity character,
  }) {
    // TODO: implement modifyCharacter
    throw UnimplementedError();
  }

  @override
  Future<Option<PlotweaverError>> rollbackCharacter({
    required String projectIdentifier,
    required String characterId,
  }) {
    // TODO: implement rollbackCharacter
    throw UnimplementedError();
  }
}
