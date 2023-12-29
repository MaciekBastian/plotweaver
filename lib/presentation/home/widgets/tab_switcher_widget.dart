import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show InkWell, Colors, Material, ReorderableListView;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../core/constants/colors.dart';
import '../../../core/get_it/get_it.dart';
import '../../../core/styles/text_styles.dart';
import '../../../domain/global/models/command.dart';
import '../../../domain/global/services/command_dispatcher.dart';
import '../../../infrastructure/global/cubit/view_cubit.dart';
import '../../../infrastructure/global/models/tab_model.dart';
import '../../../infrastructure/global/models/tab_type.dart';

class TabSwitcherWidget extends StatelessWidget {
  const TabSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewCubit, ViewState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 30,
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                        BlocProvider.of<ViewCubit>(context).changeTabOrder(
                          oldIndex,
                          newIndex > oldIndex ? newIndex - 1 : newIndex,
                        );
                      },
                      buildDefaultDragHandles: false,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: false,
                      padding: EdgeInsets.zero,
                      children: List.generate(state.openedTabs.length, (index) {
                        final tab = state.openedTabs[index];
                        late final IconData icon;
                        switch (tab.type) {
                          case TabType.project:
                            icon = CupertinoIcons.doc;
                          case TabType.character:
                            icon = CupertinoIcons.person;
                          case TabType.plot:
                            icon = CupertinoIcons.helm;
                          case TabType.fragment:
                            icon = CupertinoIcons.collections;
                          case TabType.timeline:
                            icon = CupertinoIcons.time;
                        }

                        return _TabWidget(
                          key: Key('opened_tab_${tab.id}'),
                          icon: icon,
                          state: state,
                          tab: tab,
                          index: index,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 3),
              color: getIt<AppColors>().dividerColor,
            ),
          ],
        );
      },
    );
  }
}

class _TabWidget extends StatefulWidget {
  const _TabWidget({
    required this.tab,
    required this.icon,
    required this.state,
    required this.index,
    super.key,
  });

  final IconData icon;
  final ViewState state;
  final TabModel tab;
  final int index;

  @override
  State<_TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<_TabWidget> {
  bool _hovering = false;
  bool _closing = false;

  @override
  Widget build(BuildContext context) {
    final currentTab = BlocProvider.of<ViewCubit>(context).currentTab;
    final isCurrent = widget.tab.id == currentTab?.id;

    return ReorderableDelayedDragStartListener(
      index: widget.index,
      enabled: true,
      child: AnimatedContainer(
        color: isCurrent && !_closing
            ? CupertinoColors.activeBlue.withOpacity(0.2)
            : Colors.transparent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
        width: _closing ? 0 : 180,
        height: 30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: getIt<AppColors>().dividerColor.withOpacity(0.3),
                  onTap: () {
                    if (widget.tab.isPreview && isCurrent) {
                      BlocProvider.of<ViewCubit>(context).leavePreviewState(
                        widget.tab.id,
                      );
                    }
                    BlocProvider.of<ViewCubit>(context).openTab(widget.tab);
                  },
                  onHover: (value) {
                    setState(() {
                      _hovering = value;
                    });
                  },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.decelerate,
                    opacity: _closing ? 0 : 1,
                    child: _TabContent(
                      icon: widget.icon,
                      tab: widget.tab,
                      isCurrent: isCurrent,
                      isClosing: _closing,
                      key: Key('tab_${widget.tab.id}_content'),
                    ),
                  ),
                ),
              ),
            ),
            if (widget.state.openedTabs.length > 1 && !_closing)
              Positioned(
                top: 0,
                left: 5,
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _hovering = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      _hovering = false;
                    });
                  },
                  child: Opacity(
                    opacity: _hovering ? 1 : 0,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: 28,
                      width: 28,
                      child: MacosIconButton(
                        hoverColor:
                            getIt<AppColors>().dividerColor.withOpacity(0.8),
                        mouseCursor: SystemMouseCursors.click,
                        icon: widget.tab.isPinned
                            ? const MacosIcon(CupertinoIcons.pin_slash)
                            : const MacosIcon(CupertinoIcons.clear),
                        onPressed: () {
                          getIt<CommandDispatcher>().sendIntent(
                            PlotweaverCommand.save,
                          );
                          if (widget.tab.isPinned) {
                            if (isCurrent) {
                              BlocProvider.of<ViewCubit>(context)
                                  .toggleCurrentTabPinState();
                            } else {
                              BlocProvider.of<ViewCubit>(context)
                                  .openTab(widget.tab);
                            }
                            return;
                          }
                          BlocProvider.of<ViewCubit>(context)
                              .switchToNewTabBeforeClosing(
                            widget.tab.id,
                          );
                          Future.delayed(
                            const Duration(milliseconds: 60),
                            () {
                              setState(() {
                                _closing = true;
                              });
                            },
                          );
                          Future.delayed(
                            const Duration(milliseconds: 280),
                            () {
                              BlocProvider.of<ViewCubit>(context).closeTab(
                                widget.tab.id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.icon,
    required this.tab,
    required this.isCurrent,
    required this.isClosing,
    super.key,
  });

  final IconData icon;
  final TabModel tab;
  final bool isCurrent;
  final bool isClosing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          width: isClosing ? 0 : 30,
        ),
        AnimatedScale(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          scale: isClosing ? 0 : 1,
          child: SizedBox(
            height: double.infinity,
            width: 22,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                MacosIcon(
                  icon,
                  size: 17,
                ),
                if (tab.isPinned)
                  const Positioned(
                    bottom: 4,
                    right: 0,
                    child: MacosIcon(CupertinoIcons.pin_fill, size: 10),
                  ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          width: isClosing ? 0 : 5,
        ),
        Expanded(
          child: Text(
            tab.title,
            style: PlotweaverTextStyles.body.copyWith(
              fontStyle: tab.isPreview ? FontStyle.italic : FontStyle.normal,
              color: isCurrent ? CupertinoColors.activeBlue : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          width: isClosing ? 0 : 10,
        ),
        if (!isClosing)
          Container(
            width: 1,
            height: 15,
            color: getIt<AppColors>().dividerColor,
          ),
      ],
    );
  }
}
