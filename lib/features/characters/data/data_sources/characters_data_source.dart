import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as p;

import '../../../../core/config/sl_config.dart';
import '../../../../core/constants/io_names_constants.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../../core/handlers/error_handler.dart';
import '../../../../core/services/app_support_directories_service.dart';
import '../../../../generated/l10n.dart';
import '../../../weave_file/data/data_sources/weave_file_data_source.dart';
import '../../domain/entities/character_entity.dart';

class CharactersDataSource {
  final _weaveDataSource = WeaveFileDataSource();

  Future<Either<PlotweaverError, CharacterEntity>> getCharacter({
    required String projectIdentifier,
    required String characterId,
    bool rollback = false,
  }) async {
    final fileNameBase =
        '${rollback ? PlotweaverIONamesConstants.fileNames.rollback : ''}$characterId';

    final jsonContent = await _weaveDataSource.getFileJson(
      projectIdentifier,
      fileNameBase,
      rollback,
      PlotweaverIONamesConstants.directoryNames.characters,
    );
    if (jsonContent.isLeft()) {
      return Left(jsonContent.asLeft());
    }

    if (jsonContent.asRight().isEmpty && rollback) {
      final characterResp = await getCharacter(
        projectIdentifier: projectIdentifier,
        characterId: characterId,
      );
      if (characterResp.isLeft()) {
        return Left(characterResp.asLeft());
      }

      final fileResp = await _weaveDataSource.getFile(
        projectIdentifier,
        characterId,
      );

      if (fileResp.isLeft()) {
        return Left(fileResp.asLeft());
      }

      final rollbackFileResp =
          await _weaveDataSource.getFile(projectIdentifier, fileNameBase);

      if (rollbackFileResp.isLeft()) {
        return Left(rollbackFileResp.asLeft());
      }

      final copyResp = await handleAsynchronousOperation(
        () => fileResp.asRight().copy(rollbackFileResp.asRight().path),
      );

      if (copyResp.isLeft()) {
        return Left(copyResp.asLeft());
      }

      return Right(characterResp.asRight());
    }

    final characterEntity = handleCommonOperation(
      () => CharacterEntity.fromJson(jsonContent.asRight()),
    );

    return characterEntity;
  }

  Future<Option<PlotweaverError>> deleteCharacterRollback(
    String identifier,
    String characterId,
  ) {
    final fileNameBase =
        '${PlotweaverIONamesConstants.fileNames.rollback}$characterId';

    return _weaveDataSource.deleteRollback(
      identifier,
      fileNameBase,
      PlotweaverIONamesConstants.directoryNames.characters,
    );
  }

  Future<Option<PlotweaverError>> openProjectCharacters(
    String projectIdentifier,
    List<Map<String, dynamic>> characters,
  ) async {
    final projectDirectoryRes =
        await sl<AppSupportDirectoriesService>().getProjectDirectory(
      projectIdentifier,
      subdirectory: PlotweaverIONamesConstants.directoryNames.characters,
    );

    if (projectDirectoryRes.isLeft()) {
      return Some(projectDirectoryRes.asLeft());
    }

    await Future.forEach(characters, (element) async {
      final id = element['id'];

      if (id == null) {
        return const Some(IOError.parseError());
      }

      final file = File(
        p.join(
          projectDirectoryRes.asRight().path,
          '$id.${PlotweaverIONamesConstants.fileExtensionNames.json}',
        ),
      );

      if (!file.existsSync()) {
        final resp = handleVoidOperation(file.createSync);
        if (resp.isSome()) {
          return Left(resp.asSome());
        }
      }

      final jsonContent = await Isolate.run(
        () => handleCommonOperation(
          () => json.encode(element),
        ),
      );

      if (jsonContent.isLeft()) {
        return Left(
          IOError.unknownError(message: S.current.unknown_error),
        );
      }

      final writeResp = handleVoidOperation(
        () => file.writeAsStringSync(jsonContent.asRight()),
      );

      if (writeResp.isSome()) {
        return Left(writeResp.asSome());
      }
    });

    return const None();
  }

  Future<Either<PlotweaverError, List<CharacterEntity>>> getAllCharacters(
    String projectIdentifier, [
    List<String> savingIds = const [],
  ]) async {
    final projectDirectoryRes =
        await sl<AppSupportDirectoriesService>().getProjectDirectory(
      projectIdentifier,
      subdirectory: PlotweaverIONamesConstants.directoryNames.characters,
    );

    if (projectDirectoryRes.isLeft()) {
      return Left(projectDirectoryRes.asLeft());
    }

    final files = projectDirectoryRes.asRight().listSync().where(
          (el) =>
              el.statSync().type == FileSystemEntityType.file &&
              !el.path.startsWith('.') &&
              el.path
                  .endsWith(PlotweaverIONamesConstants.fileExtensionNames.json),
        );

    if (files.isEmpty) {
      return const Right([]);
    }

    final List<CharacterEntity> output = [];

    await Future.forEach(files, (characterFile) async {
      if (characterFile is File) {
        final characterFileContent = await handleAsynchronousOperation(
          characterFile.readAsString,
        );

        if (characterFileContent.isLeft()) {
          return Left(IOError.unknownError(message: S.current.unknown_error));
        }

        final characterJsonContent = await Isolate.run(
          () => handleCommonOperation(
            () => json.decode(characterFileContent.asRight()),
          ),
        );

        if (characterJsonContent.isLeft()) {
          return Left(IOError.unknownError(message: S.current.unknown_error));
        }

        final characterEntity = handleCommonOperation(
          () => CharacterEntity.fromJson(characterJsonContent.asRight()),
        );

        if (characterEntity.isLeft()) {
          return Left(characterEntity.asLeft());
        }

        if (savingIds.isEmpty ||
            savingIds.contains(characterEntity.asRight().id)) {
          output.add(characterEntity.asRight());
        } else {
          final rollbackResp = await getCharacter(
            projectIdentifier: projectIdentifier,
            characterId: characterEntity.asRight().id,
            rollback: true,
          );
          if (rollbackResp.isLeft()) {
            output.add(characterEntity.asRight());
          } else {
            output.add(rollbackResp.asRight());
          }
        }
      }
    });

    return Right(output);
  }

  Future<Either<PlotweaverError, List<Map<String, dynamic>>>>
      consolidateCharacters(
    String projectIdentifier,
    List<String> saveCharactersIds,
  ) async {
    final projectDirectoryRes =
        await sl<AppSupportDirectoriesService>().getProjectDirectory(
      projectIdentifier,
      subdirectory: PlotweaverIONamesConstants.directoryNames.characters,
    );

    if (projectDirectoryRes.isLeft()) {
      return Left(projectDirectoryRes.asLeft());
    }

    if (!projectDirectoryRes.asRight().existsSync()) {
      final resp = handleVoidOperation(
        projectDirectoryRes.asRight().createSync,
      );
      if (resp.isSome()) {
        return Left(resp.asSome());
      }
    }

    final characters = await getAllCharacters(
      projectIdentifier,
      saveCharactersIds,
    );

    if (characters.isLeft()) {
      return Left(projectDirectoryRes.asLeft());
    }

    return Right(characters.asRight().map((el) => el.toJson()).toList());
  }

  Future<Option<PlotweaverError>> writeToCharacter(
    String projectIdentifier,
    CharacterEntity character,
  ) async {
    final projectDirectoryRes =
        await sl<AppSupportDirectoriesService>().getProjectDirectory(
      projectIdentifier,
      subdirectory: PlotweaverIONamesConstants.directoryNames.characters,
    );

    if (projectDirectoryRes.isLeft()) {
      return Some(projectDirectoryRes.asLeft());
    }

    if (!projectDirectoryRes.asRight().existsSync()) {
      final resp = handleVoidOperation(
        projectDirectoryRes.asRight().createSync,
      );
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
    }

    final characterFile = File(
      p.join(
        projectDirectoryRes.asRight().path,
        '${character.id}.${PlotweaverIONamesConstants.fileExtensionNames.json}',
      ),
    );

    if (!characterFile.existsSync()) {
      final resp = handleVoidOperation(characterFile.createSync);
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
    }

    final characterJsonContent = await Isolate.run(
      () => handleCommonOperation(() => json.encode(character.toJson())),
    );

    if (characterJsonContent.isLeft()) {
      return Some(characterJsonContent.asLeft());
    } else {
      final resp = await handleAsynchronousOperation(
        () => characterFile.writeAsString(characterJsonContent.asRight()),
      );

      if (resp.isLeft()) {
        return Some(resp.asLeft());
      }
    }

    return const None();
  }

  Future<Option<PlotweaverError>> deleteCharacter(
    String projectIdentifier,
    String characterId,
  ) async {
    final file = await _weaveDataSource.getFile(
      projectIdentifier,
      characterId,
      PlotweaverIONamesConstants.directoryNames.characters,
    );

    if (file.isLeft()) {
      return Some(file.asLeft());
    }

    final deleteRes = await handleVoidAsyncOperation(
      () => file.asRight().delete(),
    );

    await deleteCharacterRollback(projectIdentifier, characterId);

    return deleteRes;
  }
}
