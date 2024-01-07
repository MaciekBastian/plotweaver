import 'package:json_annotation/json_annotation.dart';

import 'chapter_model.dart';
import 'fragment_model.dart';
import 'fragment_snippet.dart';
import 'fragment_type.dart';

part 'part_model.g.dart';

@JsonSerializable()
class PartModel extends FragmentModel {
  PartModel({
    required super.id,
    required super.name,
    required super.number,
    super.outline = '',
    this.author = '',
    this.chapters = const [],
  }) : super(type: FragmentType.part);

  factory PartModel.fromJson(Map<String, dynamic> json) => PartModel(
        id: json['id'],
        name: json['name'],
        number: json['number'],
        outline: json['outline'] ?? '',
        author: json['author'] ?? '',
        chapters: json['chapters'] == null
            ? []
            : (json['chapters'] as List)
                .map(
                  (e) => ChapterModel.fromJson(
                    (e as Map).map(
                      (key, value) => MapEntry(key.toString(), value),
                    ),
                  ),
                )
                .toList(),
      );

  final String author;
  final List<ChapterModel> chapters;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        if (outline.isNotEmpty) 'outline': outline,
        'type': type.codeName,
        if (author.isNotEmpty) 'author': author,
        if (chapters.isNotEmpty)
          'chapters': chapters.map((e) => e.toJson()).toList(),
      };

  @override
  FragmentSnippet toSnippet() => FragmentSnippet(
        id: id,
        name: name,
        number: number,
        type: type,
        subfragments: chapters.map((e) => e.toSnippet()).toList(),
      );

  @override
  PartModel newNumber(int newNumber) {
    return PartModel(
      id: id,
      name: name,
      number: newNumber,
      author: author,
      chapters: chapters,
      outline: outline,
    );
  }
}
