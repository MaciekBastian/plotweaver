import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart' as pp;

import '../../../../core/constants/io_names_constants.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../../core/handlers/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../../weave_file/domain/usecases/read_weave_file_usecase.dart';
import '../../domain/entities/project_entity.dart';

abstract class ProjectRepository {
  /// Returns PlotweaverError on exception, and ProjectEntity if file was opened successfully. Null if cancelled by the user
  Future<Either<PlotweaverError, ProjectEntity?>> openProject();
}

@LazySingleton(as: ProjectRepository)
class ProjectRepositoryImpl implements ProjectRepository {
  ProjectRepositoryImpl(this._readWeaveFileUsecase);

  final ReadWeaveFileUsecase _readWeaveFileUsecase;
  final _filePicker = FilePicker.platform;

  @override
  Future<Either<PlotweaverError, ProjectEntity?>> openProject() async {
    final res = await handleAsynchronousOperation(
      () async => _filePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          PlotweaverIONamesConstants.fileExtensionNames.weave,
        ],
        allowCompression: false,
        dialogTitle: S.current.open_project,
        lockParentWindow: true,
        withData: true,
        initialDirectory: (await pp.getApplicationDocumentsDirectory()).path,
      ),
    );

    if (res.isLeft()) {
      return Left(res.asLeft());
    }

    if (res.asRight() == null || res.asRight()!.files.isEmpty) {
      return const Right(null);
    }

    final file = res.asRight()!.files.single;
    final extension = file.extension?.toLowerCase() ??
        file.name.substring(file.name.lastIndexOf('.') + 1).toLowerCase();

    if (extension != PlotweaverIONamesConstants.fileExtensionNames.weave) {
      return Left(
        WeaveError.notAWeaveFile(message: S.current.not_a_weave_file),
      );
    }

    final identifier =
        await _readWeaveFileUsecase.call(file.path ?? file.xFile.path);

    if (identifier.isLeft()) {
      return Left(identifier.asLeft());
    }

    // TODO: read project

    return const Right(null);
  }
}
