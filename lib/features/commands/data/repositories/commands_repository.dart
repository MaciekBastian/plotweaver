import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../domain/entities/command_result.dart';

abstract class CommandsRepository {
  void close();

  Stream<(String, CommandResult)> get resultEmitter;

  Future<CommandResult> waitForResult(String id);

  void emitResult(String id, CommandResult result);
}

@Singleton(as: CommandsRepository)
class CommandsRepositoryImpl implements CommandsRepository {
  final StreamController<(String, CommandResult)> _resultEmitter =
      StreamController.broadcast();

  @override
  Stream<(String, CommandResult)> get resultEmitter => _resultEmitter.stream;

  @override
  void emitResult(String id, CommandResult result) {
    _resultEmitter.add((id, result));
  }

  @override
  Future<CommandResult> waitForResult(String id) {
    return _resultEmitter.stream
        .where((el) => el.$1 == id)
        .map((el) => el.$2)
        .first;
  }

  @override
  void close() {
    _resultEmitter.close();
  }
}
