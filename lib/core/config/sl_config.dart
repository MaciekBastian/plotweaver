import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'sl_config.config.dart';

final sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  sl.init();
}
