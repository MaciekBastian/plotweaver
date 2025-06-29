import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/sl_config.dart';
import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../../commands/data/repositories/commands_repository.dart';
import '../../../../commands/domain/entities/command_result.dart';
import '../../../../commands/domain/enums/command_status.dart';
import '../../../presentation/cubit/tabs_cubit.dart';
import '../../entities/tab_entity.dart';
import '../tab_intent.dart';

class OpenTabAction extends ContextAction<OpenTabIntent> {
  OpenTabAction(this.tabEntity);

  final TabEntity? tabEntity;

  @override
  String invoke(
    OpenTabIntent intent, [
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

    context.read<TabsCubit>().openTab(tabEntity!);
    Future.delayed(const Duration(milliseconds: 100), () {
      sl<CommandsRepository>().emitResult(
        resultId,
        CommandResult(status: CommandStatus.success),
      );
    });

    return resultId;
  }
}
