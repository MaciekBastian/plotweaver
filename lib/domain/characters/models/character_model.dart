import 'package:json_annotation/json_annotation.dart';

import 'character_enums.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel {
  CharacterModel({
    required this.id,
    required this.name,
    this.gender = CharacterGender.unspecified,
    this.status = CharacterStatus.unspecified,
    this.appearance = '',
    this.description = '',
    this.goals = '',
    this.age,
    this.domicile,
    this.occupation,
    this.portrayedBy,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        appearance: json['appearance'],
        description: json['description'],
        domicile: json['domicile'],
        gender: CharacterGender.fromCodeName(json['gender']),
        goals: json['goals'],
        occupation: json['occupation'],
        portrayedBy: json['portrayed_by'],
        status: CharacterStatus.fromCodeName(json['status']),
      );

  final String id;
  final String name;
  final String? age;
  final CharacterGender gender;
  final CharacterStatus status;
  final String? portrayedBy;
  final String? domicile;
  final String description;
  final String goals;
  final String appearance;
  final String? occupation;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'appearance': appearance,
        'description': description,
        'domicile': domicile,
        'gender': gender.codeName,
        'goals': goals,
        'occupation': occupation,
        'portrayed_by': portrayedBy,
        'status': status.codeName,
      };
}
