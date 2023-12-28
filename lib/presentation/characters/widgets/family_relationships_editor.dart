import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../core/constants/colors.dart';
import '../../../core/get_it/get_it.dart';
import '../../../core/styles/text_styles.dart';
import '../../../domain/characters/models/character_snippet.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../infrastructure/characters/cubit/characters_cubit.dart';

Future<void> openFamilyRelationshipsEditor(
  BuildContext context,
  String baseCharacterId,
) =>
    showMacosSheet(
      context: context,
      builder: (context) {
        return MacosSheet(
          child: _FamilyRelationshipsEditor(
            baseCharacterId: baseCharacterId,
          ),
        );
      },
    );

class _FamilyRelationshipsEditor extends StatefulWidget {
  const _FamilyRelationshipsEditor({
    required this.baseCharacterId,
    Key? key,
  }) : super(key: key);

  final String baseCharacterId;

  @override
  State<_FamilyRelationshipsEditor> createState() =>
      __FamilyRelationshipsEditorState();
}

class __FamilyRelationshipsEditorState
    extends State<_FamilyRelationshipsEditor> {
  String? _newParentId;
  String? _newChildId;
  String? _newSpouseId;

  void _save() {
    BlocProvider.of<CharactersCubit>(context).save();
  }

  @override
  Widget build(BuildContext context) {
    final character = BlocProvider.of<CharactersCubit>(context).getCharacter(
      widget.baseCharacterId,
    );

    return Column(
      children: [
        const SizedBox(height: 25),
        const MacosIcon(
          Icons.diversity_1_rounded,
          size: 32,
        ),
        const SizedBox(height: 25),
        Text(
          LocaleKeys.character_editor_family_relationships.tr(),
          style: PlotweaverTextStyles.headline3,
        ),
        const SizedBox(height: 15),
        Text(
          character?.name ?? '',
          style: PlotweaverTextStyles.headline5,
        ),
        const SizedBox(height: 5),
        if (character != null)
          Expanded(
            child: BlocBuilder<CharactersCubit, CharactersState>(
              bloc: BlocProvider.of<CharactersCubit>(context),
              builder: (context, state) {
                return InteractiveViewer(
                  scaleEnabled: false,
                  panEnabled: true,
                  constrained: false,
                  child: _buildTree(
                    character: state.characters
                        .firstWhere((element) => element.id == character.id),
                    allCharacters: state.characters
                        .where((element) => element.id != character.id)
                        .toList(),
                    children: character.children
                        .map(
                          (e) {
                            return state.characters
                                .where((element) => element.id == e)
                                .firstOrNull;
                          },
                        )
                        .whereType<CharacterSnippet>()
                        .toList(),
                    parents: character.parents
                        .map(
                          (e) {
                            return state.characters
                                .where((element) => element.id == e)
                                .firstOrNull;
                          },
                        )
                        .whereType<CharacterSnippet>()
                        .toList(),
                    spouses: character.spouses
                        .map(
                          (e) {
                            return state.characters
                                .where((element) => element.id == e)
                                .firstOrNull;
                          },
                        )
                        .whereType<CharacterSnippet>()
                        .toList(),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 20),
        CupertinoButton.filled(
          onPressed: () {
            _save();
            Navigator.of(context).pop();
          },
          child: Text(LocaleKeys.commands_done.tr()),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Column _buildTree({
    required CharacterSnippet character,
    required List<CharacterSnippet> allCharacters,
    required List<CharacterSnippet> parents,
    required List<CharacterSnippet> children,
    required List<CharacterSnippet> spouses,
  }) {
    final mq = MediaQuery.of(context);
    final availableParents = allCharacters
        .where(
          (element) =>
              !parents.map((e) => e.id).contains(element.id) &&
              !children.map((e) => e.id).contains(element.id),
        )
        .toList();
    final availableChildren = availableParents;
    final availableSpouses = allCharacters
        .where((element) => !spouses.map((e) => e.id).contains(element.id))
        .toList();
    final siblings = <CharacterSnippet>[];
    for (final element in parents) {
      siblings.addAll(
        element.children.map((e) {
          return allCharacters.where((el) => el.id == e).firstOrNull;
        }).whereType<CharacterSnippet>(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // parents row
        Row(
          children: [
            const SizedBox(width: 20),
            SizedBox(
              width: 250,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.character_editor_parents.tr(),
                    style: PlotweaverTextStyles.fieldTitle.copyWith(
                      color: getIt<AppColors>().textGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (availableParents.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: MacosPopupButton<String>(
                              value: _newParentId ?? '',
                              onChanged: (value) {
                                setState(() {
                                  _newParentId = value;
                                });
                              },
                              items: [
                                MacosPopupMenuItem(
                                  value: '',
                                  child: SizedBox(
                                    width: 130,
                                    child: Text(
                                      '- ${LocaleKeys.character_editor_pick_parent.tr()} -',
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                ...availableParents.map(
                                  (e) {
                                    return MacosPopupMenuItem(
                                      value: e.id,
                                      child: SizedBox(
                                        width: 130,
                                        child: Text(
                                          e.name,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          maxLines: 1,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          PushButton(
                            controlSize: ControlSize.regular,
                            onPressed: () {
                              if (_newParentId == null || _newParentId == '') {
                                return;
                              }
                              BlocProvider.of<CharactersCubit>(context)
                                  .addFamilyRelationship(
                                _newParentId!,
                                character.id,
                              );
                              setState(() {
                                _newParentId = null;
                              });
                            },
                            child: Text(
                              LocaleKeys.commands_add.tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Container(
              height: 100,
              color: getIt<AppColors>().dividerColor,
              width: 1,
            ),
            const SizedBox(width: 20),
            ...parents.map((e) {
              return Column(
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    color: getIt<AppColors>().dividerColor,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Text(
                        e.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  PushButton(
                    secondary: true,
                    controlSize: ControlSize.small,
                    mouseCursor: SystemMouseCursors.click,
                    onPressed: () {
                      BlocProvider.of<CharactersCubit>(context)
                          .deleteFamilyRelationship(
                        e.id,
                        character.id,
                      );
                      setState(() {
                        _newParentId = null;
                      });
                    },
                    child: Text(LocaleKeys.commands_delete.tr()),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
        Container(
          height: 1,
          width: mq.size.width * 0.8,
          color: getIt<AppColors>().dividerColor,
        ),
        // siblings row
        Row(
          children: [
            const SizedBox(width: 20),
            SizedBox(
              width: 250,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.character_editor_siblings.tr(),
                    style: PlotweaverTextStyles.fieldTitle.copyWith(
                      color: getIt<AppColors>().textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Container(
              height: 100,
              color: getIt<AppColors>().dividerColor,
              width: 1,
            ),
            ...{...siblings}.map((e) {
              return Container(
                width: 200,
                height: 50,
                color: getIt<AppColors>().dividerColor,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Center(
                  child: Text(
                    e.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
        Container(
          height: 1,
          width: mq.size.width * 0.8,
          color: getIt<AppColors>().dividerColor,
        ),
        // spouses row
        Row(
          children: [
            const SizedBox(width: 20),
            SizedBox(
              width: 250,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.character_editor_spouses.tr(),
                    style: PlotweaverTextStyles.fieldTitle.copyWith(
                      color: getIt<AppColors>().textGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (availableSpouses.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: MacosPopupButton<String>(
                              value: _newSpouseId ?? '',
                              onChanged: (value) {
                                setState(() {
                                  _newSpouseId = value;
                                });
                              },
                              items: [
                                MacosPopupMenuItem(
                                  value: '',
                                  child: SizedBox(
                                    width: 130,
                                    child: Text(
                                      '- ${LocaleKeys.character_editor_pick_spouse.tr()} -',
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                ...availableSpouses.map(
                                  (e) {
                                    return MacosPopupMenuItem(
                                      value: e.id,
                                      child: SizedBox(
                                        width: 130,
                                        child: Text(
                                          e.name,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          maxLines: 1,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          PushButton(
                            controlSize: ControlSize.regular,
                            onPressed: () {
                              if (_newSpouseId == null || _newSpouseId == '') {
                                return;
                              }
                              BlocProvider.of<CharactersCubit>(context)
                                  .addSpouse(_newSpouseId!, character.id);
                              setState(() {
                                _newSpouseId = null;
                              });
                            },
                            child: Text(
                              LocaleKeys.commands_add.tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Container(
              height: 100,
              color: getIt<AppColors>().dividerColor,
              width: 1,
            ),
            const SizedBox(width: 20),
            ...spouses.map((e) {
              return Column(
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    color: getIt<AppColors>().dividerColor,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Text(
                        e.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  PushButton(
                    secondary: true,
                    controlSize: ControlSize.small,
                    mouseCursor: SystemMouseCursors.click,
                    onPressed: () {
                      BlocProvider.of<CharactersCubit>(context)
                          .deleteSpouse(e.id, character.id);
                      setState(() {
                        _newSpouseId = null;
                      });
                    },
                    child: Text(LocaleKeys.commands_delete.tr()),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
        Container(
          height: 1,
          width: mq.size.width * 0.8,
          color: getIt<AppColors>().dividerColor,
        ),
        // children row
        Row(
          children: [
            const SizedBox(width: 20),
            SizedBox(
              width: 250,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.character_editor_children.tr(),
                    style: PlotweaverTextStyles.fieldTitle.copyWith(
                      color: getIt<AppColors>().textGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (availableChildren.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: MacosPopupButton<String>(
                              value: _newChildId ?? '',
                              onChanged: (value) {
                                setState(() {
                                  _newChildId = value;
                                });
                              },
                              items: [
                                MacosPopupMenuItem(
                                  value: '',
                                  child: SizedBox(
                                    width: 130,
                                    child: Text(
                                      '- ${LocaleKeys.character_editor_pick_child.tr()} -',
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                ...availableChildren.map(
                                  (e) {
                                    return MacosPopupMenuItem(
                                      value: e.id,
                                      child: SizedBox(
                                        width: 130,
                                        child: Text(
                                          e.name,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          maxLines: 1,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          PushButton(
                            controlSize: ControlSize.regular,
                            onPressed: () {
                              if (_newChildId == null || _newChildId == '') {
                                return;
                              }
                              BlocProvider.of<CharactersCubit>(context)
                                  .addFamilyRelationship(
                                character.id,
                                _newChildId!,
                              );
                              setState(() {
                                _newChildId = null;
                              });
                            },
                            child: Text(
                              LocaleKeys.commands_add.tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Container(
              height: 100,
              color: getIt<AppColors>().dividerColor,
              width: 1,
            ),
            const SizedBox(width: 20),
            ...children.map((e) {
              return Column(
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    color: getIt<AppColors>().dividerColor,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Text(
                        e.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  PushButton(
                    secondary: true,
                    controlSize: ControlSize.small,
                    mouseCursor: SystemMouseCursors.click,
                    onPressed: () {
                      BlocProvider.of<CharactersCubit>(context)
                          .deleteFamilyRelationship(character.id, e.id);
                      setState(() {
                        _newChildId = null;
                      });
                    },
                    child: Text(LocaleKeys.commands_delete.tr()),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
        Container(
          height: 1,
          width: mq.size.width * 0.8,
          color: getIt<AppColors>().dividerColor,
        ),
      ],
    );
  }
}
