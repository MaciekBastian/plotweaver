import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/sl_config.dart';
import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../shared/overlays/full_screen_alert.dart';
import '../../../../commands/data/repositories/commands_repository.dart';
import '../../../../commands/domain/entities/command_result.dart';
import '../../../../commands/domain/enums/command_status.dart';
import '../../../presentation/cubit/tabs_cubit.dart';
import '../../../presentation/widgets/tab_icons_and_names.dart';
import '../../entities/tab_entity.dart';
import '../tab_intent.dart';

class CloseTabAction extends ContextAction<CloseTabIntent> {
  CloseTabAction(this.tabEntity);

  final TabEntity? tabEntity;

  @override
  String invoke(
    CloseTabIntent intent, [
    BuildContext? context,
  ]) {
    final resultId =
        '${intent.runtimeType}_${DateTime.timestamp().millisecondsSinceEpoch}';

    if (tabEntity == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        sl<CommandsRepository>().emitResult(
          resultId,
          CommandResult(status: CommandStatus.notInvoked),
        );
      });
      return resultId;
    }
    if (context == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        sl<CommandsRepository>().emitResult(
          resultId,
          CommandResult(
            status: CommandStatus.error,
            error: const UnknownError(),
          ),
        );
      });
      return resultId;
    }

    final cubit = context.read<TabsCubit>();

    if (cubit.state.unsavedTabsIds.contains(tabEntity!.tabId)) {
      final tabName = getTabName(context, tabEntity!, false);

      showFullscreenAlert(
        title: S.of(context).do_you_want_to_save_changes_in_file(tabName),
        description: S.of(context).your_changes_will_be_lost_if_you_do_not_save,
        context: context,
        showCancelButton: true,
        options: [
          AlertOption(
            callback: () async {
              Navigator.of(context).pop();
              final nestedResultId = Actions.invoke(
                context,
                TabIntent.save(tabEntity),
              );
              if (nestedResultId is String) {
                final result = await sl<CommandsRepository>()
                    .waitForResult(nestedResultId);
                if (result.status == CommandStatus.error) {
                  showFullscreenError(result.error);
                  sl<CommandsRepository>().emitResult(
                    resultId,
                    CommandResult(
                      status: CommandStatus.error,
                      error: result.error,
                    ),
                  );
                } else if (result.status == CommandStatus.success) {
                  _close(tabEntity!, resultId);
                }
              }
            },
            title: S.of(context).save,
            isDefault: true,
          ),
          AlertOption(
            callback: () async {
              Navigator.of(context).pop();
              final nestedResultId = Actions.invoke(
                context,
                TabIntent.rollback(tabEntity),
              );
              if (nestedResultId is String) {
                final result = await sl<CommandsRepository>()
                    .waitForResult(nestedResultId);
                if (result.status == CommandStatus.error) {
                  showFullscreenError(result.error);
                  sl<CommandsRepository>().emitResult(
                    resultId,
                    CommandResult(
                      status: CommandStatus.error,
                      error: result.error,
                    ),
                  );
                } else if (result.status == CommandStatus.success) {
                  _close(tabEntity!, resultId);
                }
              }
            },
            title: S.of(context).do_not_save,
            isDestructive: true,
          ),
        ],
      );

      return resultId;
    }

    _close(tabEntity!, resultId);
    return resultId;
  }

  void _close(TabEntity tab, String resultId) {
    sl<TabsCubit>().closeTab(tab);
    Future.delayed(const Duration(milliseconds: 100), () {
      sl<CommandsRepository>().emitResult(
        resultId,
        CommandResult(status: CommandStatus.success),
      );
    });
  }
}
