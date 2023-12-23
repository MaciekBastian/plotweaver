import 'package:json_annotation/json_annotation.dart';

part 'general_info_model.g.dart';

@JsonSerializable()
class GeneralInfoModel {
  GeneralInfoModel({
    required this.createdAt,
    required this.lastAccessedAt,
    required this.plotweaverVersion,
    required this.weaveVersion,
  });

  factory GeneralInfoModel.fromJson(Map<String, dynamic> json) =>
      GeneralInfoModel(
        createdAt: DateTime.parse(json['created_at']),
        lastAccessedAt: DateTime.parse(json['last_accessed_at']),
        plotweaverVersion: json['plotweaver_version'],
        weaveVersion: json['weave_version'],
      );

  final DateTime createdAt;
  final DateTime lastAccessedAt;
  final String plotweaverVersion;
  final String weaveVersion;

  Map<String, dynamic> toJson() => {
        'created_at': createdAt.toIso8601String(),
        'last_accessed_at': lastAccessedAt.toIso8601String(),
        'plotweaver_version': plotweaverVersion,
        'weave_version': weaveVersion,
      };
}
