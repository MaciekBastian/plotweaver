import 'package:go_router/go_router.dart';

import '../../../features/editor/presentation/screens/editor_screen.dart';
import '../../../features/project/presentation/screens/project_editor_screen.dart';
import '../../constants/routes_constants.dart';
import '../go_router.dart';
import '../page_transition.dart';

final shellRoute = StatefulShellRoute.indexedStack(
  parentNavigatorKey: rootNavKey,
  pageBuilder: (context, state, shell) => buildPageWithFadeTransition(
    context: context,
    state: state,
    child: EditorScreen(shell: shell),
  ),
  branches: [
    editorBranch,
  ],
);

final editorBranch = StatefulShellBranch(
  initialLocation: PlotweaverRoutes.editor,
  routes: [
    GoRoute(
      path: PlotweaverRoutes.editor,
      pageBuilder: (context, state) => buildPageWithFadeTransition(
        context: context,
        state: state,
        child: const ProjectEditorScreen(),
      ),
    ),
  ],
);
