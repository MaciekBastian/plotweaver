import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Material, Colors, InkWell;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../core/constants/colors.dart';
import '../../../core/get_it/get_it.dart';
import '../../../core/styles/text_styles.dart';
import '../../../domain/fragments/models/chapter_model.dart';
import '../../../domain/fragments/models/part_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../infrastructure/characters/cubit/characters_cubit.dart';
import '../../../infrastructure/fragments/cubit/fragments_cubit.dart';
import '../../../infrastructure/global/cubit/view_cubit.dart';
import '../../home/widgets/app_logo_widget.dart';

class ChapterEditor extends StatelessWidget {
  const ChapterEditor({
    required this.onChapterDeleted,
    required this.onChapterEdited,
    required this.onNewChapterAdded,
    required this.partId,
    required this.chapters,
    super.key,
  });

  final String partId;
  final List<ChapterModel> chapters;
  final void Function(ChapterModel model) onNewChapterAdded;
  final void Function(ChapterModel model) onChapterEdited;
  final void Function(String chapterId) onChapterDeleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.book),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.fragments_editor_chapters.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          LocaleKeys.fragments_editor_chapters_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        if (chapters.isEmpty)
          Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: PushButton(
                  controlSize: ControlSize.large,
                  onPressed: () {
                    final chapter = BlocProvider.of<FragmentsCubit>(context)
                        .getNewChapter(chapters.length + 1);
                    onNewChapterAdded(chapter);
                  },
                  child: Text(LocaleKeys.commands_add.tr()),
                ),
              ),
            ],
          ),
        ...List.generate(chapters.length, (index) {
          final chapter = chapters[index];
          return _ChapterTile(
            key: Key('chapter_editor_${chapter.id}'),
            partId: partId,
            chapter: chapter,
            onChapterAdded: onNewChapterAdded,
            onChapterDeleted: onChapterDeleted,
            onChapterEdited: onChapterEdited,
            isLast: index == chapters.length - 1,
          );
        }),
      ],
    );
  }
}

class _ChapterTile extends StatefulWidget {
  const _ChapterTile({
    required this.partId,
    required this.chapter,
    required this.isLast,
    required this.onChapterAdded,
    required this.onChapterDeleted,
    required this.onChapterEdited,
    super.key,
  });

  final ChapterModel chapter;
  final String partId;
  final bool isLast;
  final void Function(ChapterModel model) onChapterAdded;
  final void Function(ChapterModel model) onChapterEdited;
  final void Function(String id) onChapterDeleted;

  @override
  State<_ChapterTile> createState() => __ChapterTileState();
}

class __ChapterTileState extends State<_ChapterTile> {
  bool _isExpanded = false;
  late final TextEditingController _titleController;
  final _titleFocus = FocusNode();
  late final TextEditingController _outlineController;
  final _outlineFocus = FocusNode();
  late final TextEditingController _timeOfActionController;
  final _timeOfActionFocus = FocusNode();
  String? _narrationCharacterId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.chapter.title);
    _outlineController = TextEditingController(text: widget.chapter.outline);
    _timeOfActionController = TextEditingController(
      text: widget.chapter.timeOfAction,
    );
    final character = BlocProvider.of<CharactersCubit>(context)
        .state
        .characters
        .where((element) => element.id == widget.chapter.narrationCharacterId)
        .firstOrNull;
    _narrationCharacterId = character?.id;

    _titleFocus.addListener(_save);
    _outlineFocus.addListener(_save);
    _timeOfActionFocus.addListener(_save);
  }

  void _save() {
    BlocProvider.of<FragmentsCubit>(context).save();
  }

  void _edit() {
    widget.onChapterEdited(
      ChapterModel(
        id: widget.chapter.id,
        title: _titleController.text,
        number: widget.chapter.number,
        narrationCharacterId: (_narrationCharacterId?.isEmpty ?? true)
            ? null
            : _narrationCharacterId,
        outline: _outlineController.text,
        timeOfAction: _timeOfActionController.text,
      ),
    );
  }

  void _delete() {
    showMacosAlertDialog(
      context: context,
      builder: (context) {
        return MacosAlertDialog(
          appIcon: const AppLogoWidget(
            width: 64,
            height: 64,
          ),
          title: Text(LocaleKeys.alerts_chapter_delete.tr()),
          message: Text(
            LocaleKeys.alerts_chapter_delete_data_loss.tr(),
            style: PlotweaverTextStyles.body,
          ),
          secondaryButton: PushButton(
            controlSize: ControlSize.large,
            secondary: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(LocaleKeys.alerts_cancel.tr()),
          ),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            onPressed: () {
              Navigator.of(context).pop();
              widget.onChapterDeleted(widget.chapter.id);
            },
            child: Text(LocaleKeys.alerts_delete.tr()),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<FragmentsCubit, FragmentsState>(
                    bloc: BlocProvider.of<FragmentsCubit>(context),
                    builder: (context, state) {
                      final chapter = state.openedFragments
                          .where((element) => element.id == widget.partId)
                          .whereType<PartModel>()
                          .firstOrNull
                          ?.chapters
                          .where((element) => element.id == widget.chapter.id)
                          .firstOrNull;

                      return Expanded(
                        child: Text(
                          chapter?.title ?? widget.chapter.title,
                          style: PlotweaverTextStyles.headline6,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                      );
                    },
                  ),
                  MacosIconButton(
                    icon: Icon(
                      _isExpanded
                          ? CupertinoIcons.rectangle_compress_vertical
                          : CupertinoIcons.rectangle_expand_vertical,
                    ),
                    onPressed: () {
                      _save();
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.decelerate,
                child: _isExpanded
                    ? _buildExpandedPanel()
                    : const SizedBox.shrink(),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(right: 15),
                height: 1,
                color: getIt<AppColors>().dividerColor,
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: _delete,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MacosIcon(
                          CupertinoIcons.trash_circle,
                          color: getIt<AppColors>().textGrey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          LocaleKeys.commands_delete.tr(),
                          style: PlotweaverTextStyles.body.copyWith(
                            color: getIt<AppColors>().textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.isLast)
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          final chapter =
                              BlocProvider.of<FragmentsCubit>(context)
                                  .getNewChapter(widget.chapter.number + 1);
                          widget.onChapterAdded(chapter);
                        },
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MacosIcon(
                                CupertinoIcons.add_circled,
                                color: getIt<AppColors>().textGrey,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                LocaleKeys.commands_add.tr(),
                                style: PlotweaverTextStyles.body.copyWith(
                                  color: getIt<AppColors>().textGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Column _buildExpandedPanel() {
    final mq = MediaQuery.of(context);
    return Column(
      key: UniqueKey(),
      children: [
        Row(
          children: [
            const MacosIcon(CupertinoIcons.text_cursor),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.fragments_editor_title.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: mq.size.width * 0.5,
          child: MacosTextField(
            controller: _titleController,
            focusNode: _titleFocus,
            onChanged: (value) {
              _edit();
              BlocProvider.of<ViewCubit>(context).leavePreviewState();
            },
            maxLines: 1,
            placeholder: LocaleKeys.fragments_editor_title.tr(),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(
                    width: double.infinity,
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
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.time_solid),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.fragments_editor_time_of_action.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: MacosTextField(
                      controller: _timeOfActionController,
                      focusNode: _timeOfActionFocus,
                      onChanged: (value) {
                        _edit();
                        BlocProvider.of<ViewCubit>(context).leavePreviewState();
                      },
                      maxLines: 1,
                      placeholder:
                          LocaleKeys.fragments_editor_time_of_action.tr(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const MacosIcon(Icons.record_voice_over_rounded),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.fragments_editor_narration.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<CharactersCubit, CharactersState>(
                    bloc: BlocProvider.of<CharactersCubit>(context),
                    builder: (context, state) {
                      return MacosPopupButton(
                        value: _narrationCharacterId ?? '',
                        onChanged: (value) {
                          setState(() {
                            _narrationCharacterId = value;
                          });
                          _edit();
                          _save();
                        },
                        items: [
                          MacosPopupMenuItem(
                            value: '',
                            child: Text(
                              '- ${LocaleKeys.fragments_editor_select_character.tr()} -',
                            ),
                          ),
                          ...state.characters.map((e) {
                            return MacosPopupMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
