class CharacterSnippet {
  CharacterSnippet({
    required this.id,
    required this.name,
    required this.children,
    required this.parents,
    required this.spouses,
  });

  final String id;
  final String name;
  final List<String> children;
  final List<String> spouses;
  final List<String> parents;
}
