import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          initial: true,
          path: '/',
        ),
        AutoRoute(
          page: ProjectSetupRoute.page,
          path: '/project-setup',
        ),
        AutoRoute(
          page: DefaultViewRoute.page,
          path: '/main',
        ),
      ];
}
