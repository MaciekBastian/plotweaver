import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helpers/id_helper.dart';
import '../../../domain/characters/models/character_model.dart';
import '../../../domain/characters/models/character_snippet.dart';
import '../../../domain/weave_file/repository/weave_file_repository.dart';
import '../../../generated/locale_keys.g.dart';

part 'characters_state.dart';
part 'characters_cubit.freezed.dart';

@singleton
class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(
    this._weaveRepository,
  ) : super(CharactersState());

  final WeaveFileRepository _weaveRepository;

  void init() {
    final characters = _weaveRepository.openedFile?.characters ?? [];
    final snippets = characters
        .map((e) => CharacterSnippet(id: e.id, name: e.name))
        .toList();

    emit(
      state.copyWith(
        characters: snippets,
        hasUnsavedChanges: false,
        openedCharacters: [],
      ),
    );
  }

  CharacterSnippet createNew() {
    final character = CharacterModel(
      id: randomId(),
      name: LocaleKeys.character_editor_unnamed_character.tr(),
    );
    final snippet = CharacterSnippet(id: character.id, name: character.name);
    emit(
      state.copyWith(
        characters: [...state.characters, snippet],
        hasUnsavedChanges: true,
        openedCharacters: [
          ...state.openedCharacters,
          character,
        ],
      ),
    );
    save();
    return snippet;
  }

  Future<void> save() async {
    if (state.hasUnsavedChanges) {
      final result = await _weaveRepository.saveCharactersChanges(
        state.openedCharacters,
      );
      if (result) {
        emit(state.copyWith(hasUnsavedChanges: false));
      }
    }
  }
}
