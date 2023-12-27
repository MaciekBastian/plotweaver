import '../../characters/models/character_model.dart';
import '../../global/models/file_snippet_model.dart';
import '../../plots/models/plot_model.dart';
import '../../project/models/project_info_model.dart';
import '../models/weave_file_model.dart';

abstract class WeaveFileRepository {
  WeaveFileModel? get openedFile;

  Future<WeaveFileModel> openFile(FileSnippetModel projectFile);

  Future<bool> saveProjectChange(ProjectInfoModel projectInfoModel);

  Future<bool> saveCharactersChanges(
    List<CharacterModel> modifiedCharacters,
    List<String> removedCharacterIds,
  );

  Future<bool> savePlotsChanges(
    List<PlotModel> modifiedPlots,
    List<String> removedPlotsIds,
  );
}
