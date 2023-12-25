part of 'characters_cubit.dart';

@freezed
class CharactersState with _$CharactersState {
  factory CharactersState({
    @Default(false) bool hasUnsavedChanges,
    @Default([]) List<CharacterModel> openedCharacters,
    @Default([]) List<CharacterSnippet> characters,
  }) = _CharactersState;
}
