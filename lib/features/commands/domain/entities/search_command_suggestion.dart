import 'command_entity.dart';

class SearchCommandSuggestion {
  const SearchCommandSuggestion({
    required this.command,
    required this.commandClass,
    required this.commandDisplayName,
  });

  final String commandClass;
  final String commandDisplayName;
  final CommandEntity command;
}
