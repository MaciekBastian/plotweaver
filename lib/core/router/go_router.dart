import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/routes_constants.dart';
import 'routes/other_routes.dart';

final rootNavKey = GlobalKey<NavigatorState>();

final plotweaverRouter = GoRouter(
  navigatorKey: rootNavKey,
  initialLocation: PlotweaverRoutes.welcome,
  debugLogDiagnostics: kDebugMode,
  routes: [
    ...plotweaverOtherRoutes,
  ],
);
