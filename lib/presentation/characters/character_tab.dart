import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Material, InkWell, Colors;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import '../../core/get_it/get_it.dart';
import '../../core/styles/text_styles.dart';
import '../../domain/characters/models/character_enums.dart';
import '../../domain/characters/models/character_model.dart';
import '../../domain/characters/models/character_snippet.dart';
import '../../domain/project/models/project_template.dart';
import '../../generated/locale_keys.g.dart';
import '../../infrastructure/characters/cubit/characters_cubit.dart';
import '../../infrastructure/global/cubit/view_cubit.dart';
import '../../infrastructure/global/models/tab_model.dart';
import '../../infrastructure/global/models/tab_type.dart';
import '../../infrastructure/project/cubit/project_cubit.dart';
import 'widgets/family_relationships_editor.dart';

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
    );
    BlocProvider.of<CharactersCubit>(context).editCharacter(model);
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
                child: _buildRightPane(),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
    );
  }

  Column _buildRightPane() {
    return Column(
      children: [
        Row(
          children: [
            const MacosIcon(CupertinoIcons.text_alignleft),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_description.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.character_editor_description_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: _descriptionController,
            focusNode: _descriptionFocus,
            onChanged: (value) {
              _edit();
            },
            minLines: 5,
            maxLines: 15,
            placeholder: LocaleKeys.character_editor_description.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.person_alt),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_appearance.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.character_editor_appearance_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: _appearanceController,
            focusNode: _appearanceFocus,
            onChanged: (value) {
              _edit();
            },
            minLines: 5,
            maxLines: 15,
            placeholder: LocaleKeys.character_editor_appearance.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.flag),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_goals.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.character_editor_goals_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: _goalsController,
            focusNode: _goalsFocus,
            onChanged: (value) {
              _edit();
            },
            minLines: 5,
            maxLines: 15,
            placeholder: LocaleKeys.character_editor_goals.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            SvgPicture.asset(
              PlotweaverImages.tacticIcon,
              height: 18,
              colorFilter: const ColorFilter.mode(
                CupertinoColors.activeBlue,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.character_editor_lesson.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.character_editor_lesson_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: _lessonController,
            focusNode: _lessonFocus,
            onChanged: (value) {
              _edit();
            },
            minLines: 5,
            maxLines: 15,
            placeholder: LocaleKeys.character_editor_lesson.tr(),
          ),
        ),
        const SizedBox(height: 30),
      ],
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
                openFamilyRelationshipsEditor(context, _id).whenComplete(() {
                  final refreshed = BlocProvider.of<CharactersCubit>(context)
                      .getCharacter(_id);
                  if (refreshed == null) {
                    return;
                  }

                  setState(() {
                    _children = refreshed.children;
                    _spouses = refreshed.spouses;
                    _parents = refreshed.parents;
                  });
                  _save();
                });
              },
              child: Text(LocaleKeys.character_editor_edit.tr()),
            ),
          ],
        ),
        const SizedBox(height: 15),
        BlocBuilder<CharactersCubit, CharactersState>(
          bloc: BlocProvider.of<CharactersCubit>(context),
          builder: (context, state) {
            final parents = _parents
                .map((e) {
                  return state.characters.where((element) {
                    return element.id == e;
                  }).firstOrNull;
                })
                .whereType<CharacterSnippet>()
                .toList();
            final children = _children
                .map((e) {
                  return state.characters.where((element) {
                    return element.id == e;
                  }).firstOrNull;
                })
                .whereType<CharacterSnippet>()
                .toList();
            final spouses = _spouses
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
                      ...children.map(
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
              ],
            );
          },
        ),
      ],
    );
  }
}
