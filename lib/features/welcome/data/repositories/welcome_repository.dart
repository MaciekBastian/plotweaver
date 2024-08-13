import 'dart:convert';
import 'dart:isolate';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../../core/handlers/error_handler.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/recent_project_entity.dart';
import '../data_sources/welcome_data_source.dart';

abstract class WelcomeRepository {
  Future<Either<PlotweaverError, List<RecentProjectEntity>>> getRecent();

  Future<Option<PlotweaverError>> addRecent(RecentProjectEntity entity);

  Future<Option<PlotweaverError>> modifyRecent(RecentProjectEntity entity);

  Future<Option<PlotweaverError>> deleteRecent(RecentProjectEntity entity);
}

@Singleton(as: WelcomeRepository)
class WelcomeRepositoryImpl implements WelcomeRepository {
  WelcomeRepositoryImpl() : _dataSource = WelcomeDataSource();

  final WelcomeDataSource _dataSource;

  @override
  Future<Option<PlotweaverError>> addRecent(RecentProjectEntity entity) async {
    final file = await _dataSource.getRecentProjectsFile();

    if (file.isLeft()) {
      return Some(file.asLeft());
    }

    if (!file.asRight().existsSync()) {
      final resp = handleVoidOperation(file.asRight().createSync);
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
      final emptyWriteResp = handleVoidOperation(
        () => file.asRight().writeAsStringSync('[]'),
      );
      if (emptyWriteResp.isSome()) {
        return Some(resp.asSome());
      }
    }

    final entitySerialized = handleCommonOperation(() => entity.toJson());

    if (entitySerialized.isLeft()) {
      return Some(entitySerialized.asLeft());
    }

    final fileContentDecoded = await Isolate.run(
      () => handleCommonOperation(
        () => json.decode(file.asRight().readAsStringSync()),
      ),
    );

    if (fileContentDecoded.isLeft() || fileContentDecoded.asRight() is! List) {
      if (fileContentDecoded.isLeft()) {
        return Some(fileContentDecoded.asLeft());
      }
      return const Some(IOError.parseError());
    }

    final allRecent = [
      ...fileContentDecoded.asRight() as List,
      entitySerialized.asRight(),
    ];

    final newFileContentEncoded = await Isolate.run(
      () => handleCommonOperation(() => json.encode(allRecent)),
    );

    if (newFileContentEncoded.isLeft()) {
      return Some(newFileContentEncoded.asLeft());
    }

    final resp = await handleVoidAsyncOperation(
      () async => file.asRight().writeAsString(newFileContentEncoded.asRight()),
    );

    if (resp.isSome()) {
      return Some(resp.asSome());
    }

    return const None();
  }

  @override
  Future<Either<PlotweaverError, List<RecentProjectEntity>>> getRecent() async {
    final file = await _dataSource.getRecentProjectsFile();

    if (file.isLeft()) {
      return Left(file.asLeft());
    }

    if (!file.asRight().existsSync()) {
      return const Right([]);
    }

    final fileContentDecoded = await Isolate.run(
      () => handleCommonOperation(
        () => json.decode(file.asRight().readAsStringSync()),
      ),
    );

    if (fileContentDecoded.isLeft() || fileContentDecoded.asRight() is! List) {
      if (fileContentDecoded.isLeft()) {
        return Left(fileContentDecoded.asLeft());
      }
      return const Left(IOError.parseError());
    }

    final List<RecentProjectEntity> allEntities = [];

    for (final element in fileContentDecoded.asRight() as List) {
      if (element is Map) {
        handleCommonOperation(
          () => RecentProjectEntity.fromJson(
            element.map((key, value) => MapEntry(key.toString(), value)),
          ),
        ).fold(
          (_) {},
          allEntities.add,
        );
      }
    }

    allEntities.sort((a, b) => b.lastAccess.compareTo(a.lastAccess));

    return Right(allEntities);
  }

  @override
  Future<Option<PlotweaverError>> modifyRecent(
    RecentProjectEntity entity,
  ) async {
    final file = await _dataSource.getRecentProjectsFile();

    if (file.isLeft()) {
      return Some(file.asLeft());
    }

    if (!file.asRight().existsSync()) {
      final resp = handleVoidOperation(file.asRight().createSync);
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
      final emptyWriteResp = handleVoidOperation(
        () => file.asRight().writeAsStringSync('[]'),
      );
      if (emptyWriteResp.isSome()) {
        return Some(resp.asSome());
      }
    }

    final recent = await getRecent();

    if (recent.isLeft()) {
      return Some(recent.asLeft());
    }

    final index = recent.asRight().indexWhere((el) => el.path == entity.path);

    if (index == -1) {
      return addRecent(entity);
    }

    final newRecent = [...recent.asRight()]
      ..removeAt(index)
      ..insert(index, entity);

    final newFileContentEncoded = await Isolate.run(
      () => handleCommonOperation(() => json.encode(newRecent)),
    );

    if (newFileContentEncoded.isLeft()) {
      return Some(newFileContentEncoded.asLeft());
    }

    final resp = await handleVoidAsyncOperation(
      () async => file.asRight().writeAsString(newFileContentEncoded.asRight()),
    );

    if (resp.isSome()) {
      return Some(resp.asSome());
    }

    return const None();
  }

  @override
  Future<Option<PlotweaverError>> deleteRecent(
    RecentProjectEntity entity,
  ) async {
    final file = await _dataSource.getRecentProjectsFile();

    if (file.isLeft()) {
      return Some(file.asLeft());
    }

    if (!file.asRight().existsSync()) {
      final resp = handleVoidOperation(file.asRight().createSync);
      if (resp.isSome()) {
        return Some(resp.asSome());
      }
      final emptyWriteResp = handleVoidOperation(
        () => file.asRight().writeAsStringSync('[]'),
      );
      if (emptyWriteResp.isSome()) {
        return Some(resp.asSome());
      }
    }

    final recent = await getRecent();

    if (recent.isLeft()) {
      return Some(recent.asLeft());
    }

    final index = recent.asRight().indexWhere((el) => el.path == entity.path);

    if (index == -1) {
      return Some(
        IOError.fileDoesNotExist(message: S.current.file_does_not_exist),
      );
    }

    final newRecent = [...recent.asRight()]..removeAt(index);

    final newFileContentEncoded = await Isolate.run(
      () => handleCommonOperation(() => json.encode(newRecent)),
    );

    if (newFileContentEncoded.isLeft()) {
      return Some(newFileContentEncoded.asLeft());
    }

    final resp = await handleVoidAsyncOperation(
      () async => file.asRight().writeAsString(newFileContentEncoded.asRight()),
    );

    if (resp.isSome()) {
      return Some(resp.asSome());
    }

    return const None();
  }
}
