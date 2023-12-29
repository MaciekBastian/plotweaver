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
    final snippets = characters.map((e) => e.toSnippet()).toList();

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
    final snippet = character.toSnippet();
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

  void delete(String characterId) {
    if (state.characters.any((element) => element.id == characterId)) {
      final newCharacters = [...state.characters]
        ..removeWhere((element) => element.id == characterId);
      final newOpened = [...state.openedCharacters]
        ..removeWhere((element) => element.id == characterId);

      emit(
        state.copyWith(
          characters: newCharacters,
          hasUnsavedChanges: true,
          openedCharacters: newOpened,
        ),
      );
      save(characterId);
    }
  }

  Future<void> save([String? deleted]) async {
    if (state.hasUnsavedChanges) {
      final result = await _weaveRepository.saveCharactersChanges(
        state.openedCharacters,
        deleted == null ? [] : [deleted],
      );
      if (result) {
        emit(state.copyWith(hasUnsavedChanges: false));
      }
    }
  }

  CharacterModel? getCharacter(String id) {
    if (state.openedCharacters.any((element) => element.id == id)) {
      return state.openedCharacters.firstWhere((element) => element.id == id);
    } else {
      if (_weaveRepository.openedFile == null) {
        return null;
      }
      if (_weaveRepository.openedFile!.characters == null) {
        return null;
      }
      if (_weaveRepository.openedFile!.characters!.any((el) => el.id == id)) {
        final data = _weaveRepository.openedFile!.characters!
            .firstWhere((element) => element.id == id);
        emit(
          state.copyWith(openedCharacters: [...state.openedCharacters, data]),
        );
        return data;
      }
      return null;
    }
  }

  void editCharacter(CharacterModel newModel) {
    if (state.openedCharacters.any((element) => element.id == newModel.id)) {
      final newOpened = [...state.openedCharacters]
        ..removeWhere((element) => element.id == newModel.id)
        ..add(newModel);
      final newSnippets = [...state.characters]
        ..removeWhere((element) => element.id == newModel.id)
        ..add(newModel.toSnippet());
      emit(
        state.copyWith(
          openedCharacters: newOpened,
          hasUnsavedChanges: true,
          characters: newSnippets,
        ),
      );
    }
  }

  void addFamilyRelationship(String parentId, String childId) {
    final parent = getCharacter(parentId);
    final child = getCharacter(childId);

    if (parent == null || child == null) {
      return;
    }
    final newChildren = {...parent.children, childId}.toList();
    final newParents = {...child.parents, parentId}.toList();
    final newParent = parent.copyWith(children: newChildren);
    final newChild = child.copyWith(parents: newParents);

    final newOpened = [...state.openedCharacters]
      ..removeWhere((el) => el.id == parentId || el.id == childId)
      ..add(newChild)
      ..add(newParent);
    final newSnippets = [...state.characters]
      ..removeWhere((el) => el.id == parentId || el.id == childId)
      ..add(newChild.toSnippet())
      ..add(newParent.toSnippet());

    emit(
      state.copyWith(
        openedCharacters: newOpened,
        characters: newSnippets,
        hasUnsavedChanges: true,
      ),
    );
    save();
  }

  void deleteFamilyRelationship(String parentId, String childId) {
    final parent = getCharacter(parentId);
    final child = getCharacter(childId);

    if (parent == null || child == null) {
      return;
    }
    final newChildren =
        {...parent.children}.where((element) => element != childId).toList();
    final newParents =
        {...child.parents}.where((element) => element != parentId).toList();
    final newParent = parent.copyWith(children: newChildren);
    final newChild = child.copyWith(parents: newParents);

    final newOpened = [...state.openedCharacters]
      ..removeWhere((el) => el.id == parentId || el.id == childId)
      ..add(newChild)
      ..add(newParent);
    final newSnippets = [...state.characters]
      ..removeWhere((el) => el.id == parentId || el.id == childId)
      ..add(newChild.toSnippet())
      ..add(newParent.toSnippet());

    emit(
      state.copyWith(
        openedCharacters: newOpened,
        characters: newSnippets,
        hasUnsavedChanges: true,
      ),
    );
    save();
  }

  void addSpouse(String spouse1, String spouse2) {
    final s1 = getCharacter(spouse1);
    final s2 = getCharacter(spouse2);

    if (s1 == null || s2 == null) {
      return;
    }

    final newS1 = s1.copyWith(spouses: {...s1.spouses, spouse2}.toList());
    final newS2 = s2.copyWith(spouses: {...s2.spouses, spouse1}.toList());

    final newOpened = [...state.openedCharacters]
      ..removeWhere((el) => el.id == spouse1 || el.id == spouse2)
      ..add(newS1)
      ..add(newS2);
    final newSnippets = [...state.characters]
      ..removeWhere((el) => el.id == spouse1 || el.id == spouse2)
      ..add(newS1.toSnippet())
      ..add(newS2.toSnippet());

    emit(
      state.copyWith(
        openedCharacters: newOpened,
        characters: newSnippets,
        hasUnsavedChanges: true,
      ),
    );
    save();
  }

  void deleteSpouse(String spouse1, String spouse2) {
    final s1 = getCharacter(spouse1);
    final s2 = getCharacter(spouse2);

    if (s1 == null || s2 == null) {
      return;
    }

    final newS1 = s1.copyWith(
      spouses: {...s1.spouses}.where((element) => element != spouse2).toList(),
    );
    final newS2 = s2.copyWith(
      spouses: {...s2.spouses}.where((element) => element != spouse1).toList(),
    );

    final newOpened = [...state.openedCharacters]
      ..removeWhere((el) => el.id == spouse1 || el.id == spouse2)
      ..add(newS1)
      ..add(newS2);
    final newSnippets = [...state.characters]
      ..removeWhere((el) => el.id == spouse1 || el.id == spouse2)
      ..add(newS1.toSnippet())
      ..add(newS2.toSnippet());

    emit(
      state.copyWith(
        openedCharacters: newOpened,
        characters: newSnippets,
        hasUnsavedChanges: true,
      ),
    );
    save();
  }

  void addFriend(String character1, String character2) {
    final c1 = getCharacter(character1);
    final c2 = getCharacter(character2);

    if (c1 == null || c2 == null) {
      return;
    }

    final newC1 = c1.copyWith(friends: {...c1.friends, character2}.toList());
    final newC2 = c2.copyWith(friends: {...c2.friends, character1}.toList());

    final newOpened = [...state.openedCharacters]
      ..removeWhere((el) => el.id == character1 || el.id == character2)
      ..add(newC1)
      ..add(newC2);
    final newSnippets = [...state.characters]
      ..removeWhere((el) => el.id == character1 || el.id == character2)
      ..add(newC1.toSnippet())
      ..add(newC2.toSnippet());

    emit(
      state.copyWith(
        openedCharacters: newOpened,
        characters: newSnippets,
        hasUnsavedChanges: true,
      ),
    );
    save();
  }

  void removeFriend(String character1, String character2) {
    final c1 = getCharacter(character1);
    final c2 = getCharacter(character2);

    if (c1 == null || c2 == null) {
      return;
    }

    final newS1 = c1.copyWith(
      friends: {...c1.friends}.where((el) => el != character2).toList(),
    );
    final newS2 = c2.copyWith(
      friends: {...c2.friends}.where((el) => el != character1).toList(),
    );

    final newOpened = [...state.openedCharacters]
      ..removeWhere((el) => el.id == character1 || el.id == character2)
      ..add(newS1)
      ..add(newS2);
    final newSnippets = [...state.characters]
      ..removeWhere((el) => el.id == character1 || el.id == character2)
      ..add(newS1.toSnippet())
      ..add(newS2.toSnippet());

    emit(
      state.copyWith(
        openedCharacters: newOpened,
        characters: newSnippets,
        hasUnsavedChanges: true,
      ),
    );
    save();
  }

  void addEnemy(String character1, String character2) {
    final c1 = getCharacter(character1);
    final c2 = getCharacter(character2);

    if (c1 == null || c2 == null) {
      return;
    }

    final newC1 = c1.copyWith(enemies: {...c1.enemies, character2}.toList());
    final newC2 = c2.copyWith(enemies: {...c2.enemies, character1}.toList());

    final newOpened = [...state.openedCharacters]
      ..removeWhere((el) => el.id == character1 || el.id == character2)
      ..add(newC1)
      ..add(newC2);
    final newSnippets = [...state.characters]
      ..removeWhere((el) => el.id == character1 || el.id == character2)
      ..add(newC1.toSnippet())
      ..add(newC2.toSnippet());

    emit(
      state.copyWith(
        openedCharacters: newOpened,
        characters: newSnippets,
        hasUnsavedChanges: true,
      ),
    );
    save();
  }

  void removeEnemy(String character1, String character2) {
    final c1 = getCharacter(character1);
    final c2 = getCharacter(character2);

    if (c1 == null || c2 == null) {
      return;
    }

    final newS1 = c1.copyWith(
      enemies: {...c1.enemies}.where((el) => el != character2).toList(),
    );
    final newS2 = c2.copyWith(
      enemies: {...c2.enemies}.where((el) => el != character1).toList(),
    );

    final newOpened = [...state.openedCharacters]
      ..removeWhere((el) => el.id == character1 || el.id == character2)
      ..add(newS1)
      ..add(newS2);
    final newSnippets = [...state.characters]
      ..removeWhere((el) => el.id == character1 || el.id == character2)
      ..add(newS1.toSnippet())
      ..add(newS2.toSnippet());

    emit(
      state.copyWith(
        openedCharacters: newOpened,
        characters: newSnippets,
        hasUnsavedChanges: true,
      ),
    );
    save();
  }
}
