import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generated/locale_keys.g.dart';
import '../../infrastructure/project/cubit/project_cubit.dart';

@RoutePage(name: 'HomeRoute')
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ListView(
        children: [
          CupertinoButton(
            onPressed: () {
              BlocProvider.of<ProjectCubit>(context).openSystemFilePicker();
            },
            child: Text(
              LocaleKeys.home_open_from_finder.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
