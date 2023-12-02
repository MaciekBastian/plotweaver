import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

@RoutePage(name: 'HomeRoute')
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: ListView(
        children: [],
      ),
    );
  }
}
