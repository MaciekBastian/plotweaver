import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/constants/colors.dart';
import '../../core/get_it/get_it.dart';
import '../../core/styles/text_styles.dart';
import '../../domain/fragments/models/act_model.dart';
import '../../domain/fragments/models/chapter_model.dart';
import '../../domain/fragments/models/episode_model.dart';
import '../../domain/fragments/models/fragment_model.dart';
import '../../domain/fragments/models/fragment_type.dart';
import '../../domain/fragments/models/part_model.dart';
import '../../domain/fragments/models/scene_model.dart';
import '../../generated/locale_keys.g.dart';
import '../../infrastructure/fragments/cubit/fragments_cubit.dart';
import '../../infrastructure/global/cubit/view_cubit.dart';
import 'widgets/chapter_editor.dart';
import 'widgets/scene_editor.dart';

class FragmentTab extends StatefulWidget {
  const FragmentTab({
    required this.fragmentId,
    super.key,
  });

  final String fragmentId;

  @override
  State<FragmentTab> createState() => _FragmentTabState();
}

class _FragmentTabState extends State<FragmentTab> {
  late final String _id;
  bool _error = false;
  late final FragmentType _type;
  late final TextEditingController _nameController;
  final _nameFocus = FocusNode();
  late final TextEditingController _outlineController;
  final _outlineFocus = FocusNode();
  late final TextEditingController _authorController;
  final _authorFocus = FocusNode();
  late final TextEditingController _directorController;
  final _directorFocus = FocusNode();
  late final TextEditingController _scriptWriterController;
  final _scriptWriterFocus = FocusNode();
  late int _number;
  late final List<ChapterModel> _chapters;
  late final List<SceneModel> _scenes;

  @override
  void initState() {
    super.initState();
    final fragment = BlocProvider.of<FragmentsCubit>(context).getFragment(
      widget.fragmentId,
    );
    if (fragment == null) {
      _error = true;
    }
    _id = fragment?.id ?? '';
    _type = fragment?.type ?? FragmentType.part;
    _nameController = TextEditingController(text: fragment?.name);
    _outlineController = TextEditingController(text: fragment?.outline);
    _authorController = TextEditingController(
      text: fragment is PartModel ? fragment.author : null,
    );
    _directorController = TextEditingController(
      text: fragment is EpisodeModel ? fragment.director : null,
    );
    _scriptWriterController = TextEditingController(
      text: fragment is EpisodeModel ? fragment.scriptWriter : null,
    );
    _number = fragment?.number ?? 1;
    _chapters = fragment is PartModel ? [...fragment.chapters] : [];
    _scenes = fragment is ActModel
        ? [...fragment.scenes]
        : fragment is EpisodeModel
            ? [...fragment.scenes]
            : [];

    _nameFocus.addListener(_save);
    _outlineFocus.addListener(_save);
    _authorFocus.addListener(_save);
    _directorFocus.addListener(_save);
    _scriptWriterFocus.addListener(_save);
  }

  void _save() {
    BlocProvider.of<FragmentsCubit>(context).save();
  }

  void _edit() {
    late final FragmentModel newModel;
    switch (_type) {
      case FragmentType.part:
        newModel = PartModel(
          id: _id,
          name: _nameController.text,
          number: _number,
          author: _authorController.text,
          outline: _outlineController.text,
          chapters: _chapters,
        );
        break;
      case FragmentType.act:
        newModel = ActModel(
          id: _id,
          name: _nameController.text,
          number: _number,
          outline: _outlineController.text,
          scenes: [],
        );
      case FragmentType.episode:
        newModel = EpisodeModel(
          id: _id,
          name: _nameController.text,
          number: _number,
          outline: _outlineController.text,
          director: _directorController.text,
          scriptWriter: _scriptWriterController.text,
          scenes: [],
        );
    }
    BlocProvider.of<FragmentsCubit>(context).editFragment(newModel);
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      // TODO: make better error note
      return const Center(
        child: MacosIcon(CupertinoIcons.exclamationmark_triangle),
      );
    }

    return FocusScope(
      canRequestFocus: true,
      child: ListView(
        children: [
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildLeftPane(),
              ),
              const SizedBox(width: 30),
              Expanded(
                flex: 2,
                child: _buildRightPane(),
              ),
              const SizedBox(width: 15),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            height: 1,
            color: getIt<AppColors>().dividerColor,
            margin: const EdgeInsets.only(right: 15),
          ),
          if (_type == FragmentType.part)
            ChapterEditor(
              onChapterDeleted: (chapterId) {
                BlocProvider.of<ViewCubit>(context).leavePreviewState();
                final newChapters = [..._chapters]
                  ..removeWhere((element) => element.id == chapterId);
                final indexed = newChapters.indexed.toList();
                for (final element in indexed) {
                  final removed = newChapters.removeAt(element.$1);
                  final copy = removed.copyWith(number: element.$1 + 1);
                  newChapters.insert(element.$1, copy);
                }
                setState(() {
                  _chapters
                    ..clear()
                    ..addAll(newChapters);
                });
                _edit();
              },
              onChapterEdited: (model) {
                _chapters
                  ..removeWhere((element) => element.id == model.id)
                  ..add(model);
                _edit();
              },
              onNewChapterAdded: (model) {
                BlocProvider.of<ViewCubit>(context).leavePreviewState();
                setState(() {
                  _chapters.add(model);
                });
                _edit();
              },
              partId: _id,
              chapters: _chapters..sort((a, b) => a.number.compareTo(b.number)),
            ),
          if (_type == FragmentType.act || _type == FragmentType.episode)
            SceneEditor(
              onSceneDeleted: (sceneId) {
                BlocProvider.of<ViewCubit>(context).leavePreviewState();
                final newScenes = [..._scenes]
                  ..removeWhere((element) => element.id == sceneId);
                final indexed = newScenes.indexed.toList();
                for (final element in indexed) {
                  final removed = newScenes.removeAt(element.$1);
                  final copy = removed.copyWith(number: element.$1 + 1);
                  newScenes.insert(element.$1, copy);
                }
                setState(() {
                  _scenes
                    ..clear()
                    ..addAll(newScenes);
                });
                _edit();
              },
              onSceneEdited: (model) {
                _scenes
                  ..removeWhere((element) => element.id == model.id)
                  ..add(model);
                _edit();
              },
              onNewSceneAdded: (model) {
                BlocProvider.of<ViewCubit>(context).leavePreviewState();
                setState(() {
                  _scenes.add(model);
                });
                _edit();
              },
              partId: _id,
              scenes: _scenes..sort((a, b) => a.number.compareTo(b.number)),
            ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Column _buildLeftPane() {
    final mq = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _type == FragmentType.part
              ? LocaleKeys.fragments_editor_part.tr()
              : _type == FragmentType.act
                  ? LocaleKeys.fragments_editor_act.tr()
                  : LocaleKeys.fragments_editor_episode.tr(),
          style: PlotweaverTextStyles.headline4,
        ),
        const SizedBox(height: 10),
        Text(
          _type == FragmentType.part
              ? LocaleKeys.fragments_editor_part_info.tr()
              : _type == FragmentType.act
                  ? LocaleKeys.fragments_editor_act_info.tr()
                  : LocaleKeys.fragments_editor_episode_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.text_cursor),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.fragments_editor_name.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: mq.size.width * 0.5,
          child: MacosTextField(
            controller: _nameController,
            focusNode: _nameFocus,
            onChanged: (value) {
              _edit();
              BlocProvider.of<ViewCubit>(context).leavePreviewState();
            },
            maxLines: 1,
            placeholder: LocaleKeys.fragments_editor_name.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.text_justifyleft),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.fragments_editor_outline.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _type == FragmentType.part
              ? LocaleKeys.fragments_editor_outline_info_part.tr()
              : _type == FragmentType.act
                  ? LocaleKeys.fragments_editor_outline_info_act.tr()
                  : LocaleKeys.fragments_editor_outline_info_episode.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: mq.size.width * 0.5,
          child: MacosTextField(
            controller: _outlineController,
            focusNode: _outlineFocus,
            onChanged: (value) {
              _edit();
              BlocProvider.of<ViewCubit>(context).leavePreviewState();
            },
            maxLines: 10,
            minLines: 5,
            placeholder: LocaleKeys.fragments_editor_outline.tr(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Column _buildRightPane() {
    final mq = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 83),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.number),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.fragments_editor_number.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.fragments_editor_number_info.tr(
            namedArgs: {
              'fragment_name': (_type == FragmentType.part
                      ? LocaleKeys.fragments_editor_part.tr()
                      : _type == FragmentType.act
                          ? LocaleKeys.fragments_editor_act.tr()
                          : LocaleKeys.fragments_editor_episode.tr())
                  .toLowerCase(),
            },
          ),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 10),
        BlocBuilder<FragmentsCubit, FragmentsState>(
          bloc: BlocProvider.of<FragmentsCubit>(context),
          builder: (context, state) {
            return MacosPopupButton<int>(
              value: _number,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                BlocProvider.of<FragmentsCubit>(context)
                    .changeFragmentNumber(_number, value);
                setState(() {
                  _number = value;
                });
                _save();
              },
              items: List.generate(
                state.fragments.length,
                (index) => MacosPopupMenuItem(
                  value: index + 1,
                  child: Text('${index + 1}.'),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
        if (_type == FragmentType.part)
          Column(
            children: [
              Row(
                children: [
                  const MacosIcon(CupertinoIcons.person),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.fragments_editor_author.tr(),
                    style: PlotweaverTextStyles.fieldTitle,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: mq.size.width * 0.5,
                child: MacosTextField(
                  controller: _authorController,
                  focusNode: _authorFocus,
                  onChanged: (value) {
                    _edit();
                    BlocProvider.of<ViewCubit>(context).leavePreviewState();
                  },
                  maxLines: 1,
                  placeholder: LocaleKeys.fragments_editor_author.tr(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        if (_type == FragmentType.episode)
          Column(
            children: [
              Row(
                children: [
                  const MacosIcon(CupertinoIcons.person_crop_rectangle),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.fragments_editor_director.tr(),
                    style: PlotweaverTextStyles.fieldTitle,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: mq.size.width * 0.5,
                child: MacosTextField(
                  controller: _directorController,
                  focusNode: _directorFocus,
                  onChanged: (value) {
                    _edit();
                    BlocProvider.of<ViewCubit>(context).leavePreviewState();
                  },
                  maxLines: 1,
                  placeholder: LocaleKeys.fragments_editor_director.tr(),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const MacosIcon(CupertinoIcons.pen),
                  const SizedBox(width: 8),
                  Text(
                    LocaleKeys.fragments_editor_script_writer.tr(),
                    style: PlotweaverTextStyles.fieldTitle,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: mq.size.width * 0.5,
                child: MacosTextField(
                  controller: _scriptWriterController,
                  focusNode: _scriptWriterFocus,
                  onChanged: (value) {
                    _edit();
                    BlocProvider.of<ViewCubit>(context).leavePreviewState();
                  },
                  maxLines: 1,
                  placeholder: LocaleKeys.fragments_editor_script_writer.tr(),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
      ],
    );
  }
}
