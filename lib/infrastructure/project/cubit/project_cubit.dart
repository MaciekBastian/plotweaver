import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/values.dart';
import '../../../core/get_it/get_it.dart';
import '../../../domain/global/models/file_snippet_model.dart';
import '../../../domain/project/models/project_info_model.dart';
import '../../../domain/project/models/project_template.dart';
import '../../../domain/project/repository/project_repository.dart';
import '../../../domain/weave_file/repository/weave_file_repository.dart';
import '../../characters/cubit/characters_cubit.dart';
import '../../fragments/cubit/fragments_cubit.dart';
import '../../global/cubit/view_cubit.dart';
import '../../plots/cubit/plots_cubit.dart';

part 'project_cubit.freezed.dart';
part 'project_state.dart';

@singleton
class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(
    this._projectRepository,
    this._weaveFileRepository,
  ) : super(ProjectState());

  final ProjectRepository _projectRepository;
  final WeaveFileRepository _weaveFileRepository;

  Future<void> init() async {
    final recent = await _projectRepository.getRecent();
    emit(state.copyWith(recent: recent));
  }

  Future<bool> openProject(FileSnippetModel file) async {
    final canBeOpened = _projectRepository.canBeOpened(file);
    if (!canBeOpened) {
      return false;
    }
    final projectInfo = await _weaveFileRepository.openFile(file);
    await _projectRepository.addToRecent(file);
    final recent = await _projectRepository.getRecent();
    emit(
      state.copyWith(
        openedProject: file,
        recent: recent,
        projectInfo: projectInfo.projectInfo,
      ),
    );

    getIt<ViewCubit>().openProjectTab();
    getIt<CharactersCubit>().init();
    getIt<PlotsCubit>().init();
    getIt<FragmentsCubit>().init();
    return true;
  }

  Future<bool?> createProjectFile() async {
    final file = await _projectRepository.createNewProjectFile();
    if (file == null) {
      return null;
    }
    if (file.path.endsWith('.${PlotweaverNames.weave}')) {
      final result = await openProject(file);
      return result;
    } else {
      return false;
    }
  }

  Future<bool?> openSystemFilePicker() async {
    final file = await _projectRepository.pickFile();
    if (file == null) {
      return null;
    }
    if (file.path.endsWith('.${PlotweaverNames.weave}')) {
      final result = await openProject(file);
      return result;
    } else {
      return false;
    }
  }

  void update(ProjectInfoModel newModel) {
    emit(state.copyWith(projectInfo: newModel, hasUnsavedChanges: true));
  }

  void editTitle(String newTitle) {
    if (state.projectInfo == null) {
      return;
    }
    final newModel = ProjectInfoModel(
      title: newTitle,
      template: state.projectInfo!.template,
      author: state.projectInfo!.author,
    );

    update(newModel);
  }

  void editAuthor(String newAuthor) {
    if (state.projectInfo == null) {
      return;
    }
    final newModel = ProjectInfoModel(
      title: state.projectInfo!.title,
      template: state.projectInfo!.template,
      author: newAuthor.isEmpty ? null : newAuthor,
    );

    update(newModel);
  }

  Future<void> editTemplate(ProjectTemplate newTemplate) async {
    if (state.projectInfo == null) {
      return;
    }
    final newModel = ProjectInfoModel(
      title: state.projectInfo!.title,
      template: newTemplate,
      author: state.projectInfo!.author,
    );

    update(newModel);
    await getIt<FragmentsCubit>().clearAll();
    getIt<ViewCubit>().closeOtherTabs();
    await save();
  }

  Future<void> save() async {
    if (state.projectInfo != null) {
      final result = await _weaveFileRepository.saveProjectChange(
        state.projectInfo!,
      );
      if (result) {
        emit(state.copyWith(hasUnsavedChanges: false));
      }
    }
  }
}
