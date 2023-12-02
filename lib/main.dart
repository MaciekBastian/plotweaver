import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/constants/colors.dart';
import 'core/get_it/get_it.dart';
import 'core/window/window_config.dart';
import 'infrastructure/project/project_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await configureWindow();
  configureDependencies();
  getIt<AppColors>().init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('pl')],
      fallbackLocale: const Locale('pl'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<ProjectCubit>()),
        ],
        child: const Plotweaver(),
      ),
    ),
  );
}
