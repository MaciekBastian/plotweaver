import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/editor/presentation/screens/editor_screen.dart';
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
        child: const EditorScreen(),
      ),
    ),
    ...plotweaverOtherRoutes,
  ],
);
