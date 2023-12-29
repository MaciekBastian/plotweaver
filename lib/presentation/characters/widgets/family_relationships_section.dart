import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Material, InkWell, Colors;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../core/constants/colors.dart';
import '../../../core/get_it/get_it.dart';
import '../../../core/styles/text_styles.dart';
import '../../../domain/characters/models/character_snippet.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../infrastructure/characters/cubit/characters_cubit.dart';
import '../../../infrastructure/global/cubit/view_cubit.dart';
import '../../../infrastructure/global/models/tab_model.dart';
import '../../../infrastructure/global/models/tab_type.dart';
import 'character_link_widget.dart';
import 'family_relationships_editor.dart';

class FamilyRelationshipsSection extends StatelessWidget {
  const FamilyRelationshipsSection({
    required this.characterId,
    required this.characterChildren,
    required this.characterParents,
    required this.characterSpouses,
    required this.refreshFamily,
    super.key,
  });
  final String characterId;
  final List<String> characterParents;
  final List<String> characterChildren;
  final List<String> characterSpouses;
  final VoidCallback refreshFamily;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const MacosIcon(Icons.diversity_1_rounded),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_family_relationships.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          LocaleKeys.character_editor_family_relationships_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              LocaleKeys
                  .character_editor_edit_family_relationships_in_relationship_editor
                  .tr(),
              style: PlotweaverTextStyles.body.copyWith(
                color: getIt<AppColors>().textGrey,
              ),
            ),
            const SizedBox(width: 20),
            PushButton(
              secondary: true,
              controlSize: ControlSize.regular,
              onPressed: () {
                openFamilyRelationshipsEditor(context, characterId)
                    .whenComplete(refreshFamily);
              },
              child: Text(LocaleKeys.character_editor_edit.tr()),
            ),
          ],
        ),
        const SizedBox(height: 15),
        BlocBuilder<CharactersCubit, CharactersState>(
          bloc: BlocProvider.of<CharactersCubit>(context),
          builder: (context, state) {
            final parents = characterParents
                .map((e) {
                  return state.characters.where((element) {
                    return element.id == e;
                  }).firstOrNull;
                })
                .whereType<CharacterSnippet>()
                .toList();
            final children = characterChildren
                .map((e) {
                  return state.characters.where((element) {
                    return element.id == e;
                  }).firstOrNull;
                })
                .whereType<CharacterSnippet>()
                .toList();
            final spouses = characterSpouses
                .map((e) {
                  return state.characters.where((element) {
                    return element.id == e;
                  }).firstOrNull;
                })
                .whereType<CharacterSnippet>()
                .toList();

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (parents.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const MacosIcon(
                              Icons.family_restroom_rounded,
                              size: 15,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.character_editor_parents.tr(),
                              style: PlotweaverTextStyles.body2,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ...parents.map(
                          (e) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<ViewCubit>(context).openTab(
                                    TabModel(
                                      id: 'character_${e.id}',
                                      title: e.name,
                                      type: TabType.character,
                                      associatedContentId: e.id,
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
                                    e.name,
                                    style: PlotweaverTextStyles.body,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ],
                    ),
                  ),
                if (spouses.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const MacosIcon(
                              CupertinoIcons.heart_fill,
                              size: 15,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.character_editor_spouses.tr(),
                              style: PlotweaverTextStyles.body2,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ...spouses.map(
                          (e) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<ViewCubit>(context).openTab(
                                    TabModel(
                                      id: 'character_${e.id}',
                                      title: e.name,
                                      type: TabType.character,
                                      associatedContentId: e.id,
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
                                    e.name,
                                    style: PlotweaverTextStyles.body,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ],
                    ),
                  ),
                if (children.isNotEmpty)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const MacosIcon(
                              Icons.child_friendly_rounded,
                              size: 15,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.character_editor_children.tr(),
                              style: PlotweaverTextStyles.body2,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ...children
                            .map((e) => CharacterLinkWidget(character: e))
                            .toList(),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
