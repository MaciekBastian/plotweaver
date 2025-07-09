import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/dropdown_property_widget.dart';
import '../../domain/enums/project_enums.dart';

class ProjectStatusSelectorWidget extends StatelessWidget {
  const ProjectStatusSelectorWidget({
    required this.selected,
    required this.onSelection,
    super.key,
  });

  final ProjectStatus selected;
  final void Function(ProjectStatus status) onSelection;

  @override
  Widget build(BuildContext context) {
    return DropdownPropertyWidget<ProjectStatus>(
      onSelected: onSelection,
      description: S.of(context).project_status_hint,
      icon: const Icon(Icons.check_box_outlined),
      title: S.of(context).project_status,
      selected: selected,
      selectedBuilder: (context, element) {
        if (element == null) {
          return Container();
        }
        final color = context.colors.projectStatusColors[element.value]!;
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
            decoration: BoxDecoration(
              border: Border.all(
                color: color,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: color.withOpacity(0.2),
            ),
            child: Text(
              element.title,
              style: context.textStyle.caption.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
      values: [
        DropdownElement(
          title: S.of(context).project_status_idle,
          value: ProjectStatus.idle,
          description: S.of(context).project_status_idle_hint,
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.shadedBackgroundColor,
              border: Border.all(
                color: context.colors.projectStatusColors[ProjectStatus.idle]!,
                width: 4,
              ),
            ),
          ),
        ),
        DropdownElement(
          title: S.of(context).project_status_on_track,
          value: ProjectStatus.onTrack,
          description: S.of(context).project_status_on_track_hint,
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.shadedBackgroundColor,
              border: Border.all(
                color:
                    context.colors.projectStatusColors[ProjectStatus.onTrack]!,
                width: 4,
              ),
            ),
          ),
        ),
        DropdownElement(
          title: S.of(context).project_status_off_track,
          value: ProjectStatus.offTrack,
          description: S.of(context).project_status_off_track_hint,
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.shadedBackgroundColor,
              border: Border.all(
                color:
                    context.colors.projectStatusColors[ProjectStatus.offTrack]!,
                width: 4,
              ),
            ),
          ),
        ),
        DropdownElement(
          title: S.of(context).project_status_rejected,
          value: ProjectStatus.rejected,
          description: S.of(context).project_status_rejected_hint,
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.shadedBackgroundColor,
              border: Border.all(
                color:
                    context.colors.projectStatusColors[ProjectStatus.rejected]!,
                width: 4,
              ),
            ),
          ),
        ),
        DropdownElement(
          title: S.of(context).project_status_completed,
          value: ProjectStatus.completed,
          description: S.of(context).project_status_completed_hint,
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.shadedBackgroundColor,
              border: Border.all(
                color: context
                    .colors.projectStatusColors[ProjectStatus.completed]!,
                width: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
