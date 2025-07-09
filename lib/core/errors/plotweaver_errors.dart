import 'package:freezed_annotation/freezed_annotation.dart';

part 'plotweaver_errors.freezed.dart';

abstract class PlotweaverError implements Exception {
  const PlotweaverError();

  String? get message;
}

/// Class for errors related to weave files
@freezed
sealed class WeaveError extends PlotweaverError with _$WeaveError {
  /// Weave file has wrong format or is not a weave file
  const factory WeaveError.formattingError({
    required String message,
  }) = WeaveFormattingError;

  /// A file is not a weave file
  const factory WeaveError.notAWeaveFile({
    required String message,
  }) = NotAWeaveFileError;

  /// Weave file has version lower than minimum supported bound
  const factory WeaveError.unsupportedDeprecatedVersion({
    required String message,
  }) = WeaveUnsupportedDeprecatedVersionError;

  /// Weave file has newer version than latest supported and is not allowing writes from outdated clients
  const factory WeaveError.unsupportedNewVersion({
    required String message,
  }) = WeaveUnsupportedNewVersionError;

  const WeaveError._();
}

/// Class for errors related to i/o
@freezed
sealed class IOError extends PlotweaverError with _$IOError {
  /// Parse error
  const factory IOError.parseError() = IOParseError;

  /// file does not exist error
  const factory IOError.fileDoesNotExist({
    required String message,
  }) = IOFileDoesNotExist;

  /// Unknown IO error
  const factory IOError.unknownError({
    required String message,
  }) = IOUnknownError;

  const IOError._();

  @override
  String? get message => switch (this) {
        IOParseError(:final message) => message,
        IOFileDoesNotExist(:final message) => message,
        IOUnknownError(:final message) => message,
      };
}

/// Class for any unknown, uncaught errors
@freezed
sealed class UnknownError extends PlotweaverError with _$UnknownError {
  const factory UnknownError({String? message}) = _UnknownError;

  const UnknownError._();
}
