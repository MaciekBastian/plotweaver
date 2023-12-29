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
    this.isPreview = true,
    this.isPinned = false,
  });

  factory TabModel.fromJson(Map<String, dynamic> json) => TabModel(
        id: json['id'],
        title: json['title'],
        type: TabType.fromCodeName(json['type']),
        associatedContentId: json['associated_content_id'],
        isPreview: json['is_preview'],
        isPinned: json['is_pinned'],
      );

  final String id;
  final String title;
  final TabType type;
  final String? associatedContentId;
  final bool isPreview;
  final bool isPinned;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.codeName,
        'associated_content_id': associatedContentId,
        'is_preview': isPreview,
        'is_pinned': isPinned,
      };

  TabModel copyWith({
    String? id,
    String? title,
    TabType? type,
    String? associatedContentId,
    bool? isPreview,
    bool? isPinned,
  }) =>
      TabModel(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        associatedContentId: associatedContentId ?? this.associatedContentId,
        isPreview: isPreview ?? this.isPreview,
        isPinned: isPinned ?? this.isPinned,
      );
}
