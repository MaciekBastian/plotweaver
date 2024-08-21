part of 'characters_editors_bloc.dart';

@freezed
class CharactersEditorsEvent with _$CharactersEditorsEvent {
  const factory CharactersEditorsEvent.modify(
    CharacterEntity character,
    String tabId,
  ) = _Modify;

  const factory CharactersEditorsEvent.setup([
    String? projectIdentifier,
    @Default([]) List<String> forceForIds,
  ]) = _Setup;

  const factory CharactersEditorsEvent.create({
    required void Function(CharacterEntity? character, PlotweaverError? error)
        then,
  }) = _Create;

  const factory CharactersEditorsEvent.delete({
    required String characterId,
    required String projectFilePath,
    required void Function(PlotweaverError? error) then,
  }) = _Delete;
}
