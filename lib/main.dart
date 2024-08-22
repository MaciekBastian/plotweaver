import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/addons/bloc_observer.dart';
import 'core/config/sl_config.dart';
import 'core/config/window_config.dart';
import 'core/router/go_router.dart';
import 'core/services/package_and_device_info_service.dart';
import 'core/theme/plotweaver_theme.dart';
import 'features/commands/data/repositories/commands_repository.dart';
import 'features/commands/domain/dispatchers/plotweaver_command_dispatcher.dart';
import 'features/project/presentation/bloc/current_project/current_project_bloc.dart';
import 'features/project/presentation/cubit/project_files_cubit.dart';
import 'features/tabs/domain/commands/plotweaver_tab_commands.dart';
import 'features/tabs/presentation/cubit/tabs_cubit.dart';
import 'generated/l10n.dart';
import 'shared/commands/plotweaver_general_commands.dart';

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
        BlocProvider(
          create: (context) => ProjectFilesCubit(
            sl(),
          ),
        ),
        BlocProvider.value(value: sl<TabsCubit>()),
      ],
      child: const _MyApp(),
    ),
  );
}

class _MyApp extends StatefulWidget {
  const _MyApp();

  @override
  State<_MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> {
  @override
  void dispose() {
    sl<CommandsRepository>().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        ...PlotweaverTabCommands().intents,
        ...PlotweaverGeneralCommands().intents,
      },
      child: Actions(
        dispatcher: PlotweaverCommandDispatcher(),
        actions: {
          ...PlotweaverGeneralCommands().defaultActions,
        },
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
}
