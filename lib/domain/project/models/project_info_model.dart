import 'package:json_annotation/json_annotation.dart';

import 'project_template.dart';

part 'project_info_model.g.dart';

@JsonSerializable()
class ProjectInfoModel {
  ProjectInfoModel({
    required this.title,
    required this.template,
    this.author,
  });

  factory ProjectInfoModel.fromJson(Map<String, dynamic> json) =>
      ProjectInfoModel(
        title: json['title'],
        template: ProjectTemplate.fromCodeName(json['template']),
        author: json['author'],
      );

  final String title;
  final ProjectTemplate template;
  final String? author;

  Map<String, dynamic> toJson() => {
        'title': title,
        'template': template.codeName,
        'author': author,
      };
}
