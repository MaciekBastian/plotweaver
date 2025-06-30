import 'package:freezed_annotation/freezed_annotation.dart';

part 'tab_entity.freezed.dart';
part 'tab_entity.g.dart';

mixin TabEntityMixin {
  String get tabId;
}

@freezed
sealed class TabEntity with TabEntityMixin, _$TabEntity {
  factory TabEntity.projectTab({required String tabId}) = ProjectTab;

  factory TabEntity.characterTab({
    required String tabId,
    required String characterId,
  }) = CharacterTab;

  const TabEntity._();

  factory TabEntity.fromJson(Map<String, dynamic> json) =>
      _$TabEntityFromJson(json);
}
