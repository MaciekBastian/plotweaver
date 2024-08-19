import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/overlays/full_screen_alert.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../../project/presentation/bloc/current_project/current_project_bloc.dart';
import '../../../project/presentation/bloc/project_info_editor/project_info_editor_bloc.dart';
import '../../domain/entities/tab_entity.dart';
import '../cubit/tabs_cubit.dart';

class CloseTabButton extends StatefulWidget {
  const CloseTabButton({
    required this.tab,
    required this.isUnsaved,
    required this.tabName,
    super.key,
  });

  final TabEntity tab;
  final String tabName;
  final bool isUnsaved;

  @override
  State<CloseTabButton> createState() => _CloseTabButtonState();
}

class _CloseTabButtonState extends State<CloseTabButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!_hovering) {
          setState(() {
            _hovering = true;
          });
        }
      },
      onExit: (_) {
        if (_hovering) {
          setState(() {
            _hovering = false;
          });
        }
      },
      child: ClickableWidget(
        onTap: () {
          if (widget.isUnsaved) {
            showFullscreenAlert(
              title: S
                  .of(context)
                  .do_you_want_to_save_changes_in_file(widget.tabName),
              description:
                  S.of(context).your_changes_will_be_lost_if_you_do_not_save,
              context: context,
              showCancelButton: true,
              options: [
                AlertOption(
                  callback: () {
                    Navigator.of(context).pop();
                    context.read<CurrentProjectBloc>().add(
                          CurrentProjectEvent.save(
                            tabs: [widget.tab.tabId],
                            then: (wasSaveSuccessful, error) {
                              if (wasSaveSuccessful) {
                                _closeTab();
                              } else {
                                showFullscreenError(error);
                              }
                            },
                          ),
                        );
                  },
                  title: S.of(context).save,
                  isDefault: true,
                ),
                AlertOption(
                  callback: () {
                    Navigator.of(context).pop();
                    context.read<CurrentProjectBloc>().add(
                          CurrentProjectEvent.rollBack(
                            tabs: [widget.tab.tabId],
                            then: (wasSaveSuccessful, error) {
                              if (wasSaveSuccessful) {
                                _closeTab();
                              } else {
                                showFullscreenError(error);
                              }
                            },
                          ),
                        );
                  },
                  title: S.of(context).do_not_save,
                  isDestructive: true,
                ),
              ],
            );
          } else {
            _closeTab();
          }
        },
        child: SizedBox(
          width: 25,
          height: 25,
          child: Icon(
            _hovering
                ? Icons.close
                : widget.isUnsaved
                    ? Icons.circle
                    : Icons.close,
            color: context.colors.disabled,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _closeTab() {
    widget.tab.map(
      projectTab: (value) {
        context
            .read<ProjectInfoEditorBloc>()
            .add(const ProjectInfoEditorEvent.setup(null, true));
      },
      characterTab: (value) {},
    );
    context.read<TabsCubit>().closeTab(widget.tab);
  }
}
