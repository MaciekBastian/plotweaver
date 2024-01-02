import 'package:freezed_annotation/freezed_annotation.dart';

import 'subfragment_snippet.dart';

part 'chapter_model.g.dart';

@JsonSerializable()
class ChapterModel {
  ChapterModel({
    required this.id,
    required this.title,
    required this.number,
    this.outline = '',
    this.timeOfAction = '',
    this.narrationCharacterId,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) => ChapterModel(
        id: json['id'],
        title: json['title'],
        number: json['number'],
        narrationCharacterId: json['narration_character_id'],
        outline: json['outline'] ?? '',
        timeOfAction: json['time_of_action'] ?? '',
      );

  final String id;
  final int number;
  final String title;
  final String outline;
  final String? narrationCharacterId;
  final String timeOfAction;

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'title': title,
        if (outline.isNotEmpty) 'outline': outline,
        if (narrationCharacterId != null)
          'narration_character_id': narrationCharacterId,
        if (timeOfAction.isNotEmpty) 'time_of_action': timeOfAction,
      };

  SubfragmentSnippet toSnippet() => SubfragmentSnippet(
        id: id,
        name: title,
        number: number,
      );

  ChapterModel copyWith({
    String? id,
    int? number,
    String? title,
    String? outline,
    String? narrationCharacterId,
    String? timeOfAction,
  }) {
    return ChapterModel(
      id: id ?? this.id,
      title: title ?? this.title,
      number: number ?? this.number,
      narrationCharacterId: narrationCharacterId ?? this.narrationCharacterId,
      outline: outline ?? this.outline,
      timeOfAction: timeOfAction ?? this.timeOfAction,
    );
  }
}
