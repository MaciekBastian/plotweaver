import 'package:flutter/material.dart';

import '../entities/command_entity.dart';

class PlotweaverCommands {
  List<CommandEntity> get commands => [];

  Map<ShortcutActivator, Intent> get intents =>
      commands.where((el) => el.shortcut != null).toList().asMap().map(
            (key, value) => MapEntry(value.shortcut!, value.intent),
          );

  Map<Type, Action> get defaultActions => commands.asMap().map(
        (key, value) => MapEntry(value.intent.runtimeType, value.action),
      );
}
