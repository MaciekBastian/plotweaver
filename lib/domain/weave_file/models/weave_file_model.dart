import 'package:json_annotation/json_annotation.dart';

import '../../project/models/project_info_model.dart';
import 'general_info_model.dart';

part 'weave_file_model.g.dart';

@JsonSerializable()
class WeaveFileModel {
  WeaveFileModel({
    required this.generalInfo,
    required this.projectInfo,
  });

  factory WeaveFileModel.fromJson(Map<String, dynamic> json) => WeaveFileModel(
        generalInfo: GeneralInfoModel.fromJson(
          (json['general'] as Map).map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        ),
        projectInfo: ProjectInfoModel.fromJson(
          (json['project'] as Map).map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        ),
      );

  final GeneralInfoModel generalInfo;
  final ProjectInfoModel projectInfo;

  Map<String, dynamic> toJson() => {
        'general': generalInfo.toJson(),
        'project': projectInfo.toJson(),
      };
}
