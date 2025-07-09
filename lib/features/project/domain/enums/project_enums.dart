import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../generated/l10n.dart';

enum ProjectStatus {
  idle('idle'),
  onTrack('on_track'),
  offTrack('off_track'),
  rejected('rejected'),
  completed('completed');

  const ProjectStatus(this.code);
  final String code;

  static ProjectStatus fromCode(String code) => ProjectStatus.values
      .firstWhere((el) => el.code == code, orElse: () => ProjectStatus.idle);
}

enum ProjectTemplate {
  book('book'),
  movie('movie'),
  series('series');

  const ProjectTemplate(this.code);
  final String code;

  static ProjectTemplate? fromCode(String code) =>
      ProjectTemplate.values.firstWhere(
        (el) => el.code == code,
        orElse: () => throw WeaveError.formattingError(
          message: S.current.weave_file_formatting_error,
        ),
      );
}
