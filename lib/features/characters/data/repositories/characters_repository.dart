import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/config/sl_config.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../weave_file/domain/entities/save_intent_entity.dart';
import '../../../weave_file/domain/usecases/consolidate_and_save_weave_file_usecase.dart';
import '../../domain/entities/character_entity.dart';
import '../data_sources/characters_data_source.dart';

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
    required String projectFilePath,
    required String characterId,
  });

  Future<Option<PlotweaverError>> rollbackCharacter({
    required String projectIdentifier,
    required String characterId,
  });
}

@LazySingleton(as: CharactersRepository)
class CharactersRepositoryImpl implements CharactersRepository {
  CharactersRepositoryImpl() : _dataSource = CharactersDataSource();

  final CharactersDataSource _dataSource;

  @override
  Future<Option<PlotweaverError>> createCharacter({
    required String projectIdentifier,
    required CharacterEntity character,
  }) =>
      _dataSource.writeToCharacter(projectIdentifier, character);

  @override
  Future<Option<PlotweaverError>> deleteCharacter({
    required String projectIdentifier,
    required String projectFilePath,
    required String characterId,
  }) async {
    final resp =
        await _dataSource.deleteCharacter(projectIdentifier, characterId);
    if (resp.isSome()) {
      return Some(resp.asSome());
    }

    final saveResp = await sl<ConsolidateAndSaveWeaveFileUsecase>().call(
      saveIntent: SaveIntentEntity(
        path: projectFilePath,
        projectIdentifier: projectIdentifier,
        deleteCharactersIds: [characterId],
      ),
    );

    return saveResp;
  }

  @override
  Future<Either<PlotweaverError, List<CharacterEntity>>> getAllCharacters({
    required String projectIdentifier,
  }) =>
      _dataSource.getAllCharacters(projectIdentifier);

  @override
  Future<Either<PlotweaverError, CharacterEntity>> getCharacter({
    required String projectIdentifier,
    required String characterId,
  }) async {
    final deleteRollbackResp = await _dataSource.deleteCharacterRollback(
      projectIdentifier,
      characterId,
    );

    if (deleteRollbackResp.isSome()) {
      return Left(deleteRollbackResp.asSome());
    }

    final getCharacterRes = await _dataSource.getCharacter(
      projectIdentifier: projectIdentifier,
      characterId: characterId,
    );

    return getCharacterRes;
  }

  @override
  Future<Option<PlotweaverError>> modifyCharacter({
    required String projectIdentifier,
    required CharacterEntity character,
  }) async {
    // create rollback version if necessary
    await _dataSource.getCharacter(
      projectIdentifier: projectIdentifier,
      characterId: character.id,
      rollback: true,
    );

    return _dataSource.writeToCharacter(projectIdentifier, character);
  }

  @override
  Future<Option<PlotweaverError>> rollbackCharacter({
    required String projectIdentifier,
    required String characterId,
  }) async {
    final rollback = await _dataSource.getCharacter(
      projectIdentifier: projectIdentifier,
      characterId: characterId,
      rollback: true,
    );

    if (rollback.isLeft()) {
      return Some(rollback.asLeft());
    }

    final writeRes = await _dataSource.writeToCharacter(
      projectIdentifier,
      rollback.asRight(),
    );

    if (writeRes.isNone()) {
      await _dataSource.deleteCharacterRollback(projectIdentifier, characterId);
    }

    return writeRes;
  }
}
