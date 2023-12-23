import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/values.dart';
import '../../../domain/project/models/file_snippet_model.dart';
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

  Future<bool?> openSystemFilePicker() async {
    final file = await _repository.pickFile();
    if (file == null) {
      return null;
    }
    if (file.path.endsWith('.${PlotweaverNames.weave}')) {
      // TODO: open folder
      return true;
    } else {
      return false;
    }
  }
}
