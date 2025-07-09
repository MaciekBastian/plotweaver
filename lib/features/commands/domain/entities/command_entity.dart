import 'package:flutter/material.dart';

import '../enums/plotweaver_command.dart';

abstract class CommandEntity {
  CommandEntity({
    required this.command,
    required this.action,
    required this.intent,
    this.discoverable = true,
    this.shortcut,
    this.commandNamesTranslateKeys = const [],
  });

  final PlotweaverCommand command;
  final ShortcutActivator? shortcut;
  final bool discoverable;
  final Action action;
  final Intent intent;
  final List<String> commandNamesTranslateKeys;
}
