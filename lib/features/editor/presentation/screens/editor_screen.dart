import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../bloc/project_sidebar_bloc.dart';
import '../widgets/project_sidebar_widget.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({
    required this.shell,
    super.key,
  });

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectSidebarBloc(),
      child: AppScaffold(
        body: Row(
          children: [
            const ProjectSidebarWidget(),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
