import 'package:go_router/go_router.dart';

import '../../../features/welcome/presentation/welcome_screen.dart';
import '../../constants/routes_constants.dart';

final List<RouteBase> plotweaverOtherRoutes = [
  GoRoute(
    path: PlotweaverRoutes.welcome,
    builder: (context, state) => const WelcomeScreen(),
  ),
];
