import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/sl_config.dart';
import '../../../../core/constants/io_names_constants.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../project/presentation/bloc/current_project/current_project_bloc.dart';
import '../../../tabs/domain/entities/tab_entity.dart';
import '../../../tabs/presentation/cubit/tabs_cubit.dart';
import '../../domain/entities/character_entity.dart';
import '../../domain/usecases/create_character_usecase.dart';
import '../../domain/usecases/delete_character_usecase.dart';
import '../../domain/usecases/get_all_characters_usecase.dart';
import '../../domain/usecases/modify_character_usecase.dart';

part 'characters_editors_bloc.freezed.dart';
part 'characters_editors_event.dart';
part 'characters_editors_state.dart';

class CharactersEditorsBloc
    extends Bloc<CharactersEditorsEvent, CharactersEditorsState> {
  CharactersEditorsBloc(
    this._getAllCharactersUsecase,
    this._modifyCharacterUsecase,
    this._createCharacterUsecase,
    this._deleteCharacterUsecase,
    this._currentProjectBloc,
  ) : super(const CharactersEditorsStateLoading()) {
    on<_Modify>(_onModify);
    on<_Setup>(_onSetup);
    on<_Create>(_onCreate);
    on<_Delete>(_onDelete);
  }

  final GetAllCharactersUsecase _getAllCharactersUsecase;
  final ModifyCharacterUsecase _modifyCharacterUsecase;
  final CreateCharacterUsecase _createCharacterUsecase;
  final DeleteCharacterUsecase _deleteCharacterUsecase;
  final CurrentProjectBloc _currentProjectBloc;

  String? _projectIdentifier;

  void _onModify(_Modify event, Emitter<CharactersEditorsState> emit) {
    if (_projectIdentifier == null) {
      return;
    }
    _modifyCharacterUsecase.call(
      projectIdentifier: _projectIdentifier!,
      character: event.character,
    );
    _currentProjectBloc.add(
      CurrentProjectEvent.toggleUnsavedChangesForTab(event.tabId),
    );

    final List<CharacterEntity> currentCharacters = switch (state) {
      CharactersEditorsStateLoading() => [],
      CharactersEditorsStateSuccess(:final _characters) => _characters,
      CharactersEditorsStateFailure() => [],
      CharactersEditorsStateModified(:final _characters) => _characters,
    };

    final newCharacters = [...currentCharacters];
    final index = newCharacters.indexWhere((el) => el.id == event.character.id);
    if (index == -1) {
      return;
    }
    newCharacters
      ..removeAt(index)
      ..insert(
        index,
        event.character,
      );

    emit(CharactersEditorsStateModified(newCharacters));
  }

  Future<void> _onSetup(
    _Setup event,
    Emitter<CharactersEditorsState> emit,
  ) async {
    _projectIdentifier ??= event.projectIdentifier;
    if (_projectIdentifier == null) {
      return;
    }
    if (state is CharactersEditorsStateLoading ||
        state is CharactersEditorsStateFailure ||
        event.forceForIds.isNotEmpty) {
      final resp = await _getAllCharactersUsecase.call(
        projectIdentifier: _projectIdentifier!,
      );

      resp.fold(
        (error) {
          emit(CharactersEditorsStateFailure(error));
        },
        (characters) {
          if (state is CharactersEditorsStateModified) {
            final newCharacters = [
              ...(state as CharactersEditorsStateModified).characters,
            ];
            for (final element in event.forceForIds) {
              final character =
                  characters.where((el) => el.id == element).firstOrNull;

              final index = newCharacters.indexWhere((el) => el.id == element);
              if (character != null && index != -1) {
                newCharacters
                  ..removeAt(index)
                  ..insert(index, character);
              }
            }
            emit(CharactersEditorsStateModified(newCharacters));
          } else {
            emit(CharactersEditorsStateSuccess(characters));
          }
        },
      );
    }
  }

  Future<void> _onCreate(
    _Create event,
    Emitter<CharactersEditorsState> emit,
  ) async {
    if (_projectIdentifier == null) {
      event.then(null, const UnknownError());
      return;
    }

    final character = CharacterEntity(
      id: 'character_${DateTime.now().millisecondsSinceEpoch}',
      name: S.current.unnamed_character,
    );

    final resp = await _createCharacterUsecase.call(
      projectIdentifier: _projectIdentifier!,
      character: character,
    );

    if (resp.isSome()) {
      event.then(null, resp.asSome());
      return;
    }
    final List<CharacterEntity> currentCharacters = switch (state) {
      CharactersEditorsStateLoading() => [],
      CharactersEditorsStateSuccess(:final _characters) => _characters,
      CharactersEditorsStateFailure() => [],
      CharactersEditorsStateModified(:final _characters) => _characters,
    };

    emit(CharactersEditorsStateModified([...currentCharacters, character]));

    final tabId =
        '${PlotweaverIONamesConstants.directoryNames.characters}${character.id}';

    sl<TabsCubit>().openTab(
      TabEntity.characterTab(
        tabId: tabId,
        characterId: character.id,
      ),
    );

    event.then(character, null);
  }

  CharacterEntity? getCharacter(String characterId) => switch (state) {
        CharactersEditorsStateLoading() => null,
        CharactersEditorsStateSuccess(:final _characters) =>
          _characters.where((el) => el.id == characterId).firstOrNull,
        CharactersEditorsStateFailure() => null,
        CharactersEditorsStateModified(:final _characters) =>
          _characters.where((el) => el.id == characterId).firstOrNull,
      };

  Future<void> _onDelete(
    _Delete event,
    Emitter<CharactersEditorsState> emit,
  ) async {
    if (_projectIdentifier == null) {
      event.then(const UnknownError());
      return;
    }

    final resp = await _deleteCharacterUsecase.call(
      projectIdentifier: _projectIdentifier!,
      characterId: event.characterId,
      projectFilePath: event.projectFilePath,
    );

    if (resp.isSome()) {
      event.then(resp.asSome());
      return;
    }
    final List<CharacterEntity> currentCharacters = [
      ...switch (state) {
        CharactersEditorsStateLoading() => [],
        CharactersEditorsStateSuccess(:final _characters) => _characters,
        CharactersEditorsStateFailure() => [],
        CharactersEditorsStateModified(:final _characters) => _characters,
      },
    ]..removeWhere((el) => el.id == event.characterId);

    emit(CharactersEditorsStateModified([...currentCharacters]));

    final tabId =
        '${PlotweaverIONamesConstants.directoryNames.characters}${event.characterId}';

    sl<TabsCubit>().closeTab(
      TabEntity.characterTab(
        tabId: tabId,
        characterId: event.characterId,
      ),
    );

    event.then(null);
  }
}
