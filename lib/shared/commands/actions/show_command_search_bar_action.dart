import 'package:flutter/material.dart';

import '../general_intents.dart';

class ShowCommandSearchBarAction extends Action<ShowCommandSearchBarIntent> {
  ShowCommandSearchBarAction();

  @override
  Object? invoke(ShowCommandSearchBarIntent intent) {
    print('show');

    return null;
  }
}
