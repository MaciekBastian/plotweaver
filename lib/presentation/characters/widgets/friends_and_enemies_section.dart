import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/images.dart';
import '../../../core/get_it/get_it.dart';
import '../../../core/styles/text_styles.dart';
import '../../../domain/characters/models/character_snippet.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../infrastructure/characters/cubit/characters_cubit.dart';
import 'character_link_widget.dart';

class FriendsAndEnemiesSection extends StatelessWidget {
  const FriendsAndEnemiesSection({
    required this.characterId,
    required this.enemies,
    required this.friends,
    required this.removeFriend,
    required this.removeEnemy,
    required this.setNewEnemyId,
    required this.setNewFriendId,
    required this.addEnemy,
    required this.addFriend,
    this.newEnemyId,
    this.newFriendId,
    super.key,
  });

  final String characterId;
  final List<String> friends;
  final List<String> enemies;
  final String? newFriendId;
  final String? newEnemyId;
  final void Function(String characterId) removeFriend;
  final void Function(String characterId) removeEnemy;
  final void Function(String? characterId) setNewFriendId;
  final void Function(String? characterId) setNewEnemyId;
  final VoidCallback addFriend;
  final VoidCallback addEnemy;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharactersCubit, CharactersState>(
      bloc: BlocProvider.of<CharactersCubit>(context),
      builder: (context, state) {
        final availableCharacters = state.characters
            .where(
              (e) =>
                  !friends.contains(e.id) &&
                  !enemies.contains(e.id) &&
                  characterId != e.id,
            )
            .toList();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const MacosIcon(Icons.emoji_emotions_outlined),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_friends.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    LocaleKeys.character_editor_friends_info.tr(),
                    style: PlotweaverTextStyles.body.copyWith(
                      color: getIt<AppColors>().textGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...friends
                      .map((e) {
                        return state.characters
                            .where((element) => element.id == e)
                            .firstOrNull;
                      })
                      .whereType<CharacterSnippet>()
                      .map(
                        (e) => Row(
                          children: [
                            Expanded(
                              child: CharacterLinkWidget(character: e),
                            ),
                            const SizedBox(width: 15),
                            PushButton(
                              controlSize: ControlSize.regular,
                              secondary: true,
                              onPressed: () {
                                removeFriend(e.id);
                              },
                              child: Text(
                                LocaleKeys.character_editor_remove.tr(),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 10),
                  if (availableCharacters.isNotEmpty)
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Expanded(
                            child: MacosPopupButton<String>(
                              value: newFriendId ?? '',
                              onChanged: setNewFriendId,
                              items: [
                                MacosPopupMenuItem(
                                  value: '',
                                  child: Text(
                                    '- ${LocaleKeys.plots_editor_select_character.tr()} -',
                                  ),
                                ),
                                ...availableCharacters.map(
                                  (e) {
                                    return MacosPopupMenuItem(
                                      value: e.id,
                                      child: Text(e.name),
                                    );
                                  },
                                ).toList(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          PushButton(
                            controlSize: ControlSize.regular,
                            onPressed: addFriend,
                            child: Text(LocaleKeys.plots_editor_add.tr()),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        PlotweaverImages.angryIcon,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          CupertinoColors.activeBlue,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_enemies.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    LocaleKeys.character_editor_enemies_info.tr(),
                    style: PlotweaverTextStyles.body.copyWith(
                      color: getIt<AppColors>().textGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...enemies
                      .map((e) {
                        return state.characters
                            .where((element) => element.id == e)
                            .firstOrNull;
                      })
                      .whereType<CharacterSnippet>()
                      .map(
                        (e) => Row(
                          children: [
                            Expanded(
                              child: CharacterLinkWidget(character: e),
                            ),
                            const SizedBox(width: 15),
                            PushButton(
                              controlSize: ControlSize.regular,
                              secondary: true,
                              onPressed: () {
                                removeEnemy(e.id);
                              },
                              child: Text(
                                LocaleKeys.character_editor_remove.tr(),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                  const SizedBox(height: 10),
                  if (availableCharacters.isNotEmpty)
                    SizedBox(
                      height: 25,
                      child: Row(
                        children: [
                          Expanded(
                            child: MacosPopupButton<String>(
                              value: newEnemyId ?? '',
                              onChanged: setNewEnemyId,
                              items: [
                                MacosPopupMenuItem(
                                  value: '',
                                  child: Text(
                                    '- ${LocaleKeys.plots_editor_select_character.tr()} -',
                                  ),
                                ),
                                ...availableCharacters.map(
                                  (e) {
                                    return MacosPopupMenuItem(
                                      value: e.id,
                                      child: Text(e.name),
                                    );
                                  },
                                ).toList(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          PushButton(
                            controlSize: ControlSize.regular,
                            onPressed: addEnemy,
                            child: Text(LocaleKeys.plots_editor_add.tr()),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
