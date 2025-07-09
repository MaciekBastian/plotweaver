import '../../features/commands/domain/dispatchers/plotweaver_commands.dart';
import '../../features/commands/domain/entities/general_command.dart';

class PlotweaverGeneralCommands extends PlotweaverCommands {
  @override
  List<GeneralCommand> get commands => [
        GeneralCommand.showCommandSearchBar(),
      ];
}
