import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/text_styles.dart';
import '../../../domain/characters/models/character_snippet.dart';
import '../../../infrastructure/global/cubit/view_cubit.dart';
import '../../../infrastructure/global/models/tab_model.dart';
import '../../../infrastructure/global/models/tab_type.dart';

class CharacterLinkWidget extends StatelessWidget {
  const CharacterLinkWidget({
    required this.character,
    super.key,
  });

  final CharacterSnippet character;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          BlocProvider.of<ViewCubit>(context).openTab(
            TabModel(
              id: 'character_${character.id}',
              title: character.name,
              type: TabType.character,
              associatedContentId: character.id,
            ),
          );
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        mouseCursor: SystemMouseCursors.click,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 3,
          ),
          child: Text(
            character.name,
            style: PlotweaverTextStyles.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}
