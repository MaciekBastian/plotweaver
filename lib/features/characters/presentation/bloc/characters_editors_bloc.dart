import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/config/sl_config.dart';
import '../../../../core/constants/io_names_constants.dart';
import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../core/extensions/dartz_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/entities/version_history.dart';
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
    on<_Undo>(_onUndo);
    on<_Redo>(_onRedo);
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

    final List<VersionHistory<CharacterEntity>> currentCharacters =
        switch (state) {
      CharactersEditorsStateLoading() => [],
      CharactersEditorsStateSuccess(:final _characters) => _characters,
      CharactersEditorsStateFailure() => [],
      CharactersEditorsStateModified(:final _characters) => _characters,
    };

    final newCharacters = [...currentCharacters];
    final index =
        newCharacters.indexWhere((el) => el.current.id == event.character.id);

    newCharacters[index].addState(event.character);

    _currentProjectBloc.add(
      CurrentProjectEvent.toggleUnsavedChangesForTab(event.tabId),
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

              final index =
                  newCharacters.indexWhere((el) => el.current.id == element);
              if (character != null && index != -1) {
                newCharacters
                  ..removeAt(index)
                  ..insert(index, VersionHistory(character));
              }
            }
            emit(CharactersEditorsStateModified(newCharacters));
          } else {
            emit(
              CharactersEditorsStateSuccess(
                characters.map(VersionHistory.new).toList(),
              ),
            );
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
    final List<VersionHistory<CharacterEntity>> currentCharacters =
        switch (state) {
      CharactersEditorsStateLoading() => [],
      CharactersEditorsStateSuccess(:final _characters) => _characters,
      CharactersEditorsStateFailure() => [],
      CharactersEditorsStateModified(:final _characters) => _characters,
    };

    emit(
      CharactersEditorsStateModified(
        [
          ...currentCharacters,
          VersionHistory(character),
        ],
      ),
    );

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
        CharactersEditorsStateSuccess(:final _characters) => _characters
            .where((el) => el.current.id == characterId)
            .firstOrNull
            ?.current,
        CharactersEditorsStateModified(:final _characters) => _characters
            .where((el) => el.current.id == characterId)
            .firstOrNull
            ?.current,
        _ => null,
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
    final List<VersionHistory<CharacterEntity>> currentCharacters = [
      ...switch (state) {
        CharactersEditorsStateLoading() => [],
        CharactersEditorsStateSuccess(:final _characters) => _characters,
        CharactersEditorsStateFailure() => [],
        CharactersEditorsStateModified(:final _characters) => _characters,
      },
    ]..removeWhere((el) => el.current.id == event.characterId);

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

  Future<void> _onUndo(
    _Undo event,
    Emitter<CharactersEditorsState> emit,
  ) async {
    if (_projectIdentifier == null) {
      return;
    }

    final List<VersionHistory<CharacterEntity>> currentCharacters =
        switch (state) {
      CharactersEditorsStateLoading() => [],
      CharactersEditorsStateSuccess(:final _characters) => _characters,
      CharactersEditorsStateFailure() => [],
      CharactersEditorsStateModified(:final _characters) => _characters,
    };

    final index = currentCharacters
        .indexWhere((el) => el.current.id == event.characterId);
    if (index == -1) {
      return;
    }
    final character = currentCharacters[index];
    if (!character.canUndo) {
      event.then(false);
      return;
    }
    character.undo();

    final modifyEvent = _Modify(character.current, event.tabId);
    _onModify(modifyEvent, emit);
    event.then(true);
  }

  Future<void> _onRedo(
    _Redo event,
    Emitter<CharactersEditorsState> emit,
  ) async {
    if (_projectIdentifier == null) {
      return;
    }

    final List<VersionHistory<CharacterEntity>> currentCharacters =
        switch (state) {
      CharactersEditorsStateLoading() => [],
      CharactersEditorsStateSuccess(:final _characters) => _characters,
      CharactersEditorsStateFailure() => [],
      CharactersEditorsStateModified(:final _characters) => _characters,
    };

    final index = currentCharacters
        .indexWhere((el) => el.current.id == event.characterId);
    if (index == -1) {
      return;
    }
    final character = currentCharacters[index];
    if (!character.canRedo) {
      event.then(false);
      return;
    }
    character.redo();

    final modifyEvent = _Modify(character.current, event.tabId);
    _onModify(modifyEvent, emit);

    event.then(true);
  }
}
