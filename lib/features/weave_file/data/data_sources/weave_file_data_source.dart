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

class WeaveFileDataSource {
  Future<Either<PlotweaverError, File>> getFile(
    String identifier,
    String fileNameBase, [
    String? subdirectory,
  ]) async {
    final projectDirectoryRes = await sl<AppSupportDirectoriesService>()
        .getProjectDirectory(identifier, subdirectory: subdirectory);

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

  Future<Either<PlotweaverError, Map<String, dynamic>>> getFileJson(
    String identifier,
    String fileNameBase,
    bool createEmptyFile, [
    String? subdirectory,
  ]) async {
    final fileResp = await getFile(identifier, fileNameBase, subdirectory);
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

  Future<Option<PlotweaverError>> deleteRollback(
    String identifier,
    String fileNameBase, [
    String? subdirectory,
  ]) async {
    final fileResp = await getFile(identifier, fileNameBase, subdirectory);

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
}
