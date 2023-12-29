import 'package:json_annotation/json_annotation.dart';

import 'character_enums.dart';
import 'character_snippet.dart';

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
    this.lesson = '',
    this.goals = '',
    this.age,
    this.domicile,
    this.occupation,
    this.portrayedBy,
    this.spouses = const [],
    this.children = const [],
    this.parents = const [],
    this.friends = const [],
    this.enemies = const [],
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        appearance: json['appearance'] ?? '',
        description: json['description'] ?? '',
        goals: json['goals'] ?? '',
        lesson: json['lesson'] ?? '',
        domicile: json['domicile'],
        gender: CharacterGender.fromCodeName(json['gender']),
        occupation: json['occupation'],
        portrayedBy: json['portrayed_by'],
        status: CharacterStatus.fromCodeName(json['status']),
        children: json['children'] == null
            ? []
            : (json['children'] as List).map((e) => e.toString()).toList(),
        parents: json['parents'] == null
            ? []
            : (json['parents'] as List).map((e) => e.toString()).toList(),
        spouses: json['spouses'] == null
            ? []
            : (json['spouses'] as List).map((e) => e.toString()).toList(),
        friends: json['friends'] == null
            ? []
            : (json['friends'] as List).map((e) => e.toString()).toList(),
        enemies: json['enemies'] == null
            ? []
            : (json['enemies'] as List).map((e) => e.toString()).toList(),
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
  final String lesson;
  final String? occupation;
  final List<String> children;
  final List<String> parents;
  final List<String> spouses;
  final List<String> friends;
  final List<String> enemies;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        if (appearance.isNotEmpty) 'appearance': appearance,
        if (description.isNotEmpty) 'description': description,
        if (lesson.isNotEmpty) 'lesson': lesson,
        'domicile': domicile,
        'gender': gender.codeName,
        if (goals.isNotEmpty) 'goals': goals,
        'occupation': occupation,
        'portrayed_by': portrayedBy,
        'status': status.codeName,
        if (children.isNotEmpty) 'children': children,
        if (parents.isNotEmpty) 'parents': parents,
        if (spouses.isNotEmpty) 'spouses': spouses,
        if (friends.isNotEmpty) 'friends': friends,
        if (enemies.isNotEmpty) 'enemies': enemies,
      };

  CharacterModel copyWith({
    String? name,
    String? age,
    CharacterGender? gender,
    CharacterStatus? status,
    String? portrayedBy,
    String? domicile,
    String? description,
    String? goals,
    String? appearance,
    String? lesson,
    String? occupation,
    List<String>? children,
    List<String>? parents,
    List<String>? spouses,
    List<String>? friends,
    List<String>? enemies,
  }) =>
      CharacterModel(
        id: id,
        name: name ?? this.name,
        age: age ?? this.age,
        appearance: appearance ?? this.appearance,
        children: children ?? this.children,
        description: description ?? this.description,
        domicile: domicile ?? this.domicile,
        gender: gender ?? this.gender,
        goals: goals ?? this.goals,
        lesson: lesson ?? this.lesson,
        occupation: occupation ?? this.occupation,
        parents: parents ?? this.parents,
        portrayedBy: portrayedBy ?? this.portrayedBy,
        spouses: spouses ?? this.spouses,
        status: status ?? this.status,
        friends: friends ?? this.friends,
        enemies: enemies ?? this.enemies,
      );

  CharacterSnippet toSnippet() => CharacterSnippet(
        id: id,
        name: name,
        children: children,
        parents: parents,
        spouses: spouses,
      );
}
