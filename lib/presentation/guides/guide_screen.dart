import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/router/router.gr.dart';
import '../../domain/guides/guide.dart';
import '../../generated/locale_keys.g.dart';
import 'character_development_guide.dart';

@RoutePage(name: 'GuideRoute')
class GuideScreen extends StatefulWidget {
  const GuideScreen({
    required this.initialGuide,
    super.key,
  });

  final PlotweaverGuide initialGuide;

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  late PlotweaverGuide _guide;

  @override
  void initState() {
    super.initState();
    _guide = widget.initialGuide;
  }

  final _screens = {
    PlotweaverGuide.characterDevelopment: const CharacterDevelopmentGuide(),
    PlotweaverGuide.plotDevelopment: Container(),
  };

  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      sidebar: Sidebar(
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: _screens.keys.toList().indexOf(_guide),
            onChanged: (value) {
              setState(() {
                _guide = _screens.keys.toList()[value];
              });
            },
            items: [
              SidebarItem(
                label: Text(LocaleKeys.guides_character_development.tr()),
              ),
              SidebarItem(
                label: Text(LocaleKeys.guides_plot_development.tr()),
              ),
            ],
          );
        },
        minWidth: 250,
        maxWidth: 250,
        startWidth: 250,
        top: Row(
          children: [
            MacosBackButton(
              onPressed: () {
                AutoRouter.of(context).replace(const DefaultViewRoute());
              },
            ),
          ],
        ),
      ),
      child: MacosScaffold(
        children: [
          ContentArea(
            builder: (context, scrollController) {
              return _screens[_guide]!;
            },
          ),
        ],
      ),
    );
  }
}
