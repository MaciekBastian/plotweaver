import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/theme_extension.dart';
import '../../../generated/l10n.dart';
import 'bloc/search_commands_bloc.dart';

class SearchCommandOverlay extends StatefulWidget {
  const SearchCommandOverlay({super.key});

  @override
  State<SearchCommandOverlay> createState() => _SearchCommandOverlayState();
}

class _SearchCommandOverlayState extends State<SearchCommandOverlay> {
  final _focus = FocusNode();
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return BlocBuilder<SearchCommandsBloc, SearchCommandsState>(
      builder: (context, state) {
        final containerSize = 45.0 +
            (state.suggestions.isEmpty ? 20 : state.suggestions.length * 25);
        return Column(
          children: [
            const SizedBox(height: 5),
            Container(
              width: size.width * 0.4,
              height: containerSize > size.height * 0.5
                  ? size.height * 0.5
                  : containerSize,
              decoration: BoxDecoration(
                color: context.colors.dividerColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  context.colors.overlaysBoxShadow,
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.colors.textFieldBackgroundColor,
                    ),
                    child: TextField(
                      autofocus: true,
                      focusNode: _focus,
                      selectionControls: DesktopTextSelectionControls(),
                      controller: _textEditingController,
                      style: context.textStyle.body,
                      onTapOutside: (_) {
                        Navigator.of(context).pop();
                      },
                      onChanged: (value) {
                        //
                      },
                      scrollPadding: EdgeInsets.zero,
                      decoration: InputDecoration(
                        filled: false,
                        border: InputBorder.none,
                        isDense: true,
                        hintText: S.of(context).search_for_command_or_file,
                        contentPadding: const EdgeInsets.only(
                          left: 10,
                          top: 10,
                          bottom: 10,
                        ),
                        hintStyle: context.textStyle.body.copyWith(
                          color: context.colors.disabled,
                        ),
                      ),
                    ),
                  ),
                  // TODO: fire commands
                  if (state.suggestions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        S.of(context).no_matching_commands,
                        style: context.textStyle.caption,
                        textAlign: TextAlign.left,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
