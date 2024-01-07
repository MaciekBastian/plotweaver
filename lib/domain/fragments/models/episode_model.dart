import 'package:json_annotation/json_annotation.dart';

import 'fragment_model.dart';
import 'fragment_type.dart';
import 'scene_model.dart';

part 'episode_model.g.dart';

@JsonSerializable()
class EpisodeModel extends FragmentModel {
  EpisodeModel({
    required super.id,
    required super.name,
    required super.number,
    super.outline = '',
    this.director = '',
    this.scriptWriter = '',
    this.scenes = const [],
  }) : super(type: FragmentType.episode);

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        id: json['id'],
        name: json['name'],
        number: json['number'],
        outline: json['outline'] ?? '',
        director: json['director'] ?? '',
        scriptWriter: json['script_writer'] ?? '',
        scenes: json['scenes'] == null
            ? []
            : (json['scenes'] as List)
                .map(
                  (e) => SceneModel.fromJson(
                    (e as Map).map(
                      (key, value) => MapEntry(key.toString(), value),
                    ),
                  ),
                )
                .toList(),
      );

  final String director;
  final String scriptWriter;
  final List<SceneModel> scenes;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        if (outline.isNotEmpty) 'outline': outline,
        'type': type.codeName,
        if (director.isNotEmpty) 'director': director,
        if (scriptWriter.isNotEmpty) 'script_writer': scriptWriter,
        if (scenes.isNotEmpty) 'scenes': scenes.map((e) => e.toJson()).toList(),
      };

  @override
  EpisodeModel newNumber(int newNumber) {
    return EpisodeModel(
      id: id,
      name: name,
      number: newNumber,
      director: director,
      scenes: scenes,
      scriptWriter: scriptWriter,
      outline: outline,
    );
  }
}
