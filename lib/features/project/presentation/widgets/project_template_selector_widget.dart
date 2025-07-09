import 'package:flutter/cupertino.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/dropdown_property_widget.dart';
import '../../domain/enums/project_enums.dart';

class ProjectTemplateSelectorWidget extends StatelessWidget {
  const ProjectTemplateSelectorWidget({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final ProjectTemplate selected;
  final void Function(ProjectTemplate) onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownPropertyWidget(
      onSelected: onSelected,
      description: S.of(context).project_template_hint,
      icon: const Icon(
        CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
      ),
      title: S.of(context).project_template,
      selected: selected,
      values: [
        DropdownElement(
          title: S.of(context).project_template_book,
          value: ProjectTemplate.book,
          description: S.of(context).project_template_book_hint,
          leading: Icon(
            CupertinoIcons.book,
            size: 18,
            color: context.colors.link,
          ),
        ),
        DropdownElement(
          title: S.of(context).project_template_movie,
          value: ProjectTemplate.movie,
          description: S.of(context).project_template_movie_hint,
          leading: Icon(
            CupertinoIcons.film,
            size: 18,
            color: context.colors.link,
          ),
        ),
        DropdownElement(
          title: S.of(context).project_template_series,
          value: ProjectTemplate.series,
          description: S.of(context).project_template_series_hint,
          leading: Icon(
            CupertinoIcons.video_camera,
            size: 18,
            color: context.colors.link,
          ),
        ),
      ],
    );
  }
}
