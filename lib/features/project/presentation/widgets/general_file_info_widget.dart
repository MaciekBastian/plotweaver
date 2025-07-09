import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../generated/l10n.dart';
import '../../../weave_file/domain/entities/general_entity.dart';

class GeneralFileInfoWidget extends StatelessWidget {
  const GeneralFileInfoWidget({
    required this.general,
    super.key,
  });

  final GeneralEntity general;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildElement(
            key: S.of(context).created_at,
            value:
                '${DateFormat.yMMMMd().format(general.createdAt)} ${DateFormat.Hms().format(general.createdAt)}, ${general.createdAt.timeZoneName}',
            context: context,
          ),
          if (general.lastModifiedAt != null)
            _buildElement(
              key: S.of(context).last_modified_at,
              value:
                  '${DateFormat.yMMMMd().format(general.lastModifiedAt!)} ${DateFormat.Hms().format(general.lastModifiedAt!)}, ${general.lastModifiedAt!.timeZoneName}',
              context: context,
            ),
          if (general.plotweaverVersion != null)
            _buildElement(
              key: S.of(context).plotweaver_version,
              value: general.plotweaverVersion!,
              context: context,
            ),
          _buildElement(
            key: S.of(context).weave_file_version,
            value: general.weaveVersion,
            context: context,
          ),
          _buildElement(
            key: S.of(context).origin,
            value: general.origin,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildElement({
    required BuildContext context,
    required String key,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$key: ',
              style: context.textStyle.propertyTitle,
            ),
            TextSpan(
              text: value,
              style: context.textStyle.caption,
            ),
          ],
        ),
        textAlign: TextAlign.left,
        textScaler: MediaQuery.textScalerOf(context),
      ),
    );
  }
}
