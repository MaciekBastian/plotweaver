import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/images.dart';
import '../../core/get_it/get_it.dart';
import '../../core/styles/text_styles.dart';
import '../../domain/plots/models/plot_model.dart';
import '../../generated/locale_keys.g.dart';
import '../../infrastructure/characters/cubit/characters_cubit.dart';
import '../../infrastructure/plots/cubit/plots_cubit.dart';

class PlotTab extends StatefulWidget {
  const PlotTab({
    required this.plotId,
    super.key,
  });

  final String plotId;

  @override
  State<PlotTab> createState() => _PlotTabState();
}

class _PlotTabState extends State<PlotTab> {
  late final String _id;
  bool _error = false;
  late final TextEditingController _nameController;
  final _nameFocus = FocusNode();
  late final TextEditingController _descriptionController;
  final _descriptionFocus = FocusNode();
  late final TextEditingController _conflictController;
  final _conflictFocus = FocusNode();
  late final TextEditingController _resultController;
  final _resultFocus = FocusNode();
  late List<String> _charactersInvolved;
  late List<String> _subplots;
  String? _newCharacterId;
  String? _newSubplotId;

  @override
  void initState() {
    super.initState();
    final plot = BlocProvider.of<PlotsCubit>(context).getPlot(widget.plotId);
    if (plot == null) {
      _error = true;
    }
    _id = plot?.id ?? '';
    _nameController = TextEditingController(text: plot?.name);
    _descriptionController = TextEditingController(text: plot?.description);
    _conflictController = TextEditingController(text: plot?.conflict);
    _resultController = TextEditingController(text: plot?.result);
    _charactersInvolved = [...plot?.charactersInvolved ?? []];
    _subplots = [...plot?.subplots ?? []];

    _nameFocus.addListener(_save);
    _descriptionFocus.addListener(_save);
    _conflictFocus.addListener(_save);
    _resultFocus.addListener(_save);
  }

  void _save() {
    BlocProvider.of<PlotsCubit>(context).save();
  }

  void _edit() {
    final model = PlotModel(
      id: _id,
      name: _nameController.text,
      description: _descriptionController.text,
      conflict: _conflictController.text,
      result: _resultController.text,
      charactersInvolved: _charactersInvolved,
      subplots: _subplots,
    );
    BlocProvider.of<PlotsCubit>(context).editPlot(model);
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
              const SizedBox(width: 15),
              Expanded(
                flex: 2,
                child: _buildRightPane(),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftPane() {
    return Column(
      children: [
        Row(
          children: [
            const MacosIcon(CupertinoIcons.text_cursor),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.plots_editor_name.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: _nameController,
            focusNode: _nameFocus,
            onChanged: (value) {
              _edit();
            },
            maxLines: 1,
            placeholder: LocaleKeys.plots_editor_name.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.text_alignleft),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.plots_editor_description.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.plots_editor_description_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: MacosTextField(
            controller: _descriptionController,
            focusNode: _descriptionFocus,
            onChanged: (value) {
              _edit();
            },
            minLines: 5,
            maxLines: 15,
            placeholder: LocaleKeys.plots_editor_description.tr(),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        PlotweaverImages.swordsIcon,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          CupertinoColors.activeBlue,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.plots_editor_conflict.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    LocaleKeys.plots_editor_conflict_info.tr(),
                    style: PlotweaverTextStyles.body.copyWith(
                      color: getIt<AppColors>().textGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: MacosTextField(
                      controller: _conflictController,
                      focusNode: _conflictFocus,
                      onChanged: (value) {
                        _edit();
                      },
                      minLines: 5,
                      maxLines: 15,
                      placeholder: LocaleKeys.plots_editor_conflict.tr(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        PlotweaverImages.tacticIcon,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          CupertinoColors.activeBlue,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        LocaleKeys.plots_editor_result.tr(),
                        style: PlotweaverTextStyles.fieldTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    LocaleKeys.plots_editor_result_info.tr(),
                    style: PlotweaverTextStyles.body.copyWith(
                      color: getIt<AppColors>().textGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: MacosTextField(
                      controller: _resultController,
                      focusNode: _resultFocus,
                      onChanged: (value) {
                        _edit();
                      },
                      minLines: 5,
                      maxLines: 15,
                      placeholder: LocaleKeys.plots_editor_result.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildRightPane() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const MacosIcon(CupertinoIcons.person_3),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.plots_editor_characters_involved.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.plots_editor_characters_involved_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
        ),
        const SizedBox(height: 5),
        BlocBuilder<CharactersCubit, CharactersState>(
          builder: (context, state) {
            final characters = [...state.characters]..sort(
                (a, b) => a.name.compareTo(b.name),
              );

            return Column(
              children: [
                ..._charactersInvolved.map((e) {
                  final character = BlocProvider.of<CharactersCubit>(
                    context,
                  ).getCharacter(e);

                  if (character == null) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      _charactersInvolved.remove(e);
                    });
                    return Container();
                  }
                  return Container(
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: getIt<AppColors>().dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            character.name,
                            style: PlotweaverTextStyles.body,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                        const SizedBox(width: 15),
                        PushButton(
                          controlSize: ControlSize.regular,
                          secondary: true,
                          onPressed: () {
                            _charactersInvolved.remove(e);
                            _edit();
                            _save();
                            setState(() {});
                          },
                          child: Text(LocaleKeys.plots_editor_remove.tr()),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (_charactersInvolved.length < characters.length)
                  SizedBox(
                    height: 25,
                    child: Row(
                      children: [
                        Expanded(
                          child: MacosPopupButton<String>(
                            value: _newCharacterId ?? '',
                            onChanged: (value) {
                              setState(() {
                                _newCharacterId = value;
                              });
                            },
                            items: [
                              MacosPopupMenuItem(
                                value: '',
                                child: Text(
                                  '- ${LocaleKeys.plots_editor_select_character.tr()} -',
                                ),
                              ),
                              ...characters.where((el) {
                                return !_charactersInvolved.contains(el.id);
                              }).map(
                                (e) {
                                  return MacosPopupMenuItem(
                                    value: e.id,
                                    child: Text(e.name),
                                  );
                                },
                              ).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        PushButton(
                          controlSize: ControlSize.regular,
                          onPressed: () {
                            if (_newCharacterId == null ||
                                _newCharacterId == '') {
                              return;
                            }
                            if (_charactersInvolved.contains(_newCharacterId)) {
                              return;
                            }
                            _charactersInvolved.add(_newCharacterId!);
                            _edit();
                            _save();
                            setState(() {
                              _newCharacterId = null;
                            });
                          },
                          child: Text(LocaleKeys.plots_editor_add.tr()),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const MacosIcon(CupertinoIcons.list_bullet_indent),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.plots_editor_subplots.tr(),
              style: PlotweaverTextStyles.fieldTitle,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          LocaleKeys.plots_editor_subplots_info.tr(),
          style: PlotweaverTextStyles.body.copyWith(
            color: getIt<AppColors>().textGrey,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 5),
        BlocBuilder<PlotsCubit, PlotsState>(
          builder: (context, state) {
            final plots = [...state.plots].where((el) {
              final con1 = !_subplots.contains(el.id);
              final con2 = el.id != _id;
              final con3 = !el.subplots.contains(_id);

              return con1 && con2 && con3;
            }).toList()
              ..sort((a, b) => a.name.compareTo(b.name));

            return Column(
              children: [
                ..._subplots.map((e) {
                  final subplot = BlocProvider.of<PlotsCubit>(
                    context,
                  ).getPlot(e);

                  if (subplot == null) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      _subplots.remove(e);
                    });
                    return Container();
                  }
                  return Container(
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: getIt<AppColors>().dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            subplot.name,
                            style: PlotweaverTextStyles.body,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                        const SizedBox(width: 15),
                        PushButton(
                          controlSize: ControlSize.regular,
                          secondary: true,
                          onPressed: () {
                            _subplots.remove(e);
                            _edit();
                            _save();
                            setState(() {});
                          },
                          child: Text(LocaleKeys.plots_editor_remove.tr()),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (plots.isNotEmpty)
                  SizedBox(
                    height: 25,
                    child: Row(
                      children: [
                        Expanded(
                          child: MacosPopupButton<String>(
                            value: _newSubplotId ?? '',
                            onChanged: (value) {
                              setState(() {
                                _newSubplotId = value;
                              });
                            },
                            items: [
                              MacosPopupMenuItem(
                                value: '',
                                child: Text(
                                  '- ${LocaleKeys.plots_editor_select_subplot.tr()} -',
                                ),
                              ),
                              ...plots.map(
                                (e) {
                                  return MacosPopupMenuItem(
                                    value: e.id,
                                    child: Text(e.name),
                                  );
                                },
                              ).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        PushButton(
                          controlSize: ControlSize.regular,
                          onPressed: () {
                            if (_newSubplotId == null || _newSubplotId == '') {
                              return;
                            }
                            if (_subplots.contains(_newSubplotId)) {
                              return;
                            }
                            if (_newSubplotId == _id) {
                              return;
                            }
                            _subplots.add(_newSubplotId!);
                            _edit();
                            _save();
                            setState(() {
                              _newSubplotId = null;
                            });
                          },
                          child: Text(LocaleKeys.plots_editor_add.tr()),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
