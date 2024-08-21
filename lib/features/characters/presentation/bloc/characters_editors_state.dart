part of 'characters_editors_bloc.dart';

@freezed
class CharactersEditorsState with _$CharactersEditorsState {
  const factory CharactersEditorsState.loading() = _Loading;
  const factory CharactersEditorsState.success(
    List<CharacterEntity> characters,
  ) = _Success;
  const factory CharactersEditorsState.failure(PlotweaverError error) =
      _Failure;
  const factory CharactersEditorsState.modified(
    List<CharacterEntity> characters,
  ) = _Modified;
}
