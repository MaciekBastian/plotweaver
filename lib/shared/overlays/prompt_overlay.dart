import 'package:flutter/material.dart';

import '../../core/extensions/theme_extension.dart';

class PromptOverlay {
  const PromptOverlay({
    required this.context,
    required this.title,
    required this.onSubmit,
    this.message,
    this.onCancel,
    this.initialValue,
    this.validator,
  });

  final BuildContext context;
  final String title;
  final String? message;
  final void Function(String content) onSubmit;
  final VoidCallback? onCancel;
  final String? initialValue;
  final String? Function(String content)? validator;

  Future<void> show() async {
    final val = await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: _PromptOverlayWidget(
            onSubmit: onSubmit,
            title: title,
            message: message,
            initialValue: initialValue,
            validator: validator,
          ),
        );
      },
    );
    if (val == null && onCancel != null) {
      onCancel!.call();
    }
  }
}

class _PromptOverlayWidget extends StatefulWidget {
  const _PromptOverlayWidget({
    required this.title,
    required this.onSubmit,
    this.message,
    this.initialValue,
    this.validator,
  });

  final String title;
  final String? message;
  final String? initialValue;
  final void Function(String content) onSubmit;
  final String? Function(String content)? validator;

  @override
  State<_PromptOverlayWidget> createState() => __PromptOverlayWidgetState();
}

class __PromptOverlayWidgetState extends State<_PromptOverlayWidget> {
  final _focus = FocusNode();
  late final TextEditingController _textEditingController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
      text: widget.initialValue ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Column(
      children: [
        const SizedBox(height: 5),
        Container(
          width: size.width * 0.4,
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
                  onSubmitted: (value) {
                    if (widget.validator != null) {
                      final validator = widget.validator!(value);
                      if (validator != null) {
                        setState(() {
                          _errorMessage = validator;
                        });
                        _focus.requestFocus();
                        _textEditingController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset:
                              _textEditingController.value.text.length,
                        );
                        return;
                      }
                    }
                    widget.onSubmit(value);
                    Navigator.of(context).pop(true);
                  },
                  onTapOutside: (_) {
                    Navigator.of(context).pop();
                  },
                  onChanged: (value) {
                    if (widget.validator != null) {
                      final msg = widget.validator!(value);
                      if (_errorMessage != msg) {
                        setState(() {
                          _errorMessage = msg;
                        });
                      }
                    }
                  },
                  scrollPadding: EdgeInsets.zero,
                  decoration: InputDecoration(
                    filled: false,
                    border: InputBorder.none,
                    isDense: true,
                    hintText: widget.title,
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
              if (widget.message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: _errorMessage == null
                      ? Text(
                          widget.message!,
                          style: context.textStyle.caption,
                          textAlign: TextAlign.left,
                        )
                      : Text(
                          _errorMessage!,
                          style: context.textStyle.caption.copyWith(
                            color: context.colors.error,
                          ),
                          textAlign: TextAlign.left,
                        ),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: Text(
                    _errorMessage!,
                    style: context.textStyle.caption,
                    textAlign: TextAlign.left,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
