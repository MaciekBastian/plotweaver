import 'package:json_annotation/json_annotation.dart';

import '../mappers/fragment_mapper.dart';
import 'fragment_snippet.dart';
import 'fragment_type.dart';

part 'fragment_model.g.dart';

@JsonSerializable(createFactory: false)
abstract class FragmentModel {
  FragmentModel({
    required this.id,
    required this.name,
    required this.number,
    required this.outline,
    required this.type,
  });

  factory FragmentModel.fromJson(Map<String, dynamic> json) =>
      FragmentMapper().decode(json);

  final String id;
  final String name;
  final int number;
  final FragmentType type;
  final String outline;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'type': type.codeName,
        if (outline.isNotEmpty) 'outline': outline,
      };

  FragmentSnippet toSnippet() => FragmentSnippet(
        id: id,
        name: name,
        number: number,
        type: type,
        subfragments: [],
      );

  FragmentModel newNumber(int newNumber);
}
