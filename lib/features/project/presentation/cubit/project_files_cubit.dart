import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../characters/domain/usecases/get_all_characters_usecase.dart';
import '../../domain/entities/project_file_entity.dart';
import '../../domain/enums/file_bundle_type.dart';

part 'project_files_cubit.freezed.dart';
part 'project_files_state.dart';

class ProjectFilesCubit extends Cubit<ProjectFilesState> {
  ProjectFilesCubit(
    this._getAllCharactersUsecase,
  ) : super(const ProjectFilesState.loading());

  final GetAllCharactersUsecase _getAllCharactersUsecase;
  String? _projectIdentifier;

  Future<void> checkAndLoadAllFiles([String? identifier]) async {
    _projectIdentifier ??= identifier;

    if (_projectIdentifier == null) {
      return;
    }

    if (state is ProjectFilesStateLoading) {
      await Future.delayed(const Duration(seconds: 1));
    }

    final allCharacters = await _getAllCharactersUsecase.call(
      projectIdentifier: _projectIdentifier!,
    );

    emit(
      ProjectFilesStateActive(
        projectIdentifier: _projectIdentifier!,
        projectFiles: [
          ProjectFileEntity.projectFile(),
          ProjectFileEntity.fileBundle(
            type: FileBundleType.characters,
            files: allCharacters.fold(
              (_) => [],
              (characters) => characters
                  .map(
                    (el) => ProjectFileEntity.characterFile(characterId: el.id),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
