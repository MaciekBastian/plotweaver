part of 'characters_editors_bloc.dart';

@freezed
sealed class CharactersEditorsState with _$CharactersEditorsState {
  const factory CharactersEditorsState.loading() =
      CharactersEditorsStateLoading;
  const factory CharactersEditorsState.success(
    List<VersionHistory<CharacterEntity>> characters,
  ) = CharactersEditorsStateSuccess;
  const factory CharactersEditorsState.failure(PlotweaverError error) =
      CharactersEditorsStateFailure;
  const factory CharactersEditorsState.modified(
    List<VersionHistory<CharacterEntity>> characters,
  ) = CharactersEditorsStateModified;
}
