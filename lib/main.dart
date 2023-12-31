import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/constants/colors.dart';
import 'core/get_it/get_it.dart';
import 'core/window/window_config.dart';
import 'infrastructure/characters/cubit/characters_cubit.dart';
import 'infrastructure/fragments/cubit/fragments_cubit.dart';
import 'infrastructure/global/cubit/view_cubit.dart';
import 'infrastructure/plots/cubit/plots_cubit.dart';
import 'infrastructure/project/cubit/project_cubit.dart';

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
          BlocProvider(create: (context) => getIt<ProjectCubit>()..init()),
          BlocProvider(create: (context) => getIt<ViewCubit>()),
          BlocProvider(create: (context) => getIt<CharactersCubit>()),
          BlocProvider(create: (context) => getIt<PlotsCubit>()),
          BlocProvider(create: (context) => getIt<FragmentsCubit>()),
        ],
        child: const Plotweaver(),
      ),
    ),
  );
}
