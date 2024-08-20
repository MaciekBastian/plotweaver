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

  // TODO:
  // Future<Either<PlotweaverError, List<Map<String, dynamic>>>>
  //     consolidateCharacters(
  //   String projectIdentifier,
  // ) async {}
}
