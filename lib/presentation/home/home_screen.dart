import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/constants/colors.dart';
import '../../core/get_it/get_it.dart';
import '../../core/router/router.gr.dart';
import '../../core/styles/text_styles.dart';
import '../../generated/locale_keys.g.dart';
import '../../infrastructure/project/cubit/project_cubit.dart';
import 'widgets/app_logo_widet.dart';

@RoutePage(name: 'HomeRoute')
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectState>(
      bloc: BlocProvider.of<ProjectCubit>(context),
      listener: (context, state) {
        if (state.openedProject != null) {
          AutoRouter.of(context).replaceAll([
            const DefaultViewRoute(),
          ]);
        }
      },
      builder: (context, state) {
        return MacosScaffold(
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return Container(
                  color: getIt<AppColors>().background,
                  child: _buildBody(state, context),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(ProjectState state, BuildContext context) {
    final mq = MediaQuery.of(context);
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const AppLogoWidget(
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 10),
              Text(
                LocaleKeys.home_plotweaver.tr(),
                style: PlotweaverTextStyles.headline1,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 5),
              Text(
                LocaleKeys.home_weave_your_world.tr(),
                style: PlotweaverTextStyles.headline6.copyWith(
                  color: getIt<AppColors>().textGrey,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 50),
              Text(
                LocaleKeys.home_get_started.tr(),
                style: PlotweaverTextStyles.headline4,
                textAlign: TextAlign.start,
              ),
              Container(
                width: mq.size.width * 0.3,
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                height: 1,
                color: getIt<AppColors>().dividerColor,
              ),
              Text(
                '${LocaleKeys.home_recent.tr()}:',
                style: PlotweaverTextStyles.subtitle,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              if (state.recent.isEmpty)
                Text(
                  LocaleKeys.home_none.tr(),
                  style: PlotweaverTextStyles.body,
                  textAlign: TextAlign.start,
                )
              else
                ...state.recent
                    .getRange(
                      0,
                      state.recent.length > 5 ? 5 : state.recent.length,
                    )
                    .toList()
                    .map((project) {
                  return GestureDetector(
                    child: Text(
                      project.name,
                      style: PlotweaverTextStyles.body.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    onTap: () {
                      BlocProvider.of<ProjectCubit>(context)
                          .openProject(project);
                    },
                  );
                }).toList(),
              const SizedBox(height: 20),
              Row(
                children: [
                  PushButton(
                    controlSize: ControlSize.large,
                    child: Text(
                      LocaleKeys.home_create_new_project.tr(),
                    ),
                    onPressed: () {
                      AutoRouter.of(context).push(const ProjectSetupRoute());
                    },
                  ),
                  const SizedBox(width: 20),
                  PushButton(
                    controlSize: ControlSize.large,
                    secondary: true,
                    child: Text(
                      LocaleKeys.home_open_from_finder.tr(),
                    ),
                    onPressed: () {
                      BlocProvider.of<ProjectCubit>(context)
                          .openSystemFilePicker();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
