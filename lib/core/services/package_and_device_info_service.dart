import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class PackageAndDeviceInfoService {
  Future<void> initialize();

  String? get packageVersion;

  String? get deviceName;
}

@Singleton(as: PackageAndDeviceInfoService)
class PackageAndDeviceInfoServiceImpl implements PackageAndDeviceInfoService {
  String? _version;
  String? _deviceName;

  @override
  Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final buildNumber = packageInfo.buildNumber;
    final version = packageInfo.version;

    _version = '$version+$buildNumber';

    if (Platform.isMacOS) {
      final macosInfo = await DeviceInfoPlugin().macOsInfo;

      _deviceName = macosInfo.computerName;
    } else if (Platform.isWindows) {
      final windowsInfo = await DeviceInfoPlugin().windowsInfo;

      _deviceName = windowsInfo.userName;
    }
  }

  @override
  String? get packageVersion => _version;

  @override
  String? get deviceName => _deviceName;
}
