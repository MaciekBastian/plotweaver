import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/project_info_editor/project_info_editor_bloc.dart';

class ProjectEditorTab extends StatelessWidget {
  const ProjectEditorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectInfoEditorBloc, ProjectInfoEditorState>(
      builder: (context, state) {
        return Text(state.runtimeType.toString());
      },
    );
  }
}
