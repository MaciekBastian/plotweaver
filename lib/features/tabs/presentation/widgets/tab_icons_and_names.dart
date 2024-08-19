import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../project/domain/enums/file_bundle_type.dart';
import '../../domain/entities/tab_entity.dart';

Widget getTabIcon(BuildContext context, TabEntity tab) {
  return tab.map(
    projectTab: (value) => Icon(
      Icons.settings,
      size: 18,
      color: context.colors.onScaffoldBackgroundHeader,
    ),
    characterTab: (value) => Icon(
      Icons.person_rounded,
      size: 18,
      color: context.colors.onScaffoldBackgroundHeader,
    ),
  );
}

Widget getFileBundleIcon(BuildContext context, FileBundleType type) {
  switch (type) {
    case FileBundleType.characters:
      return Icon(
        Icons.person_rounded,
        size: 18,
        color: context.colors.onScaffoldBackgroundHeader,
      );
  }
}

String getTabName(BuildContext context, TabEntity tab) {
  return tab.map(
    projectTab: (value) => S.of(context).project,
    characterTab: (value) => 'placeholder',
  );
}

String getFileBundleName(BuildContext context, FileBundleType type) {
  switch (type) {
    case FileBundleType.characters:
      return S.current.characters;
  }
}
