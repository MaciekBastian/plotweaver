import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/characters/presentation/bloc/characters_editors_bloc.dart';
import '../../features/editor/presentation/screens/editor_screen.dart';
import '../../features/project/presentation/bloc/project_info_editor/project_info_editor_bloc.dart';
import '../config/sl_config.dart';
import '../constants/routes_constants.dart';
import 'page_transition.dart';
import 'routes/other_routes.dart';

final rootNavKey = GlobalKey<NavigatorState>(
  debugLabel: 'root navigation global key',
);

final plotweaverRouter = GoRouter(
  navigatorKey: rootNavKey,
  initialLocation: PlotweaverRoutes.welcome,
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      path: PlotweaverRoutes.editor,
      pageBuilder: (context, state) => buildPageWithFadeTransition(
        context: context,
        state: state,
        // bloc providers for all editors
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProjectInfoEditorBloc(
                sl(),
                sl(),
                context.read(),
              ),
            ),
            BlocProvider(
              create: (context) => CharactersEditorsBloc(
                sl(),
                sl(),
                sl(),
                sl(),
                context.read(),
              ),
            ),
          ],
          child: const EditorScreen(),
        ),
      ),
    ),
    ...plotweaverOtherRoutes,
  ],
);
