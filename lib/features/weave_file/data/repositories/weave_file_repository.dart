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
import '../../domain/entities/general_entity.dart';

/// A repository responsible only for reading, writing, scattering and consolidating weave files.
abstract class WeaveFileRepository {
  /// Returns an identifier of the project
  Future<Either<PlotweaverError, String>> readFile(String path);

  /// Consolidates files with project identifier into `path`
  Future<Option<PlotweaverError>> consolidateAndSaveToPath(
    String path,
    String projectIdentifier,
  );
}

@Singleton(as: WeaveFileRepository)
class WeaveFileRepositoryImpl implements WeaveFileRepository {
  Future<Either<PlotweaverError, Directory>> _getProjectDirectory(
    String identifier,
  ) async {
    final rootDir =
        await sl<AppSupportDirectoriesService>().getWorkingDirectory();

    if (rootDir.isLeft()) {
      return Left(rootDir.asLeft());
    }

    final projectDirectory = Directory(
      p.join(
        rootDir.asRight().path,
        identifier,
      ),
    );

    if (!projectDirectory.existsSync()) {
      final resp = handleVoidOperation(projectDirectory.createSync);
      if (resp.isSome()) {
        return Left(resp.asSome());
      }
    }

    return Right(projectDirectory);
  }

  @override
  Future<Either<PlotweaverError, String>> readFile(String path) async {
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

    final generalInfoMapEntry = (jsonContent.asRight()
        as Map<String, dynamic>)[PlotweaverIONamesConstants.fileNames.general];

    if (generalInfoMapEntry == null || generalInfoMapEntry is! Map) {
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

    if (generalInfo.isLeft()) {
      return Left(generalInfo.asLeft());
    }

    final identifier = generalInfo.asRight().projectIdentifier;

    final projectDirectoryRes = await _getProjectDirectory(identifier);

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

    return Right(identifier);
  }

  @override
  Future<Option<PlotweaverError>> consolidateAndSaveToPath(
    String path,
    String projectIdentifier,
  ) async {
    final Map<String, dynamic> outputJson = {};
    final file = File(path);

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

    final projectDirectoryRes = await _getProjectDirectory(projectIdentifier);

    if (projectDirectoryRes.isLeft()) {
      return Some(projectDirectoryRes.asLeft());
    }

    final projectDirectory = projectDirectoryRes.asRight();

    final generalFile = File(
      p.join(
        projectDirectory.path,
        '${PlotweaverIONamesConstants.fileNames.general}.${PlotweaverIONamesConstants.fileExtensionNames.json}',
      ),
    );

    if (!generalFile.existsSync()) {
      return Some(
        IOError.fileDoesNotExist(message: S.current.file_does_not_exist),
      );
    }

    final generalFileContent = await handleAsynchronousOperation(
      generalFile.readAsString,
    );

    if (generalFileContent.isLeft()) {
      return Some(
        IOError.unknownError(message: S.current.unknown_error),
      );
    }

    final generalJsonContent = await Isolate.run(
      () => handleCommonOperation(
        () => json.decode(generalFileContent.asRight()),
      ),
    );

    if (generalJsonContent.isLeft()) {
      return Some(
        IOError.unknownError(message: S.current.unknown_error),
      );
    }

    final generalEntity = handleCommonOperation(
      () => GeneralEntity.fromJson(
        generalJsonContent.asRight() as Map<String, dynamic>,
      ),
    );

    if (generalEntity.isLeft()) {
      return Some(generalEntity.asLeft());
    }

    final generalModifiedJson = handleCommonOperation(
      () => generalEntity
          .asRight()
          .copyWith(
            lastModifiedAt: DateTime.now(),
            plotweaverVersion: sl<PackageAndDeviceInfoService>().packageVersion,
            weaveVersion: WeaveFileSupport.LATEST_VERSION,
          )
          .toJson(),
    );

    if (generalModifiedJson.isLeft()) {
      return Some(generalModifiedJson.asLeft());
    }

    outputJson[PlotweaverIONamesConstants.fileNames.general] =
        generalModifiedJson.asRight();

    // TODO: consolidate other files

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
