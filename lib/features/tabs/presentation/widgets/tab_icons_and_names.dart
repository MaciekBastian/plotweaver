import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../characters/presentation/bloc/characters_editors_bloc.dart';
import '../../../project/domain/enums/file_bundle_type.dart';
import '../../domain/entities/tab_entity.dart';

Widget getTabIcon(BuildContext context, TabEntity tab) {
  return switch (tab) {
    ProjectTab() => Icon(
        Icons.settings,
        size: 18,
        color: context.colors.onScaffoldBackgroundHeader,
      ),
    CharacterTab() => Icon(
        Icons.person_rounded,
        size: 18,
        color: context.colors.onScaffoldBackgroundHeader,
      ),
  };
}

Widget getFileBundleIcon(BuildContext context, FileBundleType type) {
  switch (type) {
    case FileBundleType.characters:
      return Icon(
        Icons.groups_3_outlined,
        size: 18,
        color: context.colors.onScaffoldBackgroundHeader,
      );
  }
}

String getTabName(BuildContext context, TabEntity tab, [bool watch = true]) {
  return switch (tab) {
    ProjectTab() => S.of(context).project,
    CharacterTab(:final characterId) => watch
        ? context
                .watch<CharactersEditorsBloc>()
                .getCharacter(characterId)
                ?.name ??
            S.of(context).character
        : context
                .read<CharactersEditorsBloc>()
                .getCharacter(characterId)
                ?.name ??
            S.of(context).character,
  };
}

String getFileBundleName(BuildContext context, FileBundleType type) {
  switch (type) {
    case FileBundleType.characters:
      return S.current.characters;
  }
}
