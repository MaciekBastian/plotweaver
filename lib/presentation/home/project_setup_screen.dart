import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/colors.dart';
import '../../core/get_it/get_it.dart';
import '../../core/router/router.gr.dart';
import '../../core/styles/text_styles.dart';
import '../../generated/locale_keys.g.dart';
import '../../infrastructure/project/cubit/project_cubit.dart';
import 'widgets/app_logo_widget.dart';

@RoutePage(name: 'ProjectSetupRoute')
class ProjectSetupScreen extends StatefulWidget {
  const ProjectSetupScreen({super.key});

  @override
  State<ProjectSetupScreen> createState() => _ProjectSetupScreenState();
}

class _ProjectSetupScreenState extends State<ProjectSetupScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      BlocProvider.of<ProjectCubit>(context).createProjectFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return CupertinoPageScaffold(
      child: SizedBox(
        width: mq.size.width,
        height: mq.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppLogoWidget(),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.home_create_new_project.tr(),
              style: PlotweaverTextStyles.headline1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.home_save_file_in_finder.tr(),
              style: PlotweaverTextStyles.subtitle.copyWith(
                color: getIt<AppColors>().textGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  child: Text(LocaleKeys.home_cancel.tr()),
                  onPressed: () {
                    AutoRouter.of(context).maybePop();
                  },
                ),
                const SizedBox(width: 20),
                CupertinoButton.filled(
                  child: Text(LocaleKeys.home_continue.tr()),
                  onPressed: () {
                    AutoRouter.of(context).replaceAll([
                      const DefaultViewRoute(),
                    ]);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
