import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../../project/domain/enums/file_bundle_type.dart';

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
          onTap: () {},
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
