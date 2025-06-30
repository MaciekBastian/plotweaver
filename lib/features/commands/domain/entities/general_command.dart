import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/commands/actions/show_command_search_bar_action.dart';
import '../../../../shared/commands/general_intents.dart';
import '../enums/plotweaver_command.dart';
import 'command_entity.dart';

part 'general_command.freezed.dart';

@Freezed(toJson: false, fromJson: false)
sealed class GeneralCommand with _$GeneralCommand implements CommandEntity {
  factory GeneralCommand({
    required PlotweaverCommand command,
    required Intent intent,
    required Action action,
    @Default(true) bool discoverable,
    ShortcutActivator? shortcut,
    @Default([]) List<String> commandNamesTranslateKeys,
  }) = _GeneralCommand;

  factory GeneralCommand.showCommandSearchBar() => _GeneralCommand(
        command: PlotweaverCommand.showCommandSearchBar,
        action: ShowCommandSearchBarAction(),
        intent: const ShowCommandSearchBarIntent(),
        discoverable: false,
        shortcut: SingleActivator(
          LogicalKeyboardKey.keyP,
          control: Platform.isWindows,
          meta: Platform.isMacOS,
          shift: true,
        ),
      );
}
