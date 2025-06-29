import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../tabs/domain/commands/actions/close_tab_action.dart';
import '../../../tabs/domain/commands/actions/open_tab_action.dart';
import '../../../tabs/domain/commands/actions/rollback_tab_action.dart';
import '../../../tabs/domain/commands/actions/save_tab_action.dart';
import '../../../tabs/domain/commands/tab_intent.dart';
import '../enums/plotweaver_command.dart';
import 'command_entity.dart';

part 'tab_command.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class TabCommand with _$TabCommand implements CommandEntity {
  factory TabCommand({
    required PlotweaverCommand command,
    required Intent intent,
    required Action action,
    @Default(true) bool discoverable,
    ShortcutActivator? shortcut,
  }) = _TabCommand;

  factory TabCommand.save() => _TabCommand(
        command: PlotweaverCommand.saveTab,
        intent: const TabIntent.save(),
        action: SaveTabAction(null),
        shortcut: SingleActivator(
          LogicalKeyboardKey.keyS,
          control: Platform.isWindows,
          meta: Platform.isMacOS,
        ),
      );

  factory TabCommand.rollback() => _TabCommand(
        command: PlotweaverCommand.rollbackTab,
        intent: const TabIntent.rollback(),
        action: RollbackTabAction(null),
        discoverable: false,
      );

  factory TabCommand.close() => _TabCommand(
        command: PlotweaverCommand.closeTab,
        intent: const TabIntent.close(),
        action: CloseTabAction(null),
        shortcut: SingleActivator(
          LogicalKeyboardKey.keyW,
          control: Platform.isWindows,
          meta: Platform.isMacOS,
        ),
      );

  factory TabCommand.open() => _TabCommand(
        command: PlotweaverCommand.openTab,
        intent: const TabIntent.open(),
        action: OpenTabAction(null),
      );
}
