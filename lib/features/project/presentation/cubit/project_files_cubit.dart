import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/project_file_entity.dart';
import '../../domain/enums/file_bundle_type.dart';

part 'project_files_cubit.freezed.dart';
part 'project_files_state.dart';

class ProjectFilesCubit extends Cubit<ProjectFilesState> {
  ProjectFilesCubit() : super(const ProjectFilesState.loading());

  Future<void> checkAndLoadAllFiles(String identifier) async {
    await Future.delayed(const Duration(seconds: 5));
    emit(
      _Active(
        projectIdentifier: identifier,
        projectFiles: [
          ProjectFileEntity.projectFile(),
          ProjectFileEntity.fileBundle(
            type: FileBundleType.characters,
            files: [],
          ),
        ],
      ),
    );
  }
}
