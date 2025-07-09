import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/sl_config.dart';
import '../../../../../core/errors/plotweaver_errors.dart';
import '../../../../characters/presentation/bloc/characters_editors_bloc.dart';
import '../../../../commands/data/repositories/commands_repository.dart';
import '../../../../commands/domain/entities/command_result.dart';
import '../../../../commands/domain/enums/command_status.dart';
import '../../entities/tab_entity.dart';
import '../tab_intent.dart';

class UndoTabAction extends ContextAction<UndoTabIntent> {
  UndoTabAction(this.tabEntity);

  final TabEntity? tabEntity;

  @override
  String invoke(
    UndoTabIntent intent, [
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

    print('UNDO');

    switch (tabEntity) {
      case null:
        break;
      case ProjectTab():
        // TODO: Handle this case.
        throw UnimplementedError();
      case CharacterTab():
        final characterId = (tabEntity! as CharacterTab).characterId;
        context.read<CharactersEditorsBloc>().add(
              CharactersEditorsEvent.undo(
                characterId: characterId,
                tabId: tabEntity!.tabId,
                then: (success) {},
              ),
            );
        break;
    }

    // context.read<CurrentProjectBloc>().add(
    //       CurrentProjectEvent.save(
    //         tabs: [tabEntity!.tabId],
    //         then: (wasSaveSuccessful, error) {
    //           if (wasSaveSuccessful) {
    //             sl<CommandsRepository>().emitResult(
    //               resultId,
    //               CommandResult(status: CommandStatus.success),
    //             );
    //           } else {
    //             sl<CommandsRepository>().emitResult(
    //               resultId,
    //               CommandResult(status: CommandStatus.error, error: error),
    //             );
    //           }
    //         },
    //       ),
    //     );

    return resultId;
  }
}
