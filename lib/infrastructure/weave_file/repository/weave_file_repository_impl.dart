import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/constants/weave_file.dart';
import '../../../domain/characters/models/character_model.dart';
import '../../../domain/global/models/file_snippet_model.dart';
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

      final weave = WeaveFileModel(
        generalInfo: generalInfo,
        projectInfo: _openedFile!.projectInfo,
        characters: characters,
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