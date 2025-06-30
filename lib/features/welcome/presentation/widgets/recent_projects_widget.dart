import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/images_constants.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../../../shared/widgets/fatal_error_widget.dart';
import '../../domain/entities/recent_project_entity.dart';
import '../bloc/quick_start/quick_start_bloc.dart';
import '../bloc/recent_projects/recent_projects_bloc.dart';

class RecentProjectsWidget extends StatelessWidget {
  const RecentProjectsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.history,
              size: 18,
              color: context.colors.onScaffoldBackgroundColor,
            ),
            const SizedBox(width: 5),
            Text(
              S.of(context).recent,
              style: context.textStyle.h6,
            ),
          ],
        ),
        Divider(color: context.colors.dividerColor),
        BlocBuilder<RecentProjectsBloc, RecentProjectsState>(
          builder: (context, state) {
            return Expanded(
              child: Skeletonizer(
                enableSwitchAnimation: false,
                key: const Key('recent_projects_list_skeleton'),
                switchAnimationConfig: const SwitchAnimationConfig(
                  duration: Durations.medium4,
                ),
                enabled: switch (state) {
                  RecentProjectsStateInitial() => true,
                  RecentProjectsStateLoading() => true,
                  _ => false,
                },
                child: switch (state) {
                  RecentProjectsStateFailure(:final error) => Column(
                      children: [
                        const SizedBox(height: 30),
                        SvgPicture.asset(
                          ImagesConstants.dreamer,
                          height: 80,
                        ),
                        const SizedBox(height: 20),
                        FatalErrorWidget(
                          error: error,
                          onRetry: () {
                            context
                                .read<RecentProjectsBloc>()
                                .add(const RecentProjectsEvent.loadRecent());
                          },
                        ),
                      ],
                    ),
                  RecentProjectsStateSuccess(:final projects) =>
                    ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return _RecentProjectButton(
                          recentProjectEntity: projects[index],
                        );
                      },
                    ),
                  RecentProjectsStateEmpty() => ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 30),
                        SvgPicture.asset(
                          ImagesConstants.lighthouse,
                          height: 80,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          S.of(context).there_is_no_recent_projects,
                          style: context.textStyle.h3,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          S.of(context).open_project_or_create_new,
                          style: context.textStyle.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  _ => ListView(
                      children: List.generate(
                        10,
                        (i) => _RecentProjectButton(
                          key: Key('recent_project_$i'),
                          recentProjectEntity:
                              RecentProjectEntity.placeholder(),
                        ),
                      ),
                    ),
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RecentProjectButton extends StatelessWidget {
  const _RecentProjectButton({
    required this.recentProjectEntity,
    super.key,
  });

  final RecentProjectEntity recentProjectEntity;

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        context
            .read<QuickStartBloc>()
            .add(QuickStartEvent.openProject(recentProjectEntity));
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: recentProjectEntity.projectName),
              const WidgetSpan(child: SizedBox(width: 5)),
              TextSpan(
                text: '(${recentProjectEntity.path})',
                style: context.textStyle.caption.copyWith(
                  color: context.colors.link,
                ),
              ),
            ],
            style: context.textStyle.button.copyWith(
              color: context.colors.link,
            ),
          ),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
