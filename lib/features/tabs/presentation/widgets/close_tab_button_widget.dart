import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/sl_config.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/overlays/full_screen_alert.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../../commands/data/repositories/commands_repository.dart';
import '../../../commands/domain/enums/command_status.dart';
import '../../domain/commands/tab_intent.dart';
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
                  callback: () async {
                    Navigator.of(context).pop();
                    final resultId = Actions.invoke(
                      context,
                      TabIntent.saveTab(widget.tab),
                    );
                    if (resultId is String) {
                      final result = await sl<CommandsRepository>()
                          .waitForResult(resultId);
                      if (result.status == CommandStatus.error) {
                        showFullscreenError(result.error);
                      } else if (result.status == CommandStatus.success) {
                        _closeTab();
                      }
                    }
                  },
                  title: S.of(context).save,
                  isDefault: true,
                ),
                AlertOption(
                  callback: () async {
                    Navigator.of(context).pop();
                    final resultId = Actions.invoke(
                      context,
                      TabIntent.rollback(widget.tab),
                    );
                    if (resultId is String) {
                      final result = await sl<CommandsRepository>()
                          .waitForResult(resultId);
                      if (result.status == CommandStatus.error) {
                        showFullscreenError(result.error);
                      } else if (result.status == CommandStatus.success) {
                        _closeTab();
                      }
                    }
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
    context.read<TabsCubit>().closeTab(widget.tab);
  }
}
