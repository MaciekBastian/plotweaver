import 'dart:io';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/global/services/native_file_service.dart';
import '../../../domain/project/models/file_snippet_model.dart';

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
}
