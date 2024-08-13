import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/routes_constants.dart';
import 'routes/editor_routes.dart';
import 'routes/other_routes.dart';

final rootNavKey = GlobalKey<NavigatorState>(
  debugLabel: 'root navigation global key',
);

final plotweaverRouter = GoRouter(
  navigatorKey: rootNavKey,
  initialLocation: PlotweaverRoutes.welcome,
  debugLogDiagnostics: kDebugMode,
  routes: [
    shellRoute,
    ...plotweaverOtherRoutes,
  ],
);
