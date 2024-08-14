import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../shared/widgets/clickable_widget.dart';
import '../../domain/entities/tab_entity.dart';
import '../cubit/tabs_cubit.dart';
import 'tab_icons_and_names.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({
    required this.tab,
    required this.isSelected,
    super.key,
  });

  final TabEntity tab;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: double.infinity,
      color: isSelected
          ? context.colors.scaffoldBackgroundColor
          : context.colors.shadedBackgroundColor,
      child: ClickableWidget(
        onTap: () {},
        child: Row(
          children: [
            const SizedBox(width: 10),
            getTabIcon(context, tab),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                getTabName(context, tab),
                style: context.textStyle.button.copyWith(
                  color: isSelected
                      ? context.colors.onScaffoldBackgroundHeader
                      : context.colors.onScaffoldBackgroundColor,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            ClickableWidget(
              onTap: () {
                context.read<TabsCubit>().closeTab(tab);
              },
              child: SizedBox(
                width: 25,
                height: 25,
                child: Icon(
                  Icons.close,
                  color: context.colors.disabled,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }
}
