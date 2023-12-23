import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '../../core/constants/colors.dart';
import '../../core/get_it/get_it.dart';

@RoutePage(name: 'DefaultViewRoute')
class DefaultViewScreen extends StatefulWidget {
  const DefaultViewScreen({super.key});

  @override
  State<DefaultViewScreen> createState() => _DefaultViewScreenState();
}

class _DefaultViewScreenState extends State<DefaultViewScreen> {
  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return Container(
              color: getIt<AppColors>().background,
              child: Container(),
            );
          },
        ),
      ],
    );
  }
}
