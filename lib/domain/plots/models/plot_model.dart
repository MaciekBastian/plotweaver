import 'package:json_annotation/json_annotation.dart';

part 'plot_model.g.dart';

@JsonSerializable()
class PlotModel {
  PlotModel({
    required this.id,
    required this.name,
    this.charactersInvolved = const [],
    this.conflict = '',
    this.description = '',
    this.result = '',
    this.subplots = const [],
  });

  factory PlotModel.fromJson(Map<String, dynamic> json) => PlotModel(
        id: json['id'],
        name: json['name'],
        charactersInvolved: json['characters_involved'] == null
            ? []
            : (json['characters_involved'] as List)
                .map((e) => e.toString())
                .toList(),
        subplots: json['subplots'] == null
            ? []
            : (json['subplots'] as List).map((e) => e.toString()).toList(),
        conflict: json['conflict'] ?? '',
        description: json['description'] ?? '',
        result: json['result'] ?? '',
      );

  final String id;
  final String name;
  final String description;
  final String conflict;
  final String result;
  final List<String> charactersInvolved;
  final List<String> subplots;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (description.isNotEmpty) 'description': description,
        if (conflict.isNotEmpty) 'conflict': conflict,
        if (result.isNotEmpty) 'result': result,
        if (charactersInvolved.isNotEmpty)
          'characters_involved': charactersInvolved,
        if (subplots.isNotEmpty) 'subplots': subplots,
      };
}
