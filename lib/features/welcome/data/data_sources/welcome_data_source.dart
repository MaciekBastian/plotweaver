import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path/path.dart' as p;

import '../../../../core/config/sl_config.dart';
import '../../../../core/constants/io_names_constants.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../../core/handlers/error_handler.dart';
import '../../../../core/services/app_support_directories_service.dart';

class WelcomeDataSource {
  Future<Either<PlotweaverError, File>> getRecentProjectsFile() async {
    final dir = await sl<AppSupportDirectoriesService>().getRootDirectory();
    if (dir.isLeft()) {
      return Left(dir.asLeft());
    }

    final preferencesDir = Directory(
      p.join(
        dir.asRight().path,
        PlotweaverIONamesConstants.directoryNames.preferences,
      ),
    );

    if (!preferencesDir.existsSync()) {
      final resp = await handleAsynchronousOperation(preferencesDir.create);
      if (resp.isLeft()) {
        return Left(resp.asLeft());
      }
    }

    final recentProjectsFile = File(
      p.join(
        preferencesDir.path,
        '${PlotweaverIONamesConstants.fileNames.recentProjects}.${PlotweaverIONamesConstants.fileExtensionNames.json}',
      ),
    );

    return Right(recentProjectsFile);
  }
}
