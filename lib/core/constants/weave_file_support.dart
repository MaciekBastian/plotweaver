// ignore_for_file: constant_identifier_names

import '../errors/plotweaver_errors.dart';

final class WeaveFileSupport {
  static const LATEST_VERSION = '1.0.0';
  static const LOWEST_SUPPORTED_VERSION = '1.0.0';

  List<int> _parseVersionNumber(String version) {
    final output = version.split('.').map(int.tryParse).toList();
    if (output.any((el) => el == null)) {
      throw const IOError.parseError();
    }
    return output.whereType<int>().toList();
  }

  int _compareVersions(List<int> v1, List<int> v2) {
    for (int i = 0; i < v1.length; i++) {
      if (v1[i] < v2[i]) {
        return -1;
      }
      if (v1[i] > v2[i]) {
        return 1;
      }
    }
    return 0;
  }

  bool isSupported(String version, bool allowFromOutdatedClients) {
    final current = _parseVersionNumber(version);
    final latest = _parseVersionNumber(LATEST_VERSION);
    final lowestSupported = _parseVersionNumber(LOWEST_SUPPORTED_VERSION);

    // check if current is grater or equal to lowest supported
    final bool isAtLeastLowestSupportedVersion =
        _compareVersions(current, lowestSupported) >= 0;

    // check if current is less or equal to latest.
    final bool isAtMostLatestVersion = _compareVersions(current, latest) <= 0;

    if (!allowFromOutdatedClients) {
      return isAtLeastLowestSupportedVersion && isAtMostLatestVersion;
    } else {
      // check if lowestSupported <= currentVersion >= latestVersion
      return isAtLeastLowestSupportedVersion;
    }
  }

  bool isClientOutdated(String version) {
    final current = _parseVersionNumber(version);
    final latest = _parseVersionNumber(LATEST_VERSION);

    final bool isAtMostLatestVersion = _compareVersions(current, latest) <= 0;

    return !isAtMostLatestVersion;
  }
}
