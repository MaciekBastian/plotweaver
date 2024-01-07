import 'package:json_annotation/json_annotation.dart';

import 'fragment_model.dart';
import 'fragment_snippet.dart';
import 'fragment_type.dart';
import 'scene_model.dart';

part 'act_model.g.dart';

@JsonSerializable()
class ActModel extends FragmentModel {
  ActModel({
    required super.id,
    required super.name,
    required super.number,
    super.outline = '',
    this.scenes = const [],
  }) : super(type: FragmentType.act);

  factory ActModel.fromJson(Map<String, dynamic> json) => ActModel(
        id: json['id'],
        name: json['name'],
        number: json['number'],
        outline: json['outline'] ?? '',
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

  final List<SceneModel> scenes;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        if (outline.isNotEmpty) 'outline': outline,
        'type': type.codeName,
        if (scenes.isNotEmpty) 'scenes': scenes.map((e) => e.toJson()).toList(),
      };

  @override
  FragmentSnippet toSnippet() => FragmentSnippet(
        id: id,
        name: name,
        number: number,
        type: type,
        subfragments: scenes.map((e) => e.toSnippet()).toList(),
      );

  @override
  ActModel newNumber(int newNumber) {
    return ActModel(
      id: id,
      name: name,
      number: newNumber,
      scenes: scenes,
      outline: outline,
    );
  }
}
