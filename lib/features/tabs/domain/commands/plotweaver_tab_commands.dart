import '../../../commands/domain/dispatchers/plotweaver_commands.dart';
import '../../../commands/domain/entities/tab_command.dart';

class PlotweaverTabCommands extends PlotweaverCommands {
  @override
  List<TabCommand> get commands => [
        TabCommand.save(),
        TabCommand.rollback(),
        TabCommand.close(),
        TabCommand.open(),
      ];
}
