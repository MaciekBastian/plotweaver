import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/regex_constants.dart';
import '../../../../core/constants/routes_constants.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/overlays/full_screen_alert.dart';
import '../../../../shared/overlays/prompt_overlay.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../../project/domain/entities/current_project_entity.dart';
import '../../../project/presentation/bloc/current_project/current_project_bloc.dart';
import '../../../project/presentation/cubit/project_files_cubit.dart';
import '../bloc/quick_start/quick_start_bloc.dart';
import '../bloc/recent_projects/recent_projects_bloc.dart';

class QuickStartWidget extends StatelessWidget {
  const QuickStartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuickStartBloc, QuickStartState>(
      listener: (context, state) {
        context
            .read<RecentProjectsBloc>()
            .add(const RecentProjectsEvent.loadRecent());
        switch (state) {
          case QuickStartStateInitial():
            Navigator.of(context).pop();
            break;
          case QuickStartStateSuccess(
              :final project,
              :final identifier,
              :final path,
            ):
            // hiding the dialog
            Navigator.of(context).pop();
            context.read<CurrentProjectBloc>().add(
                  CurrentProjectEvent.openProject(
                    CurrentProjectEntity(
                      projectName: project.title,
                      identifier: identifier,
                      path: path,
                    ),
                  ),
                );
            context.read<ProjectFilesCubit>().checkAndLoadAllFiles(identifier);
            context.replace(PlotweaverRoutes.editor);
            break;
          case QuickStartStateLocked(:final shouldShowBackdrop):
            showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: shouldShowBackdrop ? null : Colors.transparent,
              builder: (context) {
                return Container();
              },
            );
            break;
          case QuickStartStateFailure(:final error):
            Navigator.of(context).pop();
            if (error is IOFileDoesNotExist) {
              showFullscreenError(error);
            }
            break;
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.rocket_launch_outlined,
                  size: 18,
                  color: context.colors.onScaffoldBackgroundColor,
                ),
                const SizedBox(width: 5),
                Text(
                  S.of(context).quick_start,
                  style: context.textStyle.h6,
                ),
              ],
            ),
            Divider(color: context.colors.dividerColor),
            _QuickStartButton(
              icon: Icons.folder_outlined,
              onTap: () {
                context
                    .read<QuickStartBloc>()
                    .add(const QuickStartEvent.openProject());
              },
              title: S.of(context).open_project,
            ),
            const SizedBox(height: 5),
            _QuickStartButton(
              icon: Icons.create_outlined,
              onTap: () {
                PromptOverlay(
                  context: context,
                  title: S.of(context).create_project,
                  message: S.of(context).project_name_hint,
                  validator: (content) {
                    if (!RegexConstants.projectNameRegex.hasMatch(content)) {
                      return S.of(context).project_name_format_error;
                    }
                    return null;
                  },
                  onSubmit: (name) {
                    context
                        .read<QuickStartBloc>()
                        .add(QuickStartEvent.createProject(name.trim()));
                  },
                ).show();
              },
              title: S.of(context).create_project,
            ),
            const SizedBox(height: 10),
            switch (state) {
              QuickStartStateFailure(:final error) => Text(
                  error.message ?? S.of(context).unknown_error,
                  style: context.textStyle.body.copyWith(
                    color: context.colors.error,
                  ),
                  textAlign: TextAlign.left,
                ),
              _ => const SizedBox.shrink(),
            },
          ],
        );
      },
    );
  }
}

class _QuickStartButton extends StatelessWidget {
  const _QuickStartButton({
    required this.title,
    required this.onTap,
    required this.icon,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.colors.link,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: context.textStyle.button.copyWith(
                color: context.colors.link,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
