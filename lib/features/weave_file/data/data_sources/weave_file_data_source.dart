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
import '../../../project/domain/entities/project_entity.dart';
import '../../domain/entities/general_entity.dart';

class WeaveFileDataSource {
  Future<Either<PlotweaverError, File>> _getFile(
    String identifier,
    String fileNameBase,
  ) async {
    final projectDirectoryRes = await sl<AppSupportDirectoriesService>()
        .getProjectDirectory(identifier);

    if (projectDirectoryRes.isLeft()) {
      return Left(projectDirectoryRes.asLeft());
    }

    final projectDirectory = projectDirectoryRes.asRight();

    final outputFile = File(
      p.join(
        projectDirectory.path,
        '$fileNameBase.${PlotweaverIONamesConstants.fileExtensionNames.json}',
      ),
    );

    return Right(outputFile);
  }

  Future<Either<PlotweaverError, Map<String, dynamic>>> _getFileJson(
    String identifier,
    String fileNameBase,
    bool createEmptyFile,
  ) async {
    final fileResp = await _getFile(identifier, fileNameBase);
    if (fileResp.isLeft()) {
      return Left(fileResp.asLeft());
    }

    final outputFile = fileResp.asRight();

    if (!outputFile.existsSync()) {
      if (createEmptyFile) {
        final resp = handleVoidOperation(outputFile.createSync);
        if (resp.isSome()) {
          return Left(resp.asSome());
        }
        final emptyWriteResp = handleVoidOperation(
          () => outputFile.writeAsStringSync('{}'),
        );
        if (emptyWriteResp.isSome()) {
          return Left(resp.asSome());
        }
        return const Right({});
      } else {
        return Left(
          IOError.fileDoesNotExist(message: S.current.file_does_not_exist),
        );
      }
    }

    final outputFileContent = await handleAsynchronousOperation(
      outputFile.readAsString,
    );

    if (outputFileContent.isLeft()) {
      return Left(
        IOError.unknownError(message: S.current.unknown_error),
      );
    }

    final outputJsonContent = await Isolate.run(
      () => handleCommonOperation(
        () => json.decode(outputFileContent.asRight()),
      ),
    );

    if (outputJsonContent.isLeft()) {
      return Left(
        IOError.unknownError(message: S.current.unknown_error),
      );
    }

    return Right(
      (outputJsonContent.asRight() as Map).map(
        (key, val) => MapEntry(key.toString(), val),
      ),
    );
  }

  Future<Either<PlotweaverError, GeneralEntity>> getGeneral(
    String identifier,
  ) async {
    final jsonContent = await _getFileJson(
      identifier,
      PlotweaverIONamesConstants.fileNames.general,
      false,
    );
    if (jsonContent.isLeft()) {
      return Left(jsonContent.asLeft());
    }

    final generalEntity = handleCommonOperation(
      () => GeneralEntity.fromJson(jsonContent.asRight()),
    );

    return generalEntity;
  }

  Future<Either<PlotweaverError, ProjectEntity>> getProject(
    String identifier, [
    bool rollback = false,
  ]) async {
    final fileNameBase =
        '${rollback ? PlotweaverIONamesConstants.fileNames.rollback : ''}${PlotweaverIONamesConstants.fileNames.project}';

    final jsonContent = await _getFileJson(
      identifier,
      fileNameBase,
      rollback,
    );
    if (jsonContent.isLeft()) {
      return Left(jsonContent.asLeft());
    }

    if (jsonContent.asRight().isEmpty && rollback) {
      final projectResp = await getProject(identifier);
      if (projectResp.isLeft()) {
        return Left(projectResp.asLeft());
      }

      final fileResp = await _getFile(
        identifier,
        PlotweaverIONamesConstants.fileNames.project,
      );

      if (fileResp.isLeft()) {
        return Left(fileResp.asLeft());
      }

      final rollbackFileResp = await _getFile(identifier, fileNameBase);

      if (rollbackFileResp.isLeft()) {
        return Left(rollbackFileResp.asLeft());
      }

      final copyResp = await handleAsynchronousOperation(
        () => fileResp.asRight().copy(rollbackFileResp.asRight().path),
      );

      if (copyResp.isLeft()) {
        return Left(copyResp.asLeft());
      }

      return Right(projectResp.asRight());
    }

    final projectEntity = handleCommonOperation(
      () => ProjectEntity.fromJson(jsonContent.asRight()),
    );

    return projectEntity;
  }

  Future<Option<PlotweaverError>> _deleteRollback(
    String identifier,
    String fileNameBase,
  ) async {
    final fileResp = await _getFile(identifier, fileNameBase);

    if (fileResp.isLeft()) {
      return Some(fileResp.asLeft());
    }
    if (fileResp.asRight().existsSync()) {
      final deleteResp =
          await handleAsynchronousOperation(() => fileResp.asRight().delete());

      if (deleteResp.isLeft()) {
        return Some(deleteResp.asLeft());
      }
    }

    return const None();
  }

  Future<Option<PlotweaverError>> deleteProjectRollback(
    String identifier,
  ) {
    final fileNameBase =
        '${PlotweaverIONamesConstants.fileNames.rollback}${PlotweaverIONamesConstants.fileNames.project}';

    return _deleteRollback(identifier, fileNameBase);
  }
}
