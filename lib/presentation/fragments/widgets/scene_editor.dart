import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Material, Colors, InkWell;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../../core/constants/colors.dart';
import '../../../core/get_it/get_it.dart';
import '../../../core/styles/text_styles.dart';
import '../../../domain/fragments/models/act_model.dart';
import '../../../domain/fragments/models/episode_model.dart';
import '../../../domain/fragments/models/scene_location.dart';
import '../../../domain/fragments/models/scene_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../infrastructure/fragments/cubit/fragments_cubit.dart';
import '../../../infrastructure/global/cubit/view_cubit.dart';
import '../../home/widgets/app_logo_widget.dart';

class SceneEditor extends StatelessWidget {
  const SceneEditor({
    required this.onSceneDeleted,
    required this.onSceneEdited,
    required this.onNewSceneAdded,
    required this.partId,
    required this.scenes,
    super.key,
  });

  final String partId;
  final List<SceneModel> scenes;
  final void Function(SceneModel model) onNewSceneAdded;
  final void Function(SceneModel model) onSceneEdited;
  final void Function(String sceneId) onSceneDeleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.film),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.fragments_editor_scenes.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          LocaleKeys.fragments_editor_scenes_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        if (scenes.isEmpty)
          Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: PushButton(
                  controlSize: ControlSize.large,
                  onPressed: () {
                    final scene = BlocProvider.of<FragmentsCubit>(context)
                        .getNewScene(scenes.length + 1);
                    onNewSceneAdded(scene);
                  },
                  child: Text(LocaleKeys.commands_add.tr()),
                ),
              ),
            ],
          ),
        ...List.generate(scenes.length, (index) {
          final scene = scenes[index];
          return _SceneTile(
            key: Key('scene_editor_${scene.id}'),
            partId: partId,
            scene: scene,
            onSceneAdded: onNewSceneAdded,
            onSceneDeleted: onSceneDeleted,
            onSceneEdited: onSceneEdited,
            isLast: index == scenes.length - 1,
          );
        }),
      ],
    );
  }
}

class _SceneTile extends StatefulWidget {
  const _SceneTile({
    required this.partId,
    required this.scene,
    required this.isLast,
    required this.onSceneAdded,
    required this.onSceneDeleted,
    required this.onSceneEdited,
    super.key,
  });

  final SceneModel scene;
  final String partId;
  final bool isLast;
  final void Function(SceneModel model) onSceneAdded;
  final void Function(SceneModel model) onSceneEdited;
  final void Function(String id) onSceneDeleted;

  @override
  State<_SceneTile> createState() => __SceneTileState();
}

class __SceneTileState extends State<_SceneTile> {
  bool _isExpanded = false;
  late final TextEditingController _settingController;
  final _settingFocus = FocusNode();
  late final TextEditingController _outlineController;
  final _outlineFocus = FocusNode();
  late final TextEditingController _timeOfDayController;
  final _timeOfDayFocus = FocusNode();
  late final TextEditingController _cameraNotesController;
  final _cameraNotesFocus = FocusNode();
  late SceneLocation _location;

  @override
  void initState() {
    super.initState();
    _settingController = TextEditingController(text: widget.scene.setting);
    _outlineController = TextEditingController(text: widget.scene.outline);
    _timeOfDayController = TextEditingController(text: widget.scene.timeOfDay);
    _cameraNotesController = TextEditingController(
      text: widget.scene.cameraNotes,
    );
    _location = widget.scene.location;

    _settingFocus.addListener(_save);
    _outlineFocus.addListener(_save);
    _timeOfDayFocus.addListener(_save);
    _cameraNotesFocus.addListener(_save);
  }

  void _save() {
    BlocProvider.of<FragmentsCubit>(context).save();
  }

  void _edit() {
    BlocProvider.of<ViewCubit>(context).leavePreviewState();
    widget.onSceneEdited(
      SceneModel(
        id: widget.scene.id,
        setting: _settingController.text,
        number: widget.scene.number,
        outline: _outlineController.text,
        cameraNotes: _cameraNotesController.text,
        location: _location,
        timeOfDay: _timeOfDayController.text,
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
          title: Text(LocaleKeys.alerts_scene_delete.tr()),
          message: Text(
            LocaleKeys.alerts_scene_delete_data_loss.tr(),
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
              widget.onSceneDeleted(widget.scene.id);
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
                      final fragment = state.openedFragments
                          .where((element) => element.id == widget.partId)
                          .firstOrNull;
                      late final SceneModel? scene;

                      if (fragment is ActModel) {
                        scene = fragment.scenes
                            .where((element) => element.id == widget.scene.id)
                            .firstOrNull;
                      } else if (fragment is EpisodeModel) {
                        scene = fragment.scenes
                            .where((element) => element.id == widget.scene.id)
                            .firstOrNull;
                      } else {
                        scene = null;
                      }

                      return Expanded(
                        child: Text(
                          '${scene?.location.readable ?? _location.readable} ${scene?.setting ?? _settingController.text} — ${scene?.timeOfDay ?? _timeOfDayController.text}'
                              .toUpperCase(),
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
                          final scene = BlocProvider.of<FragmentsCubit>(context)
                              .getNewScene(widget.scene.number + 1);
                          widget.onSceneAdded(scene);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      key: UniqueKey(),
      children: [
        Row(
          children: [
            const MacosIcon(Icons.wb_incandescent_rounded),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.fragments_editor_location.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        MacosPopupButton<SceneLocation>(
          value: _location,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _location = value;
              });
            }
          },
          items: [
            MacosPopupMenuItem(
              value: SceneLocation.interior,
              child: Text(LocaleKeys.fragments_editor_interior.tr()),
            ),
            MacosPopupMenuItem(
              value: SceneLocation.exterior,
              child: Text(LocaleKeys.fragments_editor_exterior.tr()),
            ),
            MacosPopupMenuItem(
              value: SceneLocation.interiorToExterior,
              child: Text(
                LocaleKeys.fragments_editor_interior_to_exterior.tr(),
              ),
            ),
            MacosPopupMenuItem(
              value: SceneLocation.exteriorToInterior,
              child: Text(
                LocaleKeys.fragments_editor_exterior_to_interior.tr(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.placemark),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.fragments_editor_setting.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: mq.size.width * 0.5,
                    child: MacosTextField(
                      controller: _settingController,
                      focusNode: _settingFocus,
                      onChanged: (value) {
                        _edit();
                      },
                      maxLines: 1,
                      placeholder: LocaleKeys.fragments_editor_setting.tr(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const MacosIcon(CupertinoIcons.time_solid),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.fragments_editor_time_of_day.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: mq.size.width * 0.5,
                    child: MacosTextField(
                      controller: _timeOfDayController,
                      focusNode: _timeOfDayFocus,
                      onChanged: (value) {
                        _edit();
                      },
                      maxLines: 1,
                      placeholder: LocaleKeys.fragments_editor_time_of_day.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                      const MacosIcon(CupertinoIcons.video_camera),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.fragments_editor_camera_notes.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: MacosTextField(
                      controller: _cameraNotesController,
                      focusNode: _cameraNotesFocus,
                      onChanged: (value) {
                        _edit();
                      },
                      maxLines: 10,
                      minLines: 5,
                      placeholder:
                          LocaleKeys.fragments_editor_camera_notes.tr(),
                    ),
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
