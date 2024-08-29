import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants/images_constants.dart';

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
      child: SvgPicture.asset(
        ImagesConstants.plotweaverLogo,
        width: radius * 2 - 30,
        height: radius * 2 - 30,
      ),
    );
  }
}
