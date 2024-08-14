import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/addons/bloc_observer.dart';
import 'core/config/sl_config.dart';
import 'core/config/window_config.dart';
import 'core/router/go_router.dart';
import 'core/services/package_and_device_info_service.dart';
import 'core/theme/plotweaver_theme.dart';
import 'features/project/presentation/bloc/current_project/current_project_bloc.dart';
import 'features/project/presentation/cubit/project_files_cubit.dart';
import 'features/tabs/presentation/cubit/tabs_cubit.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  configureDependencies();
  await configureWindow();
  await sl<PackageAndDeviceInfoService>().initialize();
  await sl<PlotweaverThemeSelector>().initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CurrentProjectBloc()),
        BlocProvider(create: (context) => ProjectFilesCubit()),
        BlocProvider(
          create: (context) => TabsCubit(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Plotweaver',
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: plotweaverRouter,
        supportedLocales: S.delegate.supportedLocales,
      ),
    ),
  );
}
