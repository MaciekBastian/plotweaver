import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../shared/overlays/full_screen_alert.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../../characters/presentation/bloc/characters_editors_bloc.dart';
import '../../../project/domain/enums/file_bundle_type.dart';
import '../../../project/presentation/bloc/current_project/current_project_bloc.dart';
import '../../../project/presentation/cubit/project_files_cubit.dart';
import '../../../tabs/presentation/cubit/tabs_cubit.dart';

class ProjectFileBundleActions extends StatelessWidget {
  const ProjectFileBundleActions({
    required this.type,
    super.key,
  });

  final FileBundleType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case FileBundleType.characters:
        return ClickableWidget(
          onTap: () {
            context.read<CharactersEditorsBloc>().add(
              CharactersEditorsEvent.create(
                then: (character, error) {
                  if (error != null) {
                    showFullscreenError(error);
                  } else {
                    context.read<ProjectFilesCubit>().checkAndLoadAllFiles();
                    final openedTab =
                        context.read<TabsCubit>().state.openedTabId;
                    if (openedTab != null) {
                      context
                          .read<CurrentProjectBloc>()
                          .add(CurrentProjectEvent.save(tabs: [openedTab]));
                    }
                  }
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Icon(
              Icons.add,
              color: context.colors.onScaffoldBackgroundHeader,
              size: 18,
            ),
          ),
        );
    }
  }
}
