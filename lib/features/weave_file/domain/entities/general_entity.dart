import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/weave_file_support.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../generated/l10n.dart';

part 'general_entity.freezed.dart';

@Freezed(
  toJson: false,
  fromJson: false,
)
class GeneralEntity with _$GeneralEntity {
  factory GeneralEntity({
    required String projectIdentifier,
    required DateTime createdAt,
    required String weaveVersion,
    required String origin,
    DateTime? lastAccessedAt,
    DateTime? lastModifiedAt,
    String? plotweaverVersion,
    @Default(false) bool allowChangesFromOutdatedClients,
    Map<String, dynamic>? other,
  }) = _GeneralEntity;

  const GeneralEntity._();

  factory GeneralEntity.fromJson(Map<String, dynamic> json) {
    final createdAtVal = json[_GeneralEntityJsonKeys.createdAt] == null
        ? null
        : DateTime.tryParse(json[_GeneralEntityJsonKeys.createdAt]);
    final weaveVersionVal =
        json[_GeneralEntityJsonKeys.weaveVersion] as String?;
    final originVal = json[_GeneralEntityJsonKeys.origin] as String?;
    final projectIdentifierVal =
        json[_GeneralEntityJsonKeys.projectIdentifier] as String?;
    final supportFromOutdatedVal =
        (json[_GeneralEntityJsonKeys.allowChangesFromOutdatedClients]
                as bool?) ??
            false;

    if (weaveVersionVal == null ||
        createdAtVal == null ||
        projectIdentifierVal == null ||
        originVal == null) {
      throw WeaveError.formattingError(
        message: S.current.weave_file_formatting_error,
      );
    }

    final isSupported = WeaveFileSupport().isSupported(
      weaveVersionVal,
      supportFromOutdatedVal,
    );

    if (!isSupported) {
      final isOutdated = WeaveFileSupport().isClientOutdated(weaveVersionVal);
      if (isOutdated) {
        throw WeaveError.unsupportedNewVersion(
          message: S.current.weave_file_unsupported,
        );
      }
      throw WeaveError.unsupportedDeprecatedVersion(
        message: S.current.weave_file_unsupported,
      );
    }

    final otherValues = {...json}..removeWhere(
        (key, _) => _GeneralEntityJsonKeys.allKeys.contains(key),
      );

    return GeneralEntity(
      projectIdentifier: projectIdentifierVal,
      createdAt: createdAtVal,
      weaveVersion: weaveVersionVal,
      origin: originVal,
      lastAccessedAt: json[_GeneralEntityJsonKeys.lastAccessedAt] == null
          ? null
          : DateTime.tryParse(json[_GeneralEntityJsonKeys.lastAccessedAt]),
      lastModifiedAt: json[_GeneralEntityJsonKeys.lastModifiedAt] == null
          ? null
          : DateTime.tryParse(json[_GeneralEntityJsonKeys.lastModifiedAt]),
      plotweaverVersion: json[_GeneralEntityJsonKeys.plotweaverVersion],
      other: otherValues,
    );
  }

  Map<String, dynamic> toJson() => {
        _GeneralEntityJsonKeys.projectIdentifier: projectIdentifier,
        _GeneralEntityJsonKeys.createdAt: createdAt.toUtc().toIso8601String(),
        _GeneralEntityJsonKeys.weaveVersion: weaveVersion,
        _GeneralEntityJsonKeys.origin: origin,
        _GeneralEntityJsonKeys.lastAccessedAt:
            lastAccessedAt?.toUtc().toIso8601String(),
        _GeneralEntityJsonKeys.lastModifiedAt:
            lastModifiedAt?.toUtc().toIso8601String(),
        _GeneralEntityJsonKeys.plotweaverVersion: plotweaverVersion,
        _GeneralEntityJsonKeys.allowChangesFromOutdatedClients:
            allowChangesFromOutdatedClients,
        if (other != null) ...other!,
      };
}

final class _GeneralEntityJsonKeys {
  static const projectIdentifier = 'project_identifier';
  static const createdAt = 'created_at';
  static const weaveVersion = 'weave_version';
  static const lastAccessedAt = 'last_accessed_at';
  static const lastModifiedAt = 'last_modified_at';
  static const origin = 'origin';
  static const plotweaverVersion = 'plotweaver_version';
  static const allowChangesFromOutdatedClients =
      'allow_changes_from_outdated_clients';

  static const allKeys = [
    createdAt,
    weaveVersion,
    lastAccessedAt,
    lastModifiedAt,
    plotweaverVersion,
    allowChangesFromOutdatedClients,
  ];
}
