import 'package:json_annotation/json_annotation.dart';

import 'tab_type.dart';

part 'tab_model.g.dart';

@JsonSerializable()
class TabModel {
  TabModel({
    required this.id,
    required this.title,
    required this.type,
    this.associatedContentId,
  });

  factory TabModel.fromJson(Map<String, dynamic> json) => TabModel(
        id: json['id'],
        title: json['title'],
        type: TabType.fromCodeName(json['type']),
        associatedContentId: json['associated_content_id'],
      );

  final String id;
  final String title;
  final TabType type;
  final String? associatedContentId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.codeName,
        'associated_content_id': associatedContentId,
      };
}
