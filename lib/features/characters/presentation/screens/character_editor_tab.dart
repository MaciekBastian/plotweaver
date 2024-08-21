import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/overlays/full_screen_alert.dart';
import '../../../project/presentation/bloc/current_project/current_project_bloc.dart';
import '../../../project/presentation/cubit/project_files_cubit.dart';
import '../../domain/entities/character_entity.dart';
import '../bloc/characters_editors_bloc.dart';

class CharacterEditorTab extends StatefulWidget {
  const CharacterEditorTab({required this.characterId, super.key});

  final String characterId;

  @override
  State<CharacterEditorTab> createState() => _CharacterEditorTabState();
}

class _CharacterEditorTabState extends State<CharacterEditorTab> {
  CharacterEntity? _characterEntity;

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
      // TODO: fill editor
    }
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
        return Column(
          children: [
            // temporary
            IconButton(
              onPressed: () {
                final path = context.read<CurrentProjectBloc>().state.maybeMap(
                      orElse: () => null,
                      project: (value) => value.project.path,
                    );
                if (path == null) {
                  return;
                }
                context.read<CharactersEditorsBloc>().add(
                      CharactersEditorsEvent.delete(
                        characterId: widget.characterId,
                        projectFilePath: path,
                        then: (error) {
                          if (error != null) {
                            showFullscreenError(error);
                          } else {
                            context
                                .read<ProjectFilesCubit>()
                                .checkAndLoadAllFiles();
                          }
                        },
                      ),
                    );
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        );
      },
    );
  }
}
