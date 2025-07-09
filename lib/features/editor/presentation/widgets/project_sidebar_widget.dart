import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../shared/widgets/plotweaver_logo_widget.dart';
import '../bloc/project_sidebar_bloc.dart';
import 'project_sidebar_content.dart';

class ProjectSidebarWidget extends StatefulWidget {
  const ProjectSidebarWidget({super.key});

  @override
  State<ProjectSidebarWidget> createState() => _ProjectSidebarWidgetState();
}

class _ProjectSidebarWidgetState extends State<ProjectSidebarWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectSidebarBloc, ProjectSidebarState>(
      builder: (context, state) {
        switch (state) {
          case ProjectSidebarStateHidden():
            return const SizedBox.shrink();
          case ProjectSidebarStateVisible(:final width):
            return SizedBox(
              width: width,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    width: width,
                    padding: const EdgeInsets.only(left: 20),
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: context.colors.shadedBackgroundColor,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: PlotweaverLogoWidget(
                            radius: 32,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Divider(color: context.colors.dividerColor),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: ProjectSidebarContent(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    child: _DragHandle(),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}

class _DragHandle extends StatefulWidget {
  const _DragHandle();

  @override
  State<_DragHandle> createState() => __DragHandleState();
}

class __DragHandleState extends State<_DragHandle> {
  final minWidth = 200.0;
  final maxWidth = 450.0;
  bool _isHovering = false;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProjectSidebarBloc, ProjectSidebarState, double>(
      selector: (state) {
        return switch (state) {
          ProjectSidebarStateVisible(:final width) => width,
          ProjectSidebarStateHidden(:final cachedWidth) => cachedWidth,
        };
      },
      builder: (context, state) {
        return MouseRegion(
          onEnter: (_) {
            if (!_isHovering) {
              setState(() {
                _isHovering = true;
              });
            }
          },
          onHover: (event) {
            if (!_isHovering) {
              setState(() {
                _isHovering = true;
              });
            }
          },
          onExit: (event) {
            if (_isHovering) {
              setState(() {
                _isHovering = false;
              });
            }
          },
          cursor: state == minWidth
              ? SystemMouseCursors.resizeRight
              : state == maxWidth
                  ? SystemMouseCursors.resizeLeft
                  : SystemMouseCursors.resizeLeftRight,
          child: GestureDetector(
            onDoubleTap: () {
              context
                  .read<ProjectSidebarBloc>()
                  .add(const ProjectSidebarEvent.changeWidth(350));
            },
            onHorizontalDragStart: (details) {
              if (!_isDragging) {
                setState(() {
                  _isDragging = true;
                });
              }
            },
            onHorizontalDragEnd: (details) {
              if (_isDragging) {
                setState(() {
                  _isDragging = false;
                });
              }
            },
            onHorizontalDragUpdate: (details) {
              double newWidth = (state + details.delta.dx).floorToDouble();
              if (newWidth > maxWidth) {
                newWidth = maxWidth;
              } else if (newWidth < minWidth) {
                newWidth = minWidth;
              }
              context
                  .read<ProjectSidebarBloc>()
                  .add(ProjectSidebarEvent.changeWidth(newWidth));
            },
            child: AnimatedContainer(
              duration: Durations.short4,
              width: (_isHovering || _isDragging) ? 5 : 2,
              height: double.infinity,
              color: _isHovering || _isDragging
                  ? context.colors.link
                  : context.colors.shadedBackgroundColor,
            ),
          ),
        );
      },
    );
  }
}
