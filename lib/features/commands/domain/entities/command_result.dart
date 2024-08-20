import '../../../../core/errors/plotweaver_errors.dart';
import '../enums/command_status.dart';

class CommandResult {
  CommandResult({
    required this.status,
    this.error,
    this.value,
  });

  final CommandStatus status;
  final Object? value;
  final PlotweaverError? error;
}
