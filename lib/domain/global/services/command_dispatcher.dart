import '../models/command.dart';

abstract class CommandDispatcher {
  Future<void> sendIntent(PlotweaverCommand command);

  bool isCommandAvailable(PlotweaverCommand command);
}
