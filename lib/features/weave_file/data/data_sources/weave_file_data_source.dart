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
  Future<Either<PlotweaverError, Map<String, dynamic>>> _getFileJson(
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

    if (!outputFile.existsSync()) {
      return Left(
        IOError.fileDoesNotExist(message: S.current.file_does_not_exist),
      );
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
    String identifier,
  ) async {
    final jsonContent = await _getFileJson(
      identifier,
      PlotweaverIONamesConstants.fileNames.project,
    );
    if (jsonContent.isLeft()) {
      return Left(jsonContent.asLeft());
    }

    final projectEntity = handleCommonOperation(
      () => ProjectEntity.fromJson(jsonContent.asRight()),
    );

    return projectEntity;
  }
}
