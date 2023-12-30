import 'package:json_annotation/json_annotation.dart';

import '../../characters/models/character_model.dart';
import '../../fragments/models/fragment_model.dart';
import '../../plots/models/plot_model.dart';
import '../../project/models/project_info_model.dart';
import 'general_info_model.dart';

part 'weave_file_model.g.dart';

@JsonSerializable()
class WeaveFileModel {
  WeaveFileModel({
    required this.generalInfo,
    required this.projectInfo,
    this.characters,
    this.plots,
    this.fragments,
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
        characters: json['characters'] == null
            ? null
            : (json['characters'] as List)
                .map(
                  (e) => CharacterModel.fromJson(
                    (e as Map).map(
                      (key, value) => MapEntry(key.toString(), value),
                    ),
                  ),
                )
                .toList(),
        plots: json['plots'] == null
            ? null
            : (json['plots'] as List)
                .map(
                  (e) => PlotModel.fromJson(
                    (e as Map).map(
                      (key, value) => MapEntry(key.toString(), value),
                    ),
                  ),
                )
                .toList(),
        fragments: json['fragments'] == null
            ? null
            : (json['fragments'] as List)
                .map(
                  (e) => FragmentModel.fromJson(
                    (e as Map).map(
                      (key, value) => MapEntry(key.toString(), value),
                    ),
                  ),
                )
                .toList(),
      );

  final GeneralInfoModel generalInfo;
  final ProjectInfoModel projectInfo;
  final List<CharacterModel>? characters;
  final List<PlotModel>? plots;
  final List<FragmentModel>? fragments;

  Map<String, dynamic> toJson() => {
        'general': generalInfo.toJson(),
        'project': projectInfo.toJson(),
        if (characters?.isNotEmpty ?? false)
          'characters': characters?.map((e) => e.toJson()).toList(),
        if (plots?.isNotEmpty ?? false)
          'plots': plots?.map((e) => e.toJson()).toList(),
        if (fragments?.isNotEmpty ?? false)
          'fragments': fragments?.map((e) => e.toJson()).toList(),
      };
}
