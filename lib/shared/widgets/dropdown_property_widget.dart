import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../core/extensions/theme_extension.dart';
import 'clickable_widget.dart';
import 'property_header_widget.dart';

class DropdownElement<T> {
  const DropdownElement({
    required this.title,
    required this.value,
    this.available = true,
    this.description,
    this.leading,
  });

  final String title;
  final String? description;
  final T value;
  final bool available;
  final Widget? leading;
}

class DropdownPropertyWidget<T extends Object> extends StatefulWidget {
  const DropdownPropertyWidget({
    required this.onSelected,
    required this.icon,
    required this.title,
    required this.values,
    this.description,
    this.allowEmpty = false,
    this.selected,
    this.selectedBuilder,
    super.key,
  }) : assert(
          !allowEmpty && selected != null,
          'Selected must not be null when `allowEmpty` is false',
        );

  final Widget icon;
  final T? selected;
  final String title;
  final String? description;
  final List<DropdownElement<T>> values;
  final bool allowEmpty;
  final void Function(T selected) onSelected;
  final Widget Function(BuildContext context, DropdownElement? element)?
      selectedBuilder;

  @override
  State<DropdownPropertyWidget<T>> createState() =>
      _DropdownPropertyWidgetState<T>();
}

class _DropdownPropertyWidgetState<T extends Object>
    extends State<DropdownPropertyWidget<T>> {
  final _key = GlobalKey();
  final _controller = OverlayPortalController();
  final _dropdownFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final selectedElement =
        widget.values.where((el) => el.value == widget.selected).firstOrNull;

    return Column(
      children: [
        PropertyHeaderWidget(
          description: widget.description,
          icon: widget.icon,
          title: widget.title,
        ),
        const SizedBox(height: 10),
        Container(
          key: _key,
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: context.colors.scaffoldBackgroundColor,
            border: Border.all(
              color: context.colors.dividerColor,
              width: 2,
            ),
          ),
          child: OverlayPortal(
            controller: _controller,
            overlayChildBuilder: (context) {
              final box = _key.currentContext?.findRenderObject() as RenderBox?;
              final position = box?.localToGlobal(Offset.zero);
              _dropdownFocus.requestFocus();
              return _buildOverlay(position, box, context);
            },
            child: ClickableWidget(
              onTap: _controller.toggle,
              child: widget.selectedBuilder != null
                  ? widget.selectedBuilder!(
                      context,
                      selectedElement,
                    )
                  : Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        selectedElement?.title ?? widget.title,
                        style: widget.selected == null
                            ? context.textStyle.caption
                                .copyWith(color: context.colors.dividerColor)
                            : context.textStyle.body,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlay(Offset? position, RenderBox? box, BuildContext context) {
    return Focus(
      onKeyEvent: (_, value) {
        if (value.logicalKey == LogicalKeyboardKey.escape) {
          _controller.hide();
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      focusNode: _dropdownFocus,
      autofocus: true,
      descendantsAreFocusable: true,
      descendantsAreTraversable: true,
      child: Stack(
        children: [
          ModalBarrier(
            onDismiss: _controller.hide,
          ),
          Positioned(
            left: position?.dx,
            top: (position?.dy ?? 0) + 32,
            child: Container(
              width: box?.size.width,
              decoration: BoxDecoration(
                color: context.colors.dividerColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30,
                    blurStyle: context.colors.overlaysBoxShadow.blurStyle,
                    color: context.colors.overlaysBoxShadow.color,
                    spreadRadius: -10,
                    offset: const Offset(0, 25),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    color: context.colors.scaffoldBackgroundColor,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 5,
                  ),
                  const SizedBox(height: 10),
                  ...widget.values.map((val) {
                    return Focus(
                      child: _buildDropdownItem(val, context),
                    );
                  }),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(DropdownElement<T> val, BuildContext context) {
    return ClickableWidget(
      borderRadius: BorderRadius.circular(8),
      onTap: val.available
          ? () {
              widget.onSelected(val.value);
              _controller.hide();
            }
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (val.leading != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: val.leading,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Text(
                  val.title,
                  style: context.textStyle.body.copyWith(
                    color: val.available
                        ? context.colors.onScaffoldBackgroundHeader
                        : context.colors.disabled,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                const SizedBox(height: 3),
                if (val.description != null)
                  Column(
                    children: [
                      Text(
                        val.description!,
                        style: context.textStyle.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      const SizedBox(height: 3),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
