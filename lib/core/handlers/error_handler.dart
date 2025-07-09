import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../errors/plotweaver_errors.dart';

Either<PlotweaverError, T> handleCommonOperation<T>(
  ValueGetter<T> operation,
) {
  try {
    final output = operation.call();
    return Right(output);
  } on PlotweaverError catch (e) {
    return Left(e);
  } catch (e) {
    return Left(_handleCommonExceptions(e));
  }
}

Future<Either<PlotweaverError, T>> handleAsynchronousOperation<T>(
  ValueGetter<Future<T>> operation,
) async {
  try {
    final output = await operation.call();
    return Right(output);
  } on PlotweaverError catch (e) {
    return Left(e);
  } catch (e) {
    return Left(_handleCommonExceptions(e));
  }
}

Future<Option<PlotweaverError>> handleVoidAsyncOperation(
  ValueGetter<Future<void>> operation,
) async {
  try {
    await operation.call();
    return const None();
  } on PlotweaverError catch (e) {
    return Some(e);
  } catch (e) {
    return Some(_handleCommonExceptions(e));
  }
}

Option<PlotweaverError> handleVoidOperation(
  ValueGetter<void> operation,
) {
  try {
    operation.call();
    return const None();
  } on PlotweaverError catch (e) {
    return Some(e);
  } catch (e) {
    return Some(_handleCommonExceptions(e));
  }
}

PlotweaverError _handleCommonExceptions(Object e) {
  log(e.toString());
  if (e is FormatException) {
    return const IOError.parseError();
  } else if (e is FileSystemException) {
    if (e.osError != null) {
      switch (e.osError!.errorCode) {
        case -1:
          return IOError.unknownError(message: e.osError!.message);

        default:
          return IOError.unknownError(message: e.osError!.message);
      }
    }
  }
  return const UnknownError();
}
