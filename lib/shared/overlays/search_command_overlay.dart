import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/commands/presentation/bloc/search_commands_bloc.dart';
import '../../features/commands/presentation/search_command_overlay_widget.dart';

void showCommandOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return BlocProvider(
        create: (context) => SearchCommandsBloc(),
        child: const Material(
          color: Colors.transparent,
          child: SearchCommandOverlay(),
        ),
      );
    },
  );
}
