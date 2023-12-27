import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/constants/weave_file.dart';
import '../../../domain/characters/models/character_model.dart';
import '../../../domain/global/models/file_snippet_model.dart';
import '../../../domain/plots/models/plot_model.dart';
import '../../../domain/project/models/project_info_model.dart';
import '../../../domain/weave_file/models/general_info_model.dart';
import '../../../domain/weave_file/models/weave_file_model.dart';
import '../../../domain/weave_file/repository/weave_file_repository.dart';

@LazySingleton(as: WeaveFileRepository)
class WeaveFileRepositoryImpl implements WeaveFileRepository {
  String? _openedProjectPath;
  WeaveFileModel? _openedFile;

  @override
  WeaveFileModel? get openedFile => _openedFile;

  @override
  Future<WeaveFileModel> openFile(FileSnippetModel projectFile) async {
    final path = Uri.parse(projectFile.path).toFilePath();
    final file = File(path);
    final content = await file.readAsString();
    final decoded = json.decode(content) as Map;
    final weave = WeaveFileModel.fromJson(
      decoded.map((key, value) => MapEntry(key.toString(), value)),
    );
    _openedFile = weave;
    _openedProjectPath = path;
    return weave;
  }

  @override
  Future<bool> saveProjectChange(ProjectInfoModel projectInfoModel) async {
    if (_openedFile == null || _openedProjectPath == null) {
      return false;
    }
    try {
      final generalInfo = await _getGeneralInfo(
        _openedFile!.generalInfo.createdAt,
      );
      final weave = WeaveFileModel(
        generalInfo: generalInfo,
        projectInfo: projectInfoModel,
        characters: _openedFile!.characters,
        plots: _openedFile!.plots,
      );
      final content = weave.toJson();
      final encoded = json.encode(content);
      final file = File(_openedProjectPath!);
      await file.writeAsString(encoded);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<GeneralInfoModel> _getGeneralInfo(DateTime createdAt) async {
    final package = await PackageInfo.fromPlatform();
    final info = GeneralInfoModel(
      createdAt: createdAt,
      lastAccessedAt: DateTime.now(),
      plotweaverVersion: '${package.version}+${package.buildNumber}',
      weaveVersion: WEAVE_FILE_VERSION,
    );
    return info;
  }

  @override
  Future<bool> saveCharactersChanges(
    List<CharacterModel> modifiedCharacters,
    List<String> removedCharacterIds,
  ) async {
    if (_openedFile == null || _openedProjectPath == null) {
      return false;
    }
    try {
      final generalInfo = await _getGeneralInfo(
        _openedFile!.generalInfo.createdAt,
      );
      final List<CharacterModel> characters =
          _openedFile!.characters == null ? [] : [..._openedFile!.characters!];

      for (final person in modifiedCharacters) {
        final index = characters.indexWhere(
          (element) => element.id == person.id,
        );
        if (index == -1) {
          characters.add(person);
        } else {
          characters
            ..removeAt(index)
            ..insert(index, person);
        }
      }

      for (final personId in removedCharacterIds) {
        final index = characters.indexWhere(
          (element) => element.id == personId,
        );
        if (index >= 0) {
          characters.removeAt(index);
        }
      }

      final weave = WeaveFileModel(
        generalInfo: generalInfo,
        projectInfo: _openedFile!.projectInfo,
        characters: characters,
        plots: _openedFile!.plots,
      );
      final content = weave.toJson();
      final encoded = json.encode(content);
      final file = File(_openedProjectPath!);
      await file.writeAsString(encoded);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> savePlotsChanges(
    List<PlotModel> modifiedPlots,
    List<String> removedPlotsIds,
  ) async {
    if (_openedFile == null || _openedProjectPath == null) {
      return false;
    }
    try {
      final generalInfo = await _getGeneralInfo(
        _openedFile!.generalInfo.createdAt,
      );
      final List<PlotModel> plots =
          _openedFile!.plots == null ? [] : [..._openedFile!.plots!];

      for (final person in modifiedPlots) {
        final index = plots.indexWhere(
          (element) => element.id == person.id,
        );
        if (index == -1) {
          plots.add(person);
        } else {
          plots
            ..removeAt(index)
            ..insert(index, person);
        }
      }

      for (final personId in removedPlotsIds) {
        final index = plots.indexWhere(
          (element) => element.id == personId,
        );
        if (index >= 0) {
          plots.removeAt(index);
        }
      }

      final weave = WeaveFileModel(
        generalInfo: generalInfo,
        projectInfo: _openedFile!.projectInfo,
        characters: _openedFile!.characters,
        plots: plots,
      );
      final content = weave.toJson();
      final encoded = json.encode(content);
      final file = File(_openedProjectPath!);
      await file.writeAsString(encoded);
      return true;
    } catch (e) {
      return false;
    }
  }
}
