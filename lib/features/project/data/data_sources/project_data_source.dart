import 'package:dartz/dartz.dart';

import '../../../../core/constants/io_names_constants.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../../core/handlers/error_handler.dart';
import '../../../weave_file/data/data_sources/weave_file_data_source.dart';
import '../../../weave_file/domain/entities/general_entity.dart';
import '../../domain/entities/project_entity.dart';

class ProjectDataSource {
  final _weaveDataSource = WeaveFileDataSource();

  Future<Either<PlotweaverError, GeneralEntity>> getGeneral(
    String identifier,
  ) async {
    final jsonContent = await _weaveDataSource.getFileJson(
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

    final jsonContent = await _weaveDataSource.getFileJson(
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

      final fileResp = await _weaveDataSource.getFile(
        identifier,
        PlotweaverIONamesConstants.fileNames.project,
      );

      if (fileResp.isLeft()) {
        return Left(fileResp.asLeft());
      }

      final rollbackFileResp =
          await _weaveDataSource.getFile(identifier, fileNameBase);

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

  Future<Option<PlotweaverError>> deleteProjectRollback(
    String identifier,
  ) {
    final fileNameBase =
        '${PlotweaverIONamesConstants.fileNames.rollback}${PlotweaverIONamesConstants.fileNames.project}';

    return _weaveDataSource.deleteRollback(identifier, fileNameBase);
  }
}
