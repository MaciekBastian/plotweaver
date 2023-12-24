import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/get_it/get_it.dart';
import '../../core/styles/text_styles.dart';
import '../../domain/global/models/command.dart';
import '../../domain/global/services/command_dispatcher.dart';
import '../../domain/project/models/project_template.dart';
import '../../generated/locale_keys.g.dart';
import '../../infrastructure/project/cubit/project_cubit.dart';

class EditProjectTab extends StatefulWidget {
  const EditProjectTab({super.key});

  @override
  State<EditProjectTab> createState() => _EditProjectTabState();
}

class _EditProjectTabState extends State<EditProjectTab> {
  final _titleFocusNode = FocusNode();
  final _authorFocusNode = FocusNode();

  late final TextEditingController _authorController;
  late final TextEditingController _titleController;
  late ProjectTemplate _template;

  @override
  void initState() {
    super.initState();
    final project = BlocProvider.of<ProjectCubit>(context).state.projectInfo;
    _authorController = TextEditingController(text: project?.author);
    _titleController = TextEditingController(text: project?.title);
    _template = project?.template ?? ProjectTemplate.book;
    _titleFocusNode.addListener(_save);
    _authorFocusNode.addListener(_save);
  }

  void _save() {
    final canSave = getIt<CommandDispatcher>().isCommandAvailable(
      PlotweaverCommand.save,
    );
    if (canSave) {
      getIt<CommandDispatcher>().sendIntent(PlotweaverCommand.save);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return FocusScope(
      canRequestFocus: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              const MacosIcon(CupertinoIcons.text_cursor),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.project_editor_title.tr(),
                style: PlotweaverTextStyles.fieldTitle,
              ),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: mq.size.width * 0.5,
            child: MacosTextField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              onChanged: (value) {
                BlocProvider.of<ProjectCubit>(context).editTitle(
                  value.trim(),
                );
              },
              maxLines: 1,
              placeholder: LocaleKeys.project_editor_title.tr(),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const MacosIcon(CupertinoIcons.person),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.project_editor_author.tr(),
                style: PlotweaverTextStyles.fieldTitle,
              ),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: mq.size.width * 0.5,
            child: MacosTextField(
              controller: _authorController,
              focusNode: _authorFocusNode,
              onChanged: (value) {
                BlocProvider.of<ProjectCubit>(context).editAuthor(
                  value.trim(),
                );
              },
              onEditingComplete: _save,
              onSubmitted: (_) => _save(),
              maxLines: 1,
              placeholder: LocaleKeys.project_editor_author.tr(),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const MacosIcon(
                CupertinoIcons.rectangle_fill_on_rectangle_angled_fill,
              ),
              const SizedBox(width: 8),
              Text(
                LocaleKeys.project_editor_template.tr(),
              ),
              const SizedBox(width: 30),
            ],
          ),
          const SizedBox(height: 10),
          MacosPopupButton<ProjectTemplate>(
            value: _template,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              BlocProvider.of<ProjectCubit>(context).editTemplate(value);
              setState(() {
                _template = value;
              });
              _save();
            },
            items: [
              MacosPopupMenuItem(
                value: ProjectTemplate.book,
                child: Text(
                  LocaleKeys.project_editor_book.tr(),
                ),
              ),
              MacosPopupMenuItem(
                value: ProjectTemplate.movie,
                child: Text(
                  LocaleKeys.project_editor_movie.tr(),
                ),
              ),
              MacosPopupMenuItem(
                value: ProjectTemplate.series,
                child: Text(
                  LocaleKeys.project_editor_series.tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
