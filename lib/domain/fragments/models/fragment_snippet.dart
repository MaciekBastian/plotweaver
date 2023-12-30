import 'fragment_type.dart';
import 'subfragment_snippet.dart';

class FragmentSnippet {
  FragmentSnippet({
    required this.id,
    required this.name,
    required this.number,
    required this.type,
    required this.subfragments,
  });

  final String id;
  final String name;
  final FragmentType type;
  final int number;
  final List<SubfragmentSnippet> subfragments;
}
