import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/sl_config.dart';
import '../../../core/extensions/theme_extension.dart';
import '../../../generated/l10n.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/plotweaver_logo_widget.dart';
import 'bloc/quick_start/quick_start_bloc.dart';
import 'bloc/recent_projects/recent_projects_bloc.dart';
import 'widgets/quick_start_widget.dart';
import 'widgets/recent_projects_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RecentProjectsBloc(sl())
            ..add(const RecentProjectsEvent.loadRecent()),
        ),
        BlocProvider(create: (context) => QuickStartBloc(sl())),
      ],
      child: AppScaffold(
        body: Row(
          children: [
            // white space
            const Expanded(child: SizedBox.expand()),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PlotweaverLogoWidget(radius: 64),
                  const SizedBox(height: 10),
                  Text(
                    S.current.plotweaver,
                    style: context.textStyle.h1,
                  ),
                  const SizedBox(height: 5),
                  Divider(color: context.colors.dividerColor),
                  const SizedBox(height: 5),
                  const SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Row(
                      children: [
                        Expanded(child: RecentProjectsWidget()),
                        SizedBox(width: 10),
                        Expanded(child: QuickStartWidget()),
                        // white space
                        Expanded(flex: 2, child: SizedBox.expand()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
