import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/styles/text_styles.dart';
import '../../domain/characters/models/character_enums.dart';
import '../../domain/characters/models/character_model.dart';
import '../../domain/project/models/project_template.dart';
import '../../generated/locale_keys.g.dart';
import '../../infrastructure/characters/cubit/characters_cubit.dart';
import '../../infrastructure/global/cubit/view_cubit.dart';
import '../../infrastructure/project/cubit/project_cubit.dart';
import 'widgets/character_tab_right_pane.dart';
import 'widgets/family_relationships_section.dart';
import 'widgets/friends_and_enemies_section.dart';

class CharacterTab extends StatefulWidget {
  const CharacterTab({
    required this.characterId,
    super.key,
  });

  final String characterId;

  @override
  State<CharacterTab> createState() => _CharacterTabState();
}

class _CharacterTabState extends State<CharacterTab> {
  late final String _id;
  bool _error = false;
  late final TextEditingController _nameController;
  final _nameFocus = FocusNode();
  late final TextEditingController _descriptionController;
  final _descriptionFocus = FocusNode();
  late final TextEditingController _appearanceController;
  final _appearanceFocus = FocusNode();
  late final TextEditingController _goalsController;
  final _goalsFocus = FocusNode();
  late final TextEditingController _lessonController;
  final _lessonFocus = FocusNode();
  late final TextEditingController _ageController;
  final _ageFocus = FocusNode();
  late final TextEditingController _portrayedByController;
  final _portrayedByFocus = FocusNode();
  late final TextEditingController _occupationController;
  final _occupationFocus = FocusNode();
  late final TextEditingController _domicileController;
  final _domicileFocus = FocusNode();
  late CharacterStatus _status;
  late CharacterGender _gender;
  late List<String> _parents;
  late List<String> _children;
  late List<String> _spouses;
  late List<String> _friends;
  late List<String> _enemies;
  String? _newFriendId;
  String? _newEnemyId;

  @override
  void initState() {
    super.initState();
    final character = BlocProvider.of<CharactersCubit>(context).getCharacter(
      widget.characterId,
    );
    if (character == null) {
      _error = true;
    }
    _id = character?.id ?? '';
    _nameController = TextEditingController(text: character?.name);
    _ageController = TextEditingController(text: character?.age);
    _portrayedByController = TextEditingController(
      text: character?.portrayedBy,
    );
    _descriptionController = TextEditingController(
      text: character?.description,
    );
    _appearanceController = TextEditingController(text: character?.appearance);
    _goalsController = TextEditingController(text: character?.goals);
    _lessonController = TextEditingController(text: character?.lesson);
    _occupationController = TextEditingController(text: character?.occupation);
    _domicileController = TextEditingController(text: character?.domicile);
    _status = character?.status ?? CharacterStatus.unspecified;
    _gender = character?.gender ?? CharacterGender.unspecified;
    _children = character?.children ?? [];
    _spouses = character?.spouses ?? [];
    _parents = character?.parents ?? [];
    _friends = character?.friends ?? [];
    _enemies = character?.enemies ?? [];

    _nameFocus.addListener(_save);
    _descriptionFocus.addListener(_save);
    _appearanceFocus.addListener(_save);
    _goalsFocus.addListener(_save);
    _lessonFocus.addListener(_save);
    _ageFocus.addListener(_save);
    _portrayedByFocus.addListener(_save);
    _domicileFocus.addListener(_save);
    _occupationFocus.addListener(_save);
  }

  void _save() {
    BlocProvider.of<CharactersCubit>(context).save();
  }

  void _edit() {
    final model = CharacterModel(
      id: _id,
      name: _nameController.text,
      description: _descriptionController.text,
      appearance: _appearanceController.text,
      goals: _goalsController.text,
      lesson: _lessonController.text,
      gender: _gender,
      status: _status,
      portrayedBy: _portrayedByController.text.trim().isEmpty
          ? null
          : _portrayedByController.text.trim(),
      age: _ageController.text.trim().isEmpty
          ? null
          : _ageController.text.trim(),
      occupation: _occupationController.text.trim().isEmpty
          ? null
          : _occupationController.text.trim(),
      domicile: _domicileController.text.trim().isEmpty
          ? null
          : _domicileController.text.trim(),
      children: _children,
      parents: _parents,
      spouses: _spouses,
      friends: _friends,
      enemies: _enemies,
    );
    BlocProvider.of<CharactersCubit>(context).editCharacter(model);
    BlocProvider.of<ViewCubit>(context).leavePreviewState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      // TODO: make better error note
      return const Center(
        child: MacosIcon(CupertinoIcons.exclamationmark_triangle),
      );
    }

    return FocusScope(
      canRequestFocus: true,
      child: ListView(
        children: [
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildLeftPane(),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: CharacterTabRightPane(
                  edit: _edit,
                  appearanceController: _appearanceController,
                  appearanceFocus: _appearanceFocus,
                  descriptionController: _descriptionController,
                  descriptionFocus: _descriptionFocus,
                  goalsController: _goalsController,
                  goalsFocus: _goalsFocus,
                  lessonController: _lessonController,
                  lessonFocus: _lessonFocus,
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildLeftPane() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const MacosIcon(CupertinoIcons.person_crop_square),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_name.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: _nameController,
            focusNode: _nameFocus,
            onChanged: (value) {
              _edit();
            },
            maxLines: 1,
            placeholder: LocaleKeys.character_editor_name.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.calendar),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_age.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: MacosTextField(
                      controller: _ageController,
                      focusNode: _ageFocus,
                      onChanged: (value) {
                        _edit();
                      },
                      maxLines: 1,
                      placeholder: LocaleKeys.character_editor_age.tr(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            BlocBuilder<ProjectCubit, ProjectState>(
              builder: (context, state) {
                if ([
                  ProjectTemplate.movie,
                  ProjectTemplate.series,
                ].contains(state.projectInfo?.template)) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const MacosIcon(Icons.theater_comedy_rounded),
                            const SizedBox(width: 8),
                            Text(
                              LocaleKeys.character_editor_portrayed_by.tr(),
                              style: PlotweaverTextStyles.fieldTitle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: MacosTextField(
                            controller: _portrayedByController,
                            focusNode: _portrayedByFocus,
                            onChanged: (value) {
                              _edit();
                            },
                            maxLines: 1,
                            placeholder:
                                LocaleKeys.character_editor_portrayed_by.tr(),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Expanded(child: Container());
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const MacosIcon(Icons.wc_rounded),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_gender.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  MacosPopupButton<CharacterGender>(
                    value: _gender,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _gender = value;
                      });
                      _edit();
                      _save();
                    },
                    items: [
                      MacosPopupMenuItem(
                        value: CharacterGender.unspecified,
                        child: Text(
                          LocaleKeys.character_editor_unspecified.tr(),
                        ),
                      ),
                      MacosPopupMenuItem(
                        value: CharacterGender.male,
                        child: Text(
                          LocaleKeys.character_editor_gender_male.tr(),
                        ),
                      ),
                      MacosPopupMenuItem(
                        value: CharacterGender.female,
                        child: Text(
                          LocaleKeys.character_editor_gender_female.tr(),
                        ),
                      ),
                      MacosPopupMenuItem(
                        value: CharacterGender.other,
                        child: Text(
                          LocaleKeys.character_editor_gender_other.tr(),
                        ),
                      ),
                    ],
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
                      const MacosIcon(CupertinoIcons.timelapse),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_status.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  MacosPopupButton<CharacterStatus>(
                    value: _status,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _status = value;
                      });
                      _edit();
                      _save();
                    },
                    items: [
                      MacosPopupMenuItem(
                        value: CharacterStatus.unspecified,
                        child: Text(
                          LocaleKeys.character_editor_unspecified.tr(),
                        ),
                      ),
                      MacosPopupMenuItem(
                        value: CharacterStatus.alive,
                        child: Text(
                          LocaleKeys.character_editor_alive.tr(),
                        ),
                      ),
                      MacosPopupMenuItem(
                        value: CharacterStatus.deceased,
                        child: Text(
                          LocaleKeys.character_editor_deceased.tr(),
                        ),
                      ),
                      MacosPopupMenuItem(
                        value: CharacterStatus.unknown,
                        child: Text(
                          LocaleKeys.character_editor_unknown.tr(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.home),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_domicile.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: MacosTextField(
                      controller: _domicileController,
                      focusNode: _domicileFocus,
                      onChanged: (value) {
                        _edit();
                      },
                      maxLines: 1,
                      placeholder: LocaleKeys.character_editor_domicile.tr(),
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
                      const MacosIcon(Icons.work_rounded),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.character_editor_occupation.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: MacosTextField(
                      controller: _occupationController,
                      focusNode: _occupationFocus,
                      onChanged: (value) {
                        _edit();
                      },
                      maxLines: 1,
                      placeholder: LocaleKeys.character_editor_occupation.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        FamilyRelationshipsSection(
          characterId: _id,
          characterChildren: _children,
          characterParents: _parents,
          characterSpouses: _spouses,
          refreshFamily: () {
            final refreshed = BlocProvider.of<CharactersCubit>(
              context,
            ).getCharacter(_id);

            if (refreshed == null) {
              return;
            }

            setState(() {
              _children = refreshed.children;
              _spouses = refreshed.spouses;
              _parents = refreshed.parents;
            });
            _save();
          },
        ),
        const SizedBox(height: 30),
        FriendsAndEnemiesSection(
          characterId: _id,
          enemies: _enemies,
          friends: _friends,
          newEnemyId: _newEnemyId,
          newFriendId: _newFriendId,
          setNewEnemyId: (characterId) {
            setState(() {
              _newEnemyId = characterId;
            });
          },
          setNewFriendId: (characterId) {
            setState(() {
              _newFriendId = characterId;
            });
          },
          addEnemy: () {
            if (_newEnemyId == null || _newEnemyId == '') {
              return;
            }
            if (_enemies.contains(_newEnemyId)) {
              return;
            }
            _enemies.add(_newEnemyId!);
            BlocProvider.of<CharactersCubit>(context).addEnemy(
              _id,
              _newEnemyId!,
            );
            setState(() {
              _newEnemyId = null;
            });
          },
          addFriend: () {
            if (_newFriendId == null || _newFriendId == '') {
              return;
            }
            if (_friends.contains(_newFriendId)) {
              return;
            }
            _friends.add(_newFriendId!);
            BlocProvider.of<CharactersCubit>(context).addFriend(
              _id,
              _newFriendId!,
            );
            setState(() {
              _newFriendId = null;
            });
          },
          removeFriend: (characterId) {
            BlocProvider.of<CharactersCubit>(context).removeFriend(
              _id,
              characterId,
            );
            _friends.remove(characterId);
            setState(() {
              _newFriendId = null;
            });
          },
          removeEnemy: (characterId) {
            BlocProvider.of<CharactersCubit>(context).removeEnemy(
              _id,
              characterId,
            );
            _enemies.remove(characterId);
            setState(() {
              _newEnemyId = null;
            });
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
