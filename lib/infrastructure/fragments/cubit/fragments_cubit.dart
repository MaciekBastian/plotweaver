import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/get_it/get_it.dart';
import '../../../core/helpers/id_helper.dart';
import '../../../domain/fragments/models/act_model.dart';
import '../../../domain/fragments/models/episode_model.dart';
import '../../../domain/fragments/models/fragment_model.dart';
import '../../../domain/fragments/models/fragment_snippet.dart';
import '../../../domain/fragments/models/part_model.dart';
import '../../../domain/project/models/project_template.dart';
import '../../../domain/weave_file/repository/weave_file_repository.dart';
import '../../../generated/locale_keys.g.dart';
import '../../project/cubit/project_cubit.dart';

part 'fragments_state.dart';
part 'fragments_cubit.freezed.dart';

@singleton
class FragmentsCubit extends Cubit<FragmentsState> {
  FragmentsCubit(this._weaveRepository) : super(FragmentsState());

  final WeaveFileRepository _weaveRepository;

  void init() {
    final fragments = _weaveRepository.openedFile?.fragments ?? [];
    final snippets = fragments.map((e) => e.toSnippet()).toList();
    if (fragments.isEmpty) {
      final newFragment = createNew(true);
      snippets.add(newFragment);
    }

    emit(
      state.copyWith(
        fragments: snippets,
        hasUnsavedChanges: false,
        openedFragments: [],
      ),
    );
    if (fragments.isEmpty) {
      save();
    }
  }

  FragmentSnippet createNew([bool skipSave = false]) {
    final template = getIt<ProjectCubit>().state.projectInfo?.template ??
        ProjectTemplate.book;

    late final FragmentModel fragment;
    final id = randomId();
    final number = state.fragments.isEmpty
        ? 1
        : state.fragments.map((e) => e.number).reduce(math.max) + 1;

    switch (template) {
      case ProjectTemplate.book:
        fragment = PartModel(
          id: id,
          name: '${LocaleKeys.fragments_editor_part.tr()} $number.',
          number: number,
        );
        break;
      case ProjectTemplate.movie:
        fragment = ActModel(
          id: id,
          name: '${LocaleKeys.fragments_editor_act.tr()} $number.',
          number: number,
        );
        break;
      case ProjectTemplate.series:
        fragment = EpisodeModel(
          id: id,
          name: '${LocaleKeys.fragments_editor_episode.tr()} $number.',
          number: number,
        );
        break;
    }

    final snippet = fragment.toSnippet();
    emit(
      state.copyWith(
        fragments: [...state.fragments, snippet],
        hasUnsavedChanges: true,
        openedFragments: [
          ...state.openedFragments,
          fragment,
        ],
      ),
    );
    if (!skipSave) {
      save();
    }
    return snippet;
  }

  void delete(String fragmentId) {
    if (state.fragments.length == 1) {
      return;
    }
    if (state.fragments.any((element) => element.id == fragmentId)) {
      final newFragments = [...state.fragments]
        ..removeWhere((element) => element.id == fragmentId);
      final newOpened = [...state.openedFragments]
        ..removeWhere((element) => element.id == fragmentId);

      emit(
        state.copyWith(
          fragments: newFragments,
          hasUnsavedChanges: true,
          openedFragments: newOpened,
        ),
      );
      save([fragmentId]);
    }
  }

  Future<void> save([List<String>? deleted]) async {
    if (state.hasUnsavedChanges) {
      final result = await _weaveRepository.saveFragmentsChanges(
        state.openedFragments,
        deleted ?? [],
      );
      if (result) {
        emit(state.copyWith(hasUnsavedChanges: false));
      }
    }
  }

  Future<void> clearAll() async {
    if (state.fragments.isNotEmpty) {
      emit(state.copyWith(hasUnsavedChanges: true));
      await save(state.fragments.map((e) => e.id).toList());
      emit(FragmentsState());
      createNew();
    }
  }

  FragmentModel? getFragment(String id) {
    if (state.openedFragments.any((element) => element.id == id)) {
      return state.openedFragments.firstWhere((element) => element.id == id);
    } else {
      if (_weaveRepository.openedFile == null) {
        return null;
      }
      if (_weaveRepository.openedFile!.fragments == null) {
        return null;
      }
      if (_weaveRepository.openedFile!.fragments!.any((el) => el.id == id)) {
        final data = _weaveRepository.openedFile!.fragments!
            .firstWhere((element) => element.id == id);
        emit(
          state.copyWith(openedFragments: [...state.openedFragments, data]),
        );
        return data;
      }
      return null;
    }
  }

  void editFragment(FragmentModel newModel) {
    if (state.openedFragments.any((element) => element.id == newModel.id)) {
      final newOpened = [...state.openedFragments]
        ..removeWhere((element) => element.id == newModel.id)
        ..add(newModel);
      final newSnippets = [...state.fragments]
        ..removeWhere((element) => element.id == newModel.id)
        ..add(newModel.toSnippet());
      emit(
        state.copyWith(
          openedFragments: newOpened,
          hasUnsavedChanges: true,
          fragments: newSnippets,
        ),
      );
    }
  }

  void changeFragmentNumber(int oldNumber, int newNumber) {
    final fragments = [...state.fragments]
      ..sort((a, b) => a.number.compareTo(b.number));

    final toBeRemoved =
        state.openedFragments.where((el) => el.number == oldNumber).firstOrNull;

    if (toBeRemoved == null) {
      return;
    }
    fragments
      ..removeWhere((element) => element.number == oldNumber)
      ..insert(newNumber - 1, toBeRemoved.toSnippet());

    final indexed = fragments.indexed.toList();

    for (final element in indexed) {
      final index = element.$1;
      final value = element.$2;
      final fragment = getFragment(value.id);
      if (fragment == null) {
        fragments.remove(value);
        continue;
      }
      editFragment(fragment.newNumber(index + 1));
    }
    emit(state.copyWith(hasUnsavedChanges: true));
  }
}
