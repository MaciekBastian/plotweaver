import 'package:flutter/material.dart';

class PlotweaverLogoWidget extends StatelessWidget {
  const PlotweaverLogoWidget({
    this.radius = 16,
    super.key,
  });

  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      // TODO: change to plotweaver logo when design is ready
      child: const Placeholder(),
    );
  }
}
