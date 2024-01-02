import 'package:freezed_annotation/freezed_annotation.dart';

import 'scene_location.dart';
import 'subfragment_snippet.dart';

part 'scene_model.g.dart';

@JsonSerializable()
class SceneModel {
  SceneModel({
    required this.id,
    required this.number,
    this.location = SceneLocation.interior,
    this.setting = '',
    this.cameraNotes = '',
    this.outline = '',
    this.timeOfDay = '',
  });

  factory SceneModel.fromJson(Map<String, dynamic> json) => SceneModel(
        id: json['id'],
        number: json['number'],
        cameraNotes: json['camera_notes'] ?? '',
        outline: json['outline'] ?? '',
        timeOfDay: json['time_of_day'] ?? '',
        setting: json['setting'] ?? '',
        location: SceneLocation.fromCodeName(json['location']),
      );

  final String id;
  final int number;
  final SceneLocation location;
  final String setting;
  final String timeOfDay;
  final String outline;
  final String cameraNotes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'location': location.codeName,
        if (setting.isNotEmpty) 'setting': setting,
        if (timeOfDay.isNotEmpty) 'time_of_day': timeOfDay,
        if (outline.isNotEmpty) 'outline': outline,
        if (cameraNotes.isNotEmpty) 'camera_notes': cameraNotes,
      };

  SubfragmentSnippet toSnippet() => SubfragmentSnippet(
        id: id,
        name: '${location.readable} $setting — $timeOfDay',
        number: number,
      );

  SceneModel copyWith({
    String? id,
    int? number,
    SceneLocation? location,
    String? setting,
    String? timeOfDay,
    String? outline,
    String? cameraNotes,
  }) =>
      SceneModel(
        id: id ?? this.id,
        number: number ?? this.number,
        cameraNotes: cameraNotes ?? this.cameraNotes,
        location: location ?? this.location,
        outline: outline ?? this.outline,
        setting: setting ?? this.setting,
        timeOfDay: timeOfDay ?? this.timeOfDay,
      );
}
