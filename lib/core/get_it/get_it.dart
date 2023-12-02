import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../router/router.dart';

import 'get_it.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.init().registerSingleton<AppRouter>(AppRouter());
}
