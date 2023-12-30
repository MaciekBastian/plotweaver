import '../../../core/get_it/get_it.dart';
import '../../../infrastructure/project/cubit/project_cubit.dart';
import '../../project/models/project_template.dart';
import '../models/fragment_model.dart';
import '../models/fragment_snippet.dart';
import '../models/fragment_type.dart';

extension ListFragmentExtension on List<FragmentModel> {
  List<FragmentModel> getFragments() {
    final template = getIt<ProjectCubit>().state.projectInfo?.template ??
        ProjectTemplate.book;

    switch (template) {
      case ProjectTemplate.book:
        return where((el) => el.type == FragmentType.part).toList();
      case ProjectTemplate.movie:
        return where((el) => el.type == FragmentType.act).toList();
      case ProjectTemplate.series:
        return where((el) => el.type == FragmentType.episode).toList();
    }
  }
}

extension ListFragmentSnippetExtension on List<FragmentSnippet> {
  List<FragmentSnippet> getFragments() {
    final template = getIt<ProjectCubit>().state.projectInfo?.template ??
        ProjectTemplate.book;

    switch (template) {
      case ProjectTemplate.book:
        return where((el) => el.type == FragmentType.part).toList();
      case ProjectTemplate.movie:
        return where((el) => el.type == FragmentType.act).toList();
      case ProjectTemplate.series:
        return where((el) => el.type == FragmentType.episode).toList();
    }
  }
}
