import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;

import '../../../../core/config/sl_config.dart';
import '../../../../core/constants/io_names_constants.dart';
import '../../../../core/constants/weave_file_support.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../../core/handlers/error_handler.dart';
import '../../../../core/services/app_support_directories_service.dart';
import '../../../../core/services/package_and_device_info_service.dart';
import '../../../../generated/l10n.dart';
import '../../../characters/data/data_sources/characters_data_source.dart';
import '../../../project/data/data_sources/project_data_source.dart';
import '../../../project/domain/entities/project_entity.dart';
import '../../domain/entities/general_entity.dart';
import '../../domain/entities/save_intent_entity.dart';

/// A repository responsible only for reading, writing, scattering and consolidating weave files.
abstract class WeaveFileRepository {
  /// Returns an identifier of the project
  Future<Either<PlotweaverError, String>> readFile(String path);

  /// Consolidates files with project identifier into `path`
  Future<Option<PlotweaverError>> consolidateAndSaveToPath({
    required SaveIntentEntity saveIntent,
  });
}

@Singleton(as: WeaveFileRepository)
class WeaveFileRepositoryImpl implements WeaveFileRepository {
  WeaveFileRepositoryImpl()
      : _projectDataSource = ProjectDataSource(),
        _charactersDataSource = CharactersDataSource();

  final ProjectDataSource _projectDataSource;
  final CharactersDataSource _charactersDataSource;

  Future<Either<PlotweaverError, Map<String, dynamic>>> _getWeaveJsonContent(
    String path,
  ) async {
    final file = File(path);

    if (!file.existsSync() ||
        file.statSync().type != FileSystemEntityType.file) {
      // return error if entity under this path does not exist or is not a file
      return Left(
        IOError.fileDoesNotExist(message: S.current.file_does_not_exist),
      );
    }

    final fileContent = await handleAsynchronousOperation(
      file.readAsString,
    );

    if (fileContent.isLeft()) {
      return Left(fileContent.asLeft());
    }

    final jsonContent = await Isolate.run(
      () => handleCommonOperation(
        () => json.decode(fileContent.asRight()),
      ),
    );

    if (jsonContent.isLeft() || jsonContent.asRight() is! Map) {
      if (jsonContent.isLeft()) {
        return Left(jsonContent.asLeft());
      } else {
        return Left(
          WeaveError.formattingError(
            message: S.current.weave_file_formatting_error,
          ),
        );
      }
    }

    return Right(jsonContent.asRight());
  }

  @override
  Future<Either<PlotweaverError, String>> readFile(String path) async {
    final jsonContent = await _getWeaveJsonContent(path);

    if (jsonContent.isLeft()) {
      return Left(jsonContent.asLeft());
    }

    final generalInfoMapEntry =
        jsonContent.asRight()[PlotweaverIONamesConstants.fileNames.general];
    final projectMapEntry =
        jsonContent.asRight()[PlotweaverIONamesConstants.fileNames.project];
    final characters = jsonContent
            .asRight()[PlotweaverIONamesConstants.directoryNames.characters]
        as List?;

    if (generalInfoMapEntry == null ||
        generalInfoMapEntry is! Map ||
        projectMapEntry == null ||
        projectMapEntry is! Map) {
      return Left(
        WeaveError.formattingError(
          message: S.current.weave_file_formatting_error,
        ),
      );
    }

    final generalInfo = handleCommonOperation(
      () => GeneralEntity.fromJson(
        generalInfoMapEntry as Map<String, dynamic>,
      ),
    );

    final project = handleCommonOperation(
      () => ProjectEntity.fromJson(projectMapEntry as Map<String, dynamic>),
    );

    if (generalInfo.isLeft()) {
      return Left(generalInfo.asLeft());
    }

    if (project.isLeft()) {
      return Left(project.asLeft());
    }

    final identifier = generalInfo.asRight().projectIdentifier;

    final projectDirectoryRes = await sl<AppSupportDirectoriesService>()
        .getProjectDirectory(identifier);

    if (projectDirectoryRes.isLeft()) {
      return Left(projectDirectoryRes.asLeft());
    }

    final projectDirectory = projectDirectoryRes.asRight();

    // will extract project to files

    final generalFile = File(
      p.join(
        projectDirectory.path,
        '${PlotweaverIONamesConstants.fileNames.general}.${PlotweaverIONamesConstants.fileExtensionNames.json}',
      ),
    );

    if (!generalFile.existsSync()) {
      final resp = handleVoidOperation(generalFile.createSync);
      if (resp.isSome()) {
        return Left(resp.asSome());
      }
    }

    final generalJsonFileContent = await Isolate.run(
      () => handleCommonOperation(
        () => json.encode(
          generalInfo
              .asRight()
              .copyWith(lastAccessedAt: DateTime.now())
              .toJson(),
        ),
      ),
    );

    // Write GeneralInfo to general_info.json
    if (generalJsonFileContent.isLeft()) {
      return Left(generalJsonFileContent.asLeft());
    } else {
      final resp = await handleVoidAsyncOperation(
        () async => generalFile.writeAsString(
          generalJsonFileContent.asRight(),
        ),
      );
      if (resp.isSome()) {
        return Left(resp.asSome());
      }
    }

    // project.json

    final projectFile = File(
      p.join(
        projectDirectory.path,
        '${PlotweaverIONamesConstants.fileNames.project}.${PlotweaverIONamesConstants.fileExtensionNames.json}',
      ),
    );

    if (!projectFile.existsSync()) {
      final resp = handleVoidOperation(projectFile.createSync);
      if (resp.isSome()) {
        return Left(resp.asSome());
      }
    }

    // Write ProjectEntity to project.json
    if (project.isRight()) {
      final resp = await handleVoidAsyncOperation(
        () async => projectFile.writeAsString(json.encode(projectMapEntry)),
      );
      if (resp.isSome()) {
        return Left(resp.asSome());
      }
    }

    if (characters != null) {
      final resp = await _charactersDataSource.openProjectCharacters(
        identifier,
        characters
            .map(
              (el) => (el as Map).map(
                (key, val) => MapEntry(key.toString(), val),
              ),
            )
            .toList(),
      );
      if (resp.isSome()) {
        return Left(resp.asSome());
      }
    }

    return Right(identifier);
  }

  @override
  Future<Option<PlotweaverError>> consolidateAndSaveToPath({
    required SaveIntentEntity saveIntent,
  }) async {
    final Map<String, dynamic> outputJson = {};
    final file = File(saveIntent.path);

    final currentJsonContent = await _getWeaveJsonContent(saveIntent.path);

    if (currentJsonContent.isLeft()) {
      return Some(currentJsonContent.asLeft());
    }

    if (file.existsSync() &&
        file.statSync().type != FileSystemEntityType.file) {
      // return error if entity under this path does not exist or is not a file
      return Some(
        IOError.fileDoesNotExist(message: S.current.file_does_not_exist),
      );
    } else if (!file.existsSync()) {
      final resp = handleVoidOperation(file.createSync);
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
    }

    final projectDirectoryRes = await sl<AppSupportDirectoriesService>()
        .getProjectDirectory(saveIntent.projectIdentifier);

    if (projectDirectoryRes.isLeft()) {
      return Some(projectDirectoryRes.asLeft());
    }

    final generalEntity =
        await _projectDataSource.getGeneral(saveIntent.projectIdentifier);

    if (generalEntity.isLeft()) {
      return Some(generalEntity.asLeft());
    }

    final generalModifiedJson = handleCommonOperation(
      () => generalEntity
          .asRight()
          .copyWith(
            lastModifiedAt: DateTime.now(),
            lastAccessedAt: DateTime.now(),
            plotweaverVersion: sl<PackageAndDeviceInfoService>().packageVersion,
            weaveVersion: WeaveFileSupport.LATEST_VERSION,
            origin: sl<PackageAndDeviceInfoService>().packageName ?? 'unknown',
          )
          .toJson(),
    );

    if (generalModifiedJson.isLeft()) {
      return Some(generalModifiedJson.asLeft());
    }

    outputJson[PlotweaverIONamesConstants.fileNames.general] =
        generalModifiedJson.asRight();

    // project.json

    if (saveIntent.saveProject) {
      final projectJsonContent = await handleAsynchronousOperation<
          Either<PlotweaverError, Map<String, dynamic>>>(() async {
        final proj =
            await _projectDataSource.getProject(saveIntent.projectIdentifier);
        if (proj.isLeft()) {
          return Left(proj.asLeft());
        }
        return Right(proj.asRight().toJson());
      });

      if (projectJsonContent.isLeft() ||
          projectJsonContent.asRight().isLeft()) {
        return Some(
          IOError.unknownError(message: S.current.unknown_error),
        );
      }

      outputJson[PlotweaverIONamesConstants.fileNames.project] =
          projectJsonContent.asRight().asRight();
    } else {
      outputJson[PlotweaverIONamesConstants.fileNames.project] =
          currentJsonContent
              .asRight()[PlotweaverIONamesConstants.fileNames.project];
    }

    // TODO: consolidate other files

    if (saveIntent.saveCharactersIds.isNotEmpty) {
      final consolidateCharactersResp =
          await _charactersDataSource.consolidateCharacters(
        saveIntent.projectIdentifier,
        saveIntent.saveCharactersIds,
      );

      if (consolidateCharactersResp.isRight()) {
        if (consolidateCharactersResp.asRight().isNotEmpty) {
          outputJson[PlotweaverIONamesConstants.directoryNames.characters] =
              consolidateCharactersResp.asRight();
        } else {
          outputJson[PlotweaverIONamesConstants.directoryNames.characters] =
              currentJsonContent.asRight()[
                  PlotweaverIONamesConstants.directoryNames.characters];
        }
      } else {
        outputJson[PlotweaverIONamesConstants.directoryNames.characters] =
            currentJsonContent.asRight()[
                PlotweaverIONamesConstants.directoryNames.characters];
      }
    } else if (saveIntent.deleteCharactersIds.isNotEmpty) {
      outputJson[PlotweaverIONamesConstants.directoryNames.characters] = [
        ...(currentJsonContent.asRight()[
                PlotweaverIONamesConstants.directoryNames.characters] ??
            []),
      ]..removeWhere(
          (el) => saveIntent.deleteCharactersIds.contains((el as Map)['id']),
        );
    } else {
      outputJson[PlotweaverIONamesConstants.directoryNames.characters] =
          currentJsonContent
              .asRight()[PlotweaverIONamesConstants.directoryNames.characters];
    }

    final outputSerialized = await Isolate.run(
      () => handleCommonOperation(() => json.encode(outputJson)),
    );

    if (outputSerialized.isLeft()) {
      return Some(outputSerialized.asLeft());
    } else {
      final resp = await handleAsynchronousOperation(
        () => file.writeAsString(outputSerialized.asRight()),
      );

      if (resp.isLeft()) {
        return Some(resp.asLeft());
      }
    }

    return const None();
  }
}
