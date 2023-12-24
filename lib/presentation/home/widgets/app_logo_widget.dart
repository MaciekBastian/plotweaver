import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({
    this.height = 80,
    this.width = 80,
    super.key,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.blue[200],
      child: Icon(
        Icons.edit,
        size: height / 2,
      ),
    );
  }
}
