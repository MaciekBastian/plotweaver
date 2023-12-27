import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helpers/id_helper.dart';
import '../../../domain/plots/models/plot_model.dart';
import '../../../domain/plots/models/plot_snippet.dart';
import '../../../domain/weave_file/repository/weave_file_repository.dart';
import '../../../generated/locale_keys.g.dart';

part 'plots_state.dart';
part 'plots_cubit.freezed.dart';

@singleton
class PlotsCubit extends Cubit<PlotsState> {
  PlotsCubit(this._weaveRepository) : super(PlotsState());

  final WeaveFileRepository _weaveRepository;

  void init() {
    final plots = _weaveRepository.openedFile?.plots ?? [];
    final snippets = plots
        .map((e) => PlotSnippet(id: e.id, name: e.name, subplots: e.subplots))
        .toList();

    emit(
      state.copyWith(
        plots: snippets,
        hasUnsavedChanges: false,
        openedPlots: [],
      ),
    );
  }

  PlotSnippet createNew() {
    final plot = PlotModel(
      id: randomId(),
      name: LocaleKeys.plots_editor_unnamed_plot.tr(),
    );
    final snippet = PlotSnippet(
      id: plot.id,
      name: plot.name,
      subplots: plot.subplots,
    );
    emit(
      state.copyWith(
        plots: [...state.plots, snippet],
        hasUnsavedChanges: true,
        openedPlots: [
          ...state.openedPlots,
          plot,
        ],
      ),
    );
    save();
    return snippet;
  }

  void delete(String plotId) {
    if (state.plots.any((element) => element.id == plotId)) {
      final newPlots = [...state.plots]
        ..removeWhere((element) => element.id == plotId);
      final newOpened = [...state.openedPlots]
        ..removeWhere((element) => element.id == plotId);

      emit(
        state.copyWith(
          plots: newPlots,
          hasUnsavedChanges: true,
          openedPlots: newOpened,
        ),
      );
      save(plotId);
    }
  }

  Future<void> save([String? deleted]) async {
    if (state.hasUnsavedChanges) {
      final result = await _weaveRepository.savePlotsChanges(
        state.openedPlots,
        deleted == null ? [] : [deleted],
      );
      if (result) {
        emit(state.copyWith(hasUnsavedChanges: false));
      }
    }
  }

  PlotModel? getPlot(String id) {
    if (state.openedPlots.any((element) => element.id == id)) {
      return state.openedPlots.firstWhere((element) => element.id == id);
    } else {
      if (_weaveRepository.openedFile == null) {
        return null;
      }
      if (_weaveRepository.openedFile!.plots == null) {
        return null;
      }
      if (_weaveRepository.openedFile!.plots!.any((el) => el.id == id)) {
        final data = _weaveRepository.openedFile!.plots!
            .firstWhere((element) => element.id == id);
        emit(
          state.copyWith(openedPlots: [...state.openedPlots, data]),
        );
        return data;
      }
      return null;
    }
  }

  void editPlot(PlotModel newModel) {
    if (state.openedPlots.any((element) => element.id == newModel.id)) {
      final newOpened = [...state.openedPlots]
        ..removeWhere((element) => element.id == newModel.id)
        ..add(newModel);
      final newSnippets = [...state.plots]
        ..removeWhere((element) => element.id == newModel.id)
        ..add(
          PlotSnippet(
            id: newModel.id,
            name: newModel.name,
            subplots: newModel.subplots,
          ),
        );
      emit(
        state.copyWith(
          openedPlots: newOpened,
          hasUnsavedChanges: true,
          plots: newSnippets,
        ),
      );
    }
  }
}
