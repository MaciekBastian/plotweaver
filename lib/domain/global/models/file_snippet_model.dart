import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_snippet_model.g.dart';

@JsonSerializable()
class FileSnippetModel {
  FileSnippetModel({
    required this.lastAccessed,
    required this.name,
    required this.path,
  });

  factory FileSnippetModel.fromJson(Map<String, dynamic> json) =>
      FileSnippetModel(
        lastAccessed: DateTime.parse(json['last_accessed']),
        name: json['name'],
        path: json['path'],
      );

  final String path;
  final String name;
  final DateTime lastAccessed;

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'last_accessed': lastAccessed.toIso8601String(),
      };
}
