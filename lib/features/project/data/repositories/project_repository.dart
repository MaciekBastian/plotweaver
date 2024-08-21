import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dartz/dartz.dart';
import 'package:file_selector/file_selector.dart' as fs;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

import '../../../../core/config/sl_config.dart';
import '../../../../core/constants/io_names_constants.dart';
import '../../../../core/constants/weave_file_support.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../../core/handlers/error_handler.dart';
import '../../../../core/services/app_support_directories_service.dart';
import '../../../../core/services/package_and_device_info_service.dart';
import '../../../../generated/l10n.dart';
import '../../../weave_file/domain/entities/general_entity.dart';
import '../../../weave_file/domain/usecases/read_weave_file_usecase.dart';
import '../../../welcome/domain/entities/recent_project_entity.dart';
import '../../../welcome/domain/usecases/add_recent_usecase.dart';
import '../../../welcome/domain/usecases/modify_recent_usecase.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/enums/project_enums.dart';
import '../data_sources/project_data_source.dart';

abstract class ProjectRepository {
  /// Returns PlotweaverError on exception, and ProjectEntity if file was opened successfully. Null if cancelled by the user
  Future<Either<PlotweaverError, (ProjectEntity, String, String)?>>
      openProject([
    String? path,
  ]);

  Future<Either<PlotweaverError, (ProjectEntity, String, String)?>>
      createProject(
    String projectName,
  );

  Future<Either<PlotweaverError, ProjectEntity>> getOpenedProject(
    String identifier,
  );

  Future<Option<PlotweaverError>> modifyProject(
    String identifier,
    ProjectEntity project,
  );

  Future<Option<PlotweaverError>> rollBackProject(String identifier);
}

@LazySingleton(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  ProjectRepositoryImpl(
    this._readWeaveFileUsecase,
    this._addRecentUsecase,
    this._modifyRecentUsecase,
  ) : _dataSource = ProjectDataSource();

  final ReadWeaveFileUsecase _readWeaveFileUsecase;
  final AddRecentUsecase _addRecentUsecase;
  final ModifyRecentUsecase _modifyRecentUsecase;
  final ProjectDataSource _dataSource;

  @override
  Future<Either<PlotweaverError, (ProjectEntity, String, String)?>>
      openProject([
    String? path,
  ]) async {
    late final File file;
    if (path == null) {
      final res = await handleAsynchronousOperation(
        () async => fs.openFile(
          acceptedTypeGroups: [
            fs.XTypeGroup(
              label: S.current.weave_file,
              extensions: [
                PlotweaverIONamesConstants.fileExtensionNames.weave,
              ],
            ),
          ],
          confirmButtonText: S.current.open_project,
          initialDirectory: (await pp.getApplicationDocumentsDirectory()).path,
        ),
      );

      if (res.isLeft()) {
        return Left(res.asLeft());
      }

      if (res.asRight() == null) {
        return const Right(null);
      }
      file = File(res.asRight()!.path);
    } else {
      file = File(path);
      if (!file.existsSync()) {
        return Left(
          IOError.fileDoesNotExist(message: S.current.file_does_not_exist),
        );
      }
    }

    final extension =
        file.path.substring(file.path.lastIndexOf('.') + 1).toLowerCase();

    if (extension != PlotweaverIONamesConstants.fileExtensionNames.weave) {
      return Left(
        WeaveError.notAWeaveFile(message: S.current.not_a_weave_file),
      );
    }

    final identifier = await _readWeaveFileUsecase.call(file.path);

    if (identifier.isLeft()) {
      return Left(identifier.asLeft());
    }

    final project = await _dataSource.getProject(identifier.asRight());

    if (project.isLeft()) {
      return Right((project.asRight(), identifier.asRight(), file.path));
    }

    final recentProjectEntity = RecentProjectEntity(
      path: file.path,
      projectName: project.asRight().title,
      lastAccess: DateTime.now(),
    );

    await _modifyRecentUsecase.call(recentProjectEntity);

    return Right((project.asRight(), identifier.asRight(), file.path));
  }

  @override
  Future<Either<PlotweaverError, (ProjectEntity, String, String)?>>
      createProject(
    String projectName,
  ) async {
    final res = await handleAsynchronousOperation(
      () async => fs.getSaveLocation(
        acceptedTypeGroups: [
          fs.XTypeGroup(
            label: S.current.weave_file,
            extensions: [
              PlotweaverIONamesConstants.fileExtensionNames.weave,
            ],
          ),
        ],
        suggestedName: projectName,
        confirmButtonText: S.current.create_project,
        initialDirectory: (await pp.getApplicationDocumentsDirectory()).path,
      ),
    );

    if (res.isLeft() || res.asRight() == null) {
      if (res.isLeft()) {
        return Left(res.asLeft());
      }
      return const Right(null);
    }

    final file = File(res.asRight()!.path);
    if (!file.existsSync()) {
      final resp = handleVoidOperation(file.createSync);
      if (resp.isSome()) {
        return Left(resp.asSome());
      }
    }

    final projectIdentifier = projectName
        .trim()
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('.', '');

    final projectEntity = ProjectEntity(
      title: projectName,
      template: ProjectTemplate.book,
      author: sl<PackageAndDeviceInfoService>().deviceName,
    );
    final generalEntity = GeneralEntity(
      projectIdentifier: projectIdentifier,
      createdAt: DateTime.now(),
      weaveVersion: WeaveFileSupport.LATEST_VERSION,
      origin: sl<PackageAndDeviceInfoService>().packageName ?? 'unknown',
      plotweaverVersion: sl<PackageAndDeviceInfoService>().packageVersion,
    );

    final recentProjectEntity = RecentProjectEntity(
      path: file.path,
      projectName: projectName,
      lastAccess: DateTime.now(),
    );

    final recentResp = await _addRecentUsecase.call(recentProjectEntity);

    if (recentResp.isSome()) {
      return Left(recentResp.asSome());
    }

    final jsonContent = {
      PlotweaverIONamesConstants.fileNames.general: generalEntity.toJson(),
      PlotweaverIONamesConstants.fileNames.project: projectEntity.toJson(),
    };

    final serialized = await Isolate.run(
      () => handleCommonOperation(() => json.encode(jsonContent)),
    );

    if (serialized.isLeft()) {
      return Left(serialized.asLeft());
    } else {
      final resp = await handleAsynchronousOperation(
        () => file.writeAsString(serialized.asRight()),
      );

      if (resp.isLeft()) {
        return Left(resp.asLeft());
      }
    }

    await _readWeaveFileUsecase.call(file.path);

    return Right((projectEntity, projectIdentifier, file.path));
  }

  @override
  Future<Either<PlotweaverError, ProjectEntity>> getOpenedProject(
    String identifier,
  ) async {
    final deleteRollbackResp =
        await _dataSource.deleteProjectRollback(identifier);

    if (deleteRollbackResp.isSome()) {
      return Left(deleteRollbackResp.asSome());
    }

    final getResp = await _dataSource.getProject(identifier);

    return getResp;
  }

  @override
  Future<Option<PlotweaverError>> modifyProject(
    String identifier,
    ProjectEntity project,
  ) async {
    final projectDirectoryRes = await sl<AppSupportDirectoriesService>()
        .getProjectDirectory(identifier);

    if (projectDirectoryRes.isLeft()) {
      return Some(projectDirectoryRes.asLeft());
    }

    final projectDirectory = projectDirectoryRes.asRight();

    final projectFile = File(
      p.join(
        projectDirectory.path,
        '${PlotweaverIONamesConstants.fileNames.project}.${PlotweaverIONamesConstants.fileExtensionNames.json}',
      ),
    );

    if (!projectFile.existsSync()) {
      final resp = handleVoidOperation(projectFile.createSync);
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
    }

    // create roll back version if necessary
    await _dataSource.getProject(identifier, true);

    final projectEncoded = await Isolate.run(
      () => handleCommonOperation(() => json.encode(project.toJson())),
    );

    // Write ProjectEntity to project.json
    if (projectEncoded.isRight()) {
      final resp = await handleVoidAsyncOperation(
        () async => projectFile.writeAsString(projectEncoded.asRight()),
      );
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
    } else {
      return Some(projectEncoded.asLeft());
    }

    return const None();
  }

  @override
  Future<Option<PlotweaverError>> rollBackProject(String identifier) async {
    final project = await _dataSource.getProject(identifier, true);

    if (project.isLeft()) {
      return Some(project.asLeft());
    }

    final projectDirectoryRes = await sl<AppSupportDirectoriesService>()
        .getProjectDirectory(identifier);

    if (projectDirectoryRes.isLeft()) {
      return Some(projectDirectoryRes.asLeft());
    }

    final projectDirectory = projectDirectoryRes.asRight();

    final projectFile = File(
      p.join(
        projectDirectory.path,
        '${PlotweaverIONamesConstants.fileNames.project}.${PlotweaverIONamesConstants.fileExtensionNames.json}',
      ),
    );

    if (!projectFile.existsSync()) {
      final resp = handleVoidOperation(projectFile.createSync);
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
    }

    final projectEncoded = await Isolate.run(
      () =>
          handleCommonOperation(() => json.encode(project.asRight().toJson())),
    );

    // Write ProjectEntity to project.json
    if (projectEncoded.isRight()) {
      final resp = await handleVoidAsyncOperation(
        () async => projectFile.writeAsString(projectEncoded.asRight()),
      );
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
    } else {
      return Some(projectEncoded.asLeft());
    }

    return const None();
  }
}
