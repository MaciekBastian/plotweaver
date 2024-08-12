import 'package:freezed_annotation/freezed_annotation.dart';

part 'plotweaver_errors.freezed.dart';

abstract class PlotweaverError implements Exception {
  const PlotweaverError();

  String? get message;
}

/// Class for errors related to weave files
@freezed
class WeaveError extends PlotweaverError with _$WeaveError {
  /// Weave file has wrong format or is not a weave file
  const factory WeaveError.formattingError({
    required String message,
  }) = _WeaveFormattingError;

  /// A file is not a weave file
  const factory WeaveError.notAWeaveFile({
    required String message,
  }) = _NotAWeaveFile;

  /// Weave file has version lower than minimum supported bound
  const factory WeaveError.unsupportedDeprecatedVersion({
    required String message,
  }) = _WeaveUnsupportedDeprecatedVersion;

  /// Weave file has newer version than latest supported and is not allowing writes from outdated clients
  const factory WeaveError.unsupportedNewVersion({
    required String message,
  }) = _WeaveUnsupportedNewVersion;

  const WeaveError._();
}

/// Class for errors related to i/o
@freezed
class IOError extends PlotweaverError with _$IOError {
  /// Parse error
  const factory IOError.parseError() = _IOParseError;

  /// file does not exist error
  const factory IOError.fileDoesNotExist({
    required String message,
  }) = _IOFileDoesNotExist;

  /// Unknown IO error
  const factory IOError.unknownError({
    required String message,
  }) = _IOUnknownError;

  const IOError._();

  @override
  String? get message => maybeWhen(
        orElse: () => null,
        fileDoesNotExist: (message) => message,
        unknownError: (message) => message,
      );
}

/// Class for any unknown, uncaught errors
@freezed
class UnknownError extends PlotweaverError with _$UnknownError {
  const factory UnknownError({String? message}) = _UnknownError;
}
