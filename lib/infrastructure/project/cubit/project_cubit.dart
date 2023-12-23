import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/values.dart';
import '../../../domain/global/models/file_snippet_model.dart';
import '../../../domain/project/repository/project_repository.dart';

part 'project_cubit.freezed.dart';
part 'project_state.dart';

@singleton
class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(this._repository) : super(ProjectState());

  final ProjectRepository _repository;

  Future<void> init() async {
    final recent = await _repository.getRecent();
    emit(state.copyWith(recent: recent));
  }

  Future<bool> openProject(FileSnippetModel file) async {
    final canBeOpened = _repository.canBeOpened(file);
    if (!canBeOpened) {
      return false;
    }
    await _repository.addToRecent(file);
    final recent = await _repository.getRecent();
    emit(state.copyWith(openedProject: file, recent: recent));
    return true;
  }

  Future<bool?> createProjectFile() async {
    final file = await _repository.createNewProjectFile();
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
    final file = await _repository.pickFile();
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
}
