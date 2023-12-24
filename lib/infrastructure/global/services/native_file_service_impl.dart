import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/constants/weave_file.dart';
import '../../../domain/global/models/file_snippet_model.dart';
import '../../../domain/global/services/native_file_service.dart';
import '../../../domain/project/models/project_info_model.dart';
import '../../../domain/project/models/project_template.dart';
import '../../../domain/weave_file/models/general_info_model.dart';
import '../../../domain/weave_file/models/weave_file_model.dart';

@LazySingleton(as: NativeFileService)
class NativeFileServiceImpl implements NativeFileService {
  final _fileChannel = const MethodChannel('com.maciejbastian.plotweaver/file');

  @override
  Future<FileSnippetModel?> pickFile() async {
    try {
      if (Platform.isMacOS) {
        final response = await _fileChannel.invokeMethod('pick_file');
        if (response == null) {
          return null;
        } else if (response is String) {
          final path = Uri.parse(response);
          final file = File(path.toFilePath());
          if (!file.existsSync()) {
            return null;
          }
          final lastAccessed = file.lastAccessedSync();
          final name = path.pathSegments.last;
          final snippet = FileSnippetModel(
            lastAccessed: lastAccessed,
            name: name,
            path: response,
          );
          return snippet;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Uri?> pickDirectory() async {
    try {
      if (Platform.isMacOS) {
        final response = await _fileChannel.invokeMethod('pick_directory');
        if (response == null) {
          return null;
        } else if (response is String) {
          final path = Uri.parse(response);
          final file = Directory(path.toFilePath());
          if (!file.existsSync()) {
            return null;
          }
          return path;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<FileSnippetModel?> createNewProjectFile() async {
    try {
      if (Platform.isMacOS) {
        final response = await _fileChannel.invokeMethod(
          'create_new_project_file',
        );
        if (response == null) {
          return null;
        } else if (response is String) {
          final path = Uri.parse(response);
          final package = await PackageInfo.fromPlatform();
          final general = GeneralInfoModel(
            createdAt: DateTime.now(),
            lastAccessedAt: DateTime.now(),
            plotweaverVersion: '${package.version}+${package.buildNumber}',
            weaveVersion: WEAVE_FILE_VERSION,
          );
          final project = ProjectInfoModel(
            title: path.pathSegments.last.substring(
              0,
              path.pathSegments.last.lastIndexOf('.'),
            ),
            template: ProjectTemplate.book,
          );
          final weave = WeaveFileModel(
            generalInfo: general,
            projectInfo: project,
          );
          final weaveJson = weave.toJson();
          final encoded = json.encode(weaveJson);
          final file = File(path.toFilePath());
          await file.create();
          await file.writeAsString(encoded);

          return FileSnippetModel(
            lastAccessed: DateTime.now(),
            name: path.pathSegments.last,
            path: path.toFilePath(),
          );
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
