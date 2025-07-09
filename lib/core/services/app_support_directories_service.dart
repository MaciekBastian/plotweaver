import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

import '../constants/io_names_constants.dart';
import '../errors/plotweaver_errors.dart';
import '../extensions/dartz_extension.dart';
import '../handlers/error_handler.dart';

abstract class AppSupportDirectoriesService {
  Future<Either<PlotweaverError, Directory>> getRootDirectory();

  /// Gets root directory for working files (for projects)
  Future<Either<PlotweaverError, Directory>> getWorkingDirectory();

  Future<Either<PlotweaverError, Directory>> getProjectDirectory(
    String identifier, {
    String? subdirectory,
  });
}

@Singleton(as: AppSupportDirectoriesService)
class AppSupportDirectoriesServiceImpl implements AppSupportDirectoriesService {
  @override
  Future<Either<PlotweaverError, Directory>> getRootDirectory() =>
      handleAsynchronousOperation(
        () async {
          final dir = await pp.getApplicationSupportDirectory();
          if (!dir.existsSync()) {
            dir.createSync(recursive: true);
          }
          return dir;
        },
      );

  @override
  Future<Either<PlotweaverError, Directory>> getWorkingDirectory() async {
    final root = await getRootDirectory();
    if (root.isLeft()) {
      return Left(root.asLeft());
    } else {
      final weaveDir = Directory(
        p.join(
          root.asRight().path,
          PlotweaverIONamesConstants.directoryNames.openedWeaveFiles,
        ),
      );

      if (!weaveDir.existsSync()) {
        final resp = handleVoidOperation(weaveDir.createSync);
        if (resp.isSome()) {
          return Left(resp.asSome());
        }
      }

      return Right(weaveDir);
    }
  }

  @override
  Future<Either<PlotweaverError, Directory>> getProjectDirectory(
    String identifier, {
    String? subdirectory,
  }) async {
    final rootDir = await getWorkingDirectory();

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

    if (subdirectory != null) {
      final subDir = Directory(
        p.join(
          projectDirectory.path,
          subdirectory,
        ),
      );

      if (!subDir.existsSync()) {
        final resp = handleVoidOperation(subDir.createSync);
        if (resp.isSome()) {
          return Left(resp.asSome());
        }
      }

      return Right(subDir);
    }

    return Right(projectDirectory);
  }
}
