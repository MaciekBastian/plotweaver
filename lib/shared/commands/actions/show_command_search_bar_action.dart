import 'package:flutter/material.dart';

import '../../overlays/search_command_overlay.dart';
import '../general_intents.dart';

class ShowCommandSearchBarAction
    extends ContextAction<ShowCommandSearchBarIntent> {
  ShowCommandSearchBarAction();

  @override
  Object? invoke(ShowCommandSearchBarIntent intent, [BuildContext? context]) {
    if (context != null) {
      showCommandOverlay(context);
    }
    return null;
  }
}
