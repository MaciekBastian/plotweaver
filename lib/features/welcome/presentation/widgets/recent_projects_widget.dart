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
import '../bloc/welcome_bloc.dart';

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
        BlocBuilder<WelcomeBloc, WelcomeState>(
          builder: (context, state) {
            return Expanded(
              child: Skeletonizer(
                enableSwitchAnimation: true,
                switchAnimationConfig: const SwitchAnimationConfig(
                  duration: Durations.medium4,
                ),
                enabled: state.maybeWhen(
                  orElse: () => false,
                  loading: () => true,
                  initial: () => true,
                ),
                child: state.maybeMap(
                  orElse: () => ListView(
                    children: List.generate(
                      10,
                      (_) => _RecentProjectButton(
                        recentProjectEntity: RecentProjectEntity.placeholder(),
                      ),
                    ),
                  ),
                  empty: (_) => ListView(
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
                  success: (value) {
                    return ListView.builder(
                      itemCount: value.projects.length,
                      itemBuilder: (context, index) {
                        return _RecentProjectButton(
                          recentProjectEntity: value.projects[index],
                        );
                      },
                    );
                  },
                  failure: (value) {
                    return Column(
                      children: [
                        const SizedBox(height: 30),
                        SvgPicture.asset(
                          ImagesConstants.dreamer,
                          height: 80,
                        ),
                        const SizedBox(height: 20),
                        FatalErrorWidget(
                          error: value.error,
                          onRetry: () {
                            context
                                .read<WelcomeBloc>()
                                .add(const WelcomeEvent.loadRecent());
                          },
                        ),
                      ],
                    );
                  },
                ),
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
  });

  final RecentProjectEntity recentProjectEntity;

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {},
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
