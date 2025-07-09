import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/fatal_error_widget.dart';
import '../../../../shared/widgets/property_header_widget.dart';
import '../../../../shared/widgets/text_property_widget.dart';
import '../../../editor/presentation/screens/editor_screen.dart';
import '../../../tabs/presentation/cubit/tabs_cubit.dart';
import '../../../weave_file/domain/entities/general_entity.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/enums/project_enums.dart';
import '../bloc/project_info_editor/project_info_editor_bloc.dart';
import '../widgets/general_file_info_widget.dart';
import '../widgets/project_status_selector_widget.dart';
import '../widgets/project_template_selector_widget.dart';

class ProjectEditorTab extends StatefulWidget {
  const ProjectEditorTab({super.key});

  @override
  State<ProjectEditorTab> createState() => _ProjectEditorTabState();
}

class _ProjectEditorTabState extends State<ProjectEditorTab> {
  ProjectEntity? _project;
  GeneralEntity? _general;

  final _projectNameController = TextEditingController();
  final _projectNameFocus = FocusNode();

  final _authorNameController = TextEditingController();
  final _authorNameFocus = FocusNode();

  final _descriptionNameController = TextEditingController();
  final _descriptionNameFocus = FocusNode();

  ProjectTemplate _template = ProjectTemplate.book;
  ProjectStatus _status = ProjectStatus.idle;

  @override
  void initState() {
    _fillEditor(context.read<ProjectInfoEditorBloc>().state);
    super.initState();
  }

  @override
  void dispose() {
    _authorNameController.dispose();
    _projectNameController.dispose();
    _descriptionNameController.dispose();
    _authorNameFocus.dispose();
    _projectNameFocus.dispose();
    _descriptionNameFocus.dispose();
    super.dispose();
  }

  void _fillEditor(ProjectInfoEditorState state) {
    switch (state) {
      case ProjectInfoEditorStateSuccess(
          :final generalInfo,
          :final projectInfo,
        ):
        _project = projectInfo;
        _general = generalInfo;
        break;
      case ProjectInfoEditorStateModified(
          :final generalInfo,
          :final projectInfo,
        ):
        _project = projectInfo;
        _general = generalInfo;
        break;
      default:
        break;
    }

    if (_project != null) {
      _projectNameController.text = _project!.title;
      _authorNameController.text = _project!.author ?? '';
      _descriptionNameController.text = _project!.description ?? '';
      _template = _project!.template;
      _status = _project!.status;
    }
  }

  void _sendModifyEvent() {
    final tabId = context.read<TabsCubit>().state.openedTabId;
    if (_project == null || tabId == null) {
      return;
    }
    final newProject = _project!.copyWith(
      author: _authorNameController.text.trim(),
      description: _descriptionNameController.text.trim(),
      title: _projectNameController.text.trim(),
      template: _template,
      status: _status,
    );
    _project = newProject;
    context.read<ProjectInfoEditorBloc>().add(
          ProjectInfoEditorEvent.modify(
            newProject,
            tabId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectInfoEditorBloc, ProjectInfoEditorState>(
      listener: (context, state) {
        _fillEditor(state);
      },
      listenWhen: (previous, current) {
        final previousCheck = switch (previous) {
          ProjectInfoEditorStateLoading() => true,
          ProjectInfoEditorStateFailure() => true,
          _ => false,
        };
        final currentCheck = switch (previous) {
          ProjectInfoEditorStateSuccess() => true,
          _ => false,
        };
        return previousCheck && currentCheck;
      },
      builder: (context, state) {
        return switch (state) {
          ProjectInfoEditorStateFailure(:final error) => Center(
              child: FatalErrorWidget(
                error: error,
                onRetry: () async {
                  context.read<ProjectInfoEditorBloc>().add(
                        const ProjectInfoEditorEvent.setup(),
                      );
                },
              ),
            ),
          _ => Skeletonizer(
              enableSwitchAnimation: true,
              enabled: switch (state) {
                ProjectInfoEditorStateLoading() => true,
                _ => false,
              },
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                children: [
                  TextField(
                    focusNode: _projectNameFocus,
                    controller: _projectNameController,
                    style: context.textStyle.h1,
                    onChanged: (value) {
                      _sendModifyEvent();
                    },
                    onTapOutside: (event) {
                      editorFocusNode.requestFocus();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.transparent,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          width: 3,
                          color: context.colors.link,
                        ),
                      ),
                      hintText: S.of(context).start_typing,
                    ),
                  ),
                  Divider(color: context.colors.dividerColor),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildLeftPane(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: _buildRightPane(),
                      ),
                      // white space
                      Expanded(child: Container()),
                    ],
                  ),
                ],
              ),
            ),
        };
      },
    );
  }

  Column _buildRightPane() {
    return Column(
      children: [
        ProjectTemplateSelectorWidget(
          selected: _template,
          onSelected: (selected) {
            if (_template == selected) {
              return;
            }
            setState(() {
              _template = selected;
            });
            _sendModifyEvent();
          },
        ),
        const SizedBox(height: 30),
        ProjectStatusSelectorWidget(
          selected: _status,
          onSelection: (selected) {
            if (selected != _status) {
              setState(() {
                _status = selected;
              });
              _sendModifyEvent();
            }
          },
        ),
        const SizedBox(height: 30),
        PropertyHeaderWidget(
          icon: const Icon(Icons.info_outline),
          title: S.of(context).weave_file_info,
          description: S.of(context).weave_file_info_hint,
        ),
        const SizedBox(height: 10),
        if (_general != null) GeneralFileInfoWidget(general: _general!),
      ],
    );
  }

  Column _buildLeftPane() {
    return Column(
      children: [
        TextPropertyWidget(
          icon: const Icon(Icons.person_rounded),
          controller: _authorNameController,
          focusNode: _authorNameFocus,
          title: S.of(context).project_author,
          description: S.of(context).project_author_hint,
          onChange: _sendModifyEvent,
          hint: S.of(context).start_typing,
          maxLines: 1,
        ),
        const SizedBox(height: 30),
        TextPropertyWidget(
          icon: const Icon(Icons.format_align_left),
          controller: _descriptionNameController,
          focusNode: _descriptionNameFocus,
          title: S.of(context).project_description,
          description: S.of(context).project_description_hint,
          onChange: _sendModifyEvent,
          hint: S.of(context).start_typing,
          maxLines: 20,
          minLines: 4,
        ),
      ],
    );
  }
}
