import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../../shared/widgets/fatal_error_widget.dart';
import '../../../../shared/widgets/text_property_widget.dart';
import '../../../tabs/presentation/cubit/tabs_cubit.dart';
import '../../domain/entities/project_entity.dart';
import '../bloc/project_info_editor/project_info_editor_bloc.dart';

class ProjectEditorTab extends StatefulWidget {
  const ProjectEditorTab({super.key});

  @override
  State<ProjectEditorTab> createState() => _ProjectEditorTabState();
}

class _ProjectEditorTabState extends State<ProjectEditorTab> {
  ProjectEntity? _project;
  final _projectNameController = TextEditingController();
  final _projectNameFocus = FocusNode();

  final _authorNameController = TextEditingController();
  final _authorNameFocus = FocusNode();

  final _descriptionNameController = TextEditingController();
  final _descriptionNameFocus = FocusNode();

  @override
  void initState() {
    _fillEditor(context.read<ProjectInfoEditorBloc>().state);
    super.initState();
  }

  void _fillEditor(ProjectInfoEditorState state) {
    state.maybeWhen(
      orElse: () {},
      success: (projectInfo) {
        _project = projectInfo;
        _projectNameController.text = projectInfo.title;
        _authorNameController.text = projectInfo.author ?? '';
        _descriptionNameController.text = projectInfo.description ?? '';
      },
      modified: (projectInfo) {
        _project = projectInfo;
        _projectNameController.text = projectInfo.title;
        _authorNameController.text = projectInfo.author ?? '';
        _descriptionNameController.text = projectInfo.description ?? '';
      },
    );
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
      listenWhen: (previous, current) =>
          previous.maybeWhen(
            orElse: () => false,
            failure: (_) => true,
            loading: () => true,
          ) &&
          current.maybeWhen(orElse: () => false, success: (_) => true),
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => Skeletonizer(
            enableSwitchAnimation: true,
            enabled: state.maybeWhen(
              orElse: () => false,
              loading: () => true,
            ),
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
                      child: Column(
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
                          const SizedBox(height: 15),
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
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.black,
                        height: 10,
                      ),
                    ),
                    // white space
                    Expanded(child: Container()),
                  ],
                ),
              ],
            ),
          ),
          failure: (error) {
            return Center(
              child: FatalErrorWidget(
                error: error,
                onRetry: () async {
                  context.read<ProjectInfoEditorBloc>().add(
                        const ProjectInfoEditorEvent.setup(),
                      );
                },
              ),
            );
          },
        );
      },
    );
  }
}
