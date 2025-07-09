import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../generated/l10n.dart';
import '../enums/project_enums.dart';

part 'project_entity.freezed.dart';

@Freezed(
  toJson: false,
  fromJson: false,
)
sealed class ProjectEntity with _$ProjectEntity {
  factory ProjectEntity({
    required String title,
    required ProjectTemplate template,
    String? description,
    String? author,
    @Default(ProjectStatus.idle) ProjectStatus status,
    Map<String, dynamic>? other,
  }) = _ProjectEntity;

  const ProjectEntity._();

  factory ProjectEntity.fromJson(Map<String, dynamic> json) {
    final titleVal = json[_ProjectEntityJsonKeys.title] as String?;
    final templateVal = json[_ProjectEntityJsonKeys.template] == null
        ? null
        : ProjectTemplate.fromCode(json[_ProjectEntityJsonKeys.template]);

    if (titleVal == null || templateVal == null) {
      throw WeaveError.formattingError(
        message: S.current.weave_file_formatting_error,
      );
    }

    final otherValues = {...json}..removeWhere(
        (key, _) => _ProjectEntityJsonKeys.allKeys.contains(key),
      );

    final statusVal = json[_ProjectEntityJsonKeys.status] == null
        ? null
        : ProjectStatus.fromCode(
            json[_ProjectEntityJsonKeys.status],
          );

    return ProjectEntity(
      template: templateVal,
      title: titleVal,
      author: json[_ProjectEntityJsonKeys.author],
      description: json[_ProjectEntityJsonKeys.description],
      status: statusVal ?? ProjectStatus.idle,
      other: otherValues,
    );
  }

  Map<String, dynamic> toJson() => {
        _ProjectEntityJsonKeys.title: title,
        _ProjectEntityJsonKeys.template: template.code,
        _ProjectEntityJsonKeys.status: status.code,
        if (author != null) _ProjectEntityJsonKeys.author: author,
        if (description != null)
          _ProjectEntityJsonKeys.description: description,
        if (other != null) ...other!,
      };
}

final class _ProjectEntityJsonKeys {
  static const title = 'title';
  static const author = 'author';
  static const description = 'description';
  static const status = 'status';
  static const template = 'template';

  static const allKeys = [
    title,
    author,
    description,
    status,
    template,
  ];
}
