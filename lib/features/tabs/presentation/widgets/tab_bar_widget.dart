import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../cubit/tabs_cubit.dart';
import 'tab_widget.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      color: context.colors.shadedBackgroundColor,
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, state) {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: state.openedTabs.map((tab) {
              return TabWidget(
                tab: tab,
                isSelected: state.openedTabId == tab.tabId,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
