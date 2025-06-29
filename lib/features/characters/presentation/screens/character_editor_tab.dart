import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/icons_constants.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/fatal_error_widget.dart';
import '../../../../shared/widgets/text_property_widget.dart';
import '../../../tabs/presentation/cubit/tabs_cubit.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/enums/character_enums.dart';
import '../bloc/characters_editors_bloc.dart';
import '../widgets/character_gender_selector_widget.dart';
import '../widgets/character_status_selector_widget.dart';

class CharacterEditorTab extends StatefulWidget {
  const CharacterEditorTab({required this.characterId, super.key});

  final String characterId;

  @override
  State<CharacterEditorTab> createState() => _CharacterEditorTabState();
}

class _CharacterEditorTabState extends State<CharacterEditorTab> {
  CharacterEntity? _characterEntity;

  final _appearanceController = TextEditingController();
  final _appearanceFocusNode = FocusNode();

  final _goalsController = TextEditingController();
  final _goalsFocusNode = FocusNode();

  final _lessonController = TextEditingController();
  final _lessonFocusNode = FocusNode();

  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();

  final _descriptionController = TextEditingController();
  final _descriptionFocusNode = FocusNode();

  final _ageController = TextEditingController();
  final _ageFocusNode = FocusNode();

  CharacterStatus _characterStatus = CharacterStatus.unspecified;

  CharacterGender _characterGender = CharacterGender.unspecified;

  final _portrayedByController = TextEditingController();
  final _portrayedByFocusNode = FocusNode();

  final _domicileController = TextEditingController();
  final _domicileFocusNode = FocusNode();

  final _occupationController = TextEditingController();
  final _occupationFocusNode = FocusNode();

  @override
  void initState() {
    _fillEditor(
      context.read<CharactersEditorsBloc>().getCharacter(widget.characterId),
    );
    super.initState();
  }

  void _fillEditor(CharacterEntity? character) {
    _characterEntity = character;

    if (_characterEntity != null) {
      _appearanceController.text = _characterEntity!.appearance;
      _goalsController.text = _characterEntity!.goals;
      _lessonController.text = _characterEntity!.lesson;
      _nameController.text = _characterEntity!.name;
      _descriptionController.text = _characterEntity!.description;
      _ageController.text = _characterEntity!.age;
      _characterGender = _characterEntity!.gender;
      _portrayedByController.text = _characterEntity!.portrayedBy;
      _domicileController.text = _characterEntity!.domicile;
      _occupationController.text = _characterEntity!.occupation;

      _characterStatus = _characterEntity!.status;
    }
  }

  void _sendModifyEvent() {
    final tabId = context.read<TabsCubit>().state.openedTabId;
    if (_characterEntity == null || tabId == null) {
      return;
    }
    final newCharacter = _characterEntity!.copyWith(
      appearance: _appearanceController.text,
      goals: _goalsController.text,
      lesson: _lessonController.text,
      name: _nameController.text,
      description: _descriptionController.text,
      age: _ageController.text,
      status: _characterStatus,
      gender: _characterGender,
      portrayedBy: _portrayedByController.text,
      occupation: _occupationController.text,
      domicile: _domicileController.text,
    );
    _characterEntity = newCharacter;
    context.read<CharactersEditorsBloc>().add(
          CharactersEditorsEvent.modify(
            newCharacter,
            tabId,
          ),
        );
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _goalsController.dispose();
    _lessonController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _ageController.dispose();
    _portrayedByController.dispose();
    _domicileController.dispose();
    _occupationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CharactersEditorsBloc, CharactersEditorsState>(
      listener: (context, state) {
        _fillEditor(
          context
              .read<CharactersEditorsBloc>()
              .getCharacter(widget.characterId),
        );
      },
      listenWhen: (previous, current) =>
          previous.maybeWhen(
            orElse: () => false,
            failure: (_) => true,
            loading: () => true,
          ) &&
          current.maybeMap(orElse: () => false, success: (_) => true),
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () {
            return ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: _buildLeftPane(),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: _buildRightPane(),
                    ),
                    // white space
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            );
          },
          failure: (error) => Center(
            child: FatalErrorWidget(
              error: error,
              onRetry: () async {
                context.read<CharactersEditorsBloc>().add(
                      CharactersEditorsEvent.setup(null, [
                        _characterEntity!.id,
                      ]),
                    );
              },
            ),
          ),
        );
      },
    );
  }

  Column _buildLeftPane() {
    return Column(
      children: [
        TextPropertyWidget(
          icon: const Icon(Icons.badge_outlined),
          title: S.of(context).character_name,
          description: S.of(context).character_name_hint,
          controller: _nameController,
          focusNode: _nameFocusNode,
          onChange: _sendModifyEvent,
          hint: S.of(context).start_typing,
          maxLines: 1,
        ),
        const SizedBox(height: 15),
        TextPropertyWidget(
          icon: const Icon(Icons.format_align_left),
          title: S.of(context).character_description,
          description: S.of(context).character_description_hint,
          controller: _descriptionController,
          focusNode: _descriptionFocusNode,
          onChange: _sendModifyEvent,
          hint: S.of(context).start_typing,
          maxLines: 10,
          minLines: 3,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextPropertyWidget(
                icon: const Icon(Icons.cake_outlined),
                title: S.of(context).character_age,
                description: S.of(context).character_age_hint,
                controller: _ageController,
                focusNode: _ageFocusNode,
                onChange: _sendModifyEvent,
                hint: S.of(context).start_typing,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CharacterStatusSelectorWidget(
                onSelected: (selected) {
                  if (selected != _characterStatus) {
                    setState(() {
                      _characterStatus = selected;
                    });
                    _sendModifyEvent();
                  }
                },
                selected: _characterStatus,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: CharacterGenderSelectorWidget(
                onSelected: (selected) {
                  if (selected != _characterGender) {
                    setState(() {
                      _characterGender = selected;
                    });
                    _sendModifyEvent();
                  }
                },
                selected: _characterGender,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextPropertyWidget(
                icon: const Icon(Icons.theater_comedy_outlined),
                title: S.of(context).character_portrayed_by,
                controller: _portrayedByController,
                focusNode: _portrayedByFocusNode,
                onChange: _sendModifyEvent,
                hint: S.of(context).start_typing,
                maxLines: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextPropertyWidget(
                icon: const Icon(Icons.home_outlined),
                title: S.of(context).character_domicile,
                controller: _domicileController,
                focusNode: _domicileFocusNode,
                onChange: _sendModifyEvent,
                hint: S.of(context).start_typing,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextPropertyWidget(
                icon: const Icon(Icons.work_outline),
                title: S.of(context).character_occupation,
                controller: _occupationController,
                focusNode: _occupationFocusNode,
                onChange: _sendModifyEvent,
                hint: S.of(context).start_typing,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightPane() {
    return Column(
      children: [
        TextPropertyWidget(
          icon: const Icon(Icons.person_3_outlined),
          title: S.of(context).appearance,
          description: S.of(context).appearance_hint,
          controller: _appearanceController,
          focusNode: _appearanceFocusNode,
          onChange: _sendModifyEvent,
          minLines: 6,
          maxLines: 15,
          hint: S.of(context).start_typing,
        ),
        const SizedBox(height: 20),
        TextPropertyWidget(
          icon: const Icon(Icons.flag_outlined),
          title: S.of(context).goals,
          description: S.of(context).goals_hint,
          controller: _goalsController,
          focusNode: _goalsFocusNode,
          onChange: _sendModifyEvent,
          minLines: 6,
          maxLines: 15,
          hint: S.of(context).start_typing,
        ),
        const SizedBox(height: 20),
        TextPropertyWidget(
          icon: SvgPicture.asset(IconsConstants.tactic),
          title: S.of(context).lesson,
          description: S.of(context).lesson_hint,
          controller: _lessonController,
          focusNode: _lessonFocusNode,
          onChange: _sendModifyEvent,
          minLines: 6,
          maxLines: 15,
          hint: S.of(context).start_typing,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
