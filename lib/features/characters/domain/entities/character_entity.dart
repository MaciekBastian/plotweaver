import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/plotweaver_errors.dart';
import '../../../../generated/l10n.dart';
import '../enums/character_enums.dart';

part 'character_entity.freezed.dart';

@Freezed(
  fromJson: false,
  toJson: false,
)
class CharacterEntity with _$CharacterEntity {
  factory CharacterEntity({
    required String id,
    required String name,
    @Default('') String age,
    @Default(CharacterStatus.unspecified) CharacterStatus status,
    @Default(CharacterGender.unspecified) CharacterGender gender,
    @Default('') String portrayedBy,
    @Default('') String domicile,
    @Default('') String occupation,
    @Default('') String description,
    @Default('') String goals,
    @Default('') String appearance,
    @Default('') String lesson,
    @Default([]) List<String> children,
    @Default([]) List<String> parents,
    @Default([]) List<String> siblings,
    @Default([]) List<String> spouses,
    @Default([]) List<String> friends,
    @Default([]) List<String> enemies,
    Map<String, dynamic>? other,
  }) = _CharacterEntity;

  const CharacterEntity._();

  factory CharacterEntity.fromJson(Map<String, dynamic> json) {
    final idVal = json[_CharacterEntityJsonKeys.id];
    final nameVal = json[_CharacterEntityJsonKeys.name];

    if (idVal == null || nameVal == null) {
      throw WeaveError.formattingError(
        message: S.current.weave_file_formatting_error,
      );
    }

    final otherValues = {...json}..removeWhere(
        (key, _) => _CharacterEntityJsonKeys.allKeys.contains(key),
      );

    final statusVal = json[_CharacterEntityJsonKeys.status] == null
        ? CharacterStatus.unspecified
        : CharacterStatus.fromCode(json[_CharacterEntityJsonKeys.status]);

    final genderVal = json[_CharacterEntityJsonKeys.gender] == null
        ? CharacterGender.unspecified
        : CharacterGender.fromCode(json[_CharacterEntityJsonKeys.gender]);

    return CharacterEntity(
      id: idVal,
      name: nameVal,
      age: json['age'] == null ? '' : json['age'].toString(),
      status: statusVal,
      gender: genderVal,
      portrayedBy: json[_CharacterEntityJsonKeys.portrayedBy] ?? '',
      domicile: json[_CharacterEntityJsonKeys.domicile] ?? '',
      occupation: json[_CharacterEntityJsonKeys.occupation] ?? '',
      description: json[_CharacterEntityJsonKeys.description] ?? '',
      appearance: json[_CharacterEntityJsonKeys.appearance] ?? '',
      goals: json[_CharacterEntityJsonKeys.goals] ?? '',
      lesson: json[_CharacterEntityJsonKeys.lesson] ?? '',
      children: json[_CharacterEntityJsonKeys.children] ?? [],
      parents: json[_CharacterEntityJsonKeys.parents] ?? [],
      siblings: json[_CharacterEntityJsonKeys.siblings] ?? [],
      spouses: json[_CharacterEntityJsonKeys.spouses] ?? [],
      friends: json[_CharacterEntityJsonKeys.friends] ?? [],
      enemies: json[_CharacterEntityJsonKeys.enemies] ?? [],
      other: otherValues,
    );
  }

  Map<String, dynamic> toJson() => {
        _CharacterEntityJsonKeys.id: id,
        _CharacterEntityJsonKeys.name: name,
        if (age.isNotEmpty) _CharacterEntityJsonKeys.age: age,
        _CharacterEntityJsonKeys.status: status,
        _CharacterEntityJsonKeys.gender: gender,
        if (occupation.isNotEmpty)
          _CharacterEntityJsonKeys.occupation: occupation,
        if (domicile.isNotEmpty) _CharacterEntityJsonKeys.domicile: domicile,
        if (portrayedBy.isNotEmpty)
          _CharacterEntityJsonKeys.portrayedBy: portrayedBy,
        if (other != null) ...other!,
      };
}

final class _CharacterEntityJsonKeys {
  static const id = 'id';
  static const name = 'name';
  static const age = 'age';
  static const status = 'status';
  static const gender = 'gender';
  static const domicile = 'domicile';
  static const occupation = 'occupation';
  static const portrayedBy = 'portrayed_by';
  static const description = 'description';
  static const appearance = 'appearance';
  static const goals = 'goals';
  static const lesson = 'lesson';
  static const children = 'children';
  static const parents = 'parents';
  static const siblings = 'siblings';
  static const spouses = 'spouses';
  static const friends = 'friends';
  static const enemies = 'enemies';

  static const allKeys = [
    id,
    name,
    age,
    status,
    gender,
    domicile,
    occupation,
    portrayedBy,
    description,
    goals,
    lesson,
    appearance,
    children,
    parents,
    siblings,
    spouses,
    friends,
    enemies,
  ];
}
