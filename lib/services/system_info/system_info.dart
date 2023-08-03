import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import './models/models.dart';

final class SystemInfoService {
  final AppInfo appInfo;
  final DeviceInfo deviceInfo;

  SystemInfoService._({
    required this.appInfo,
    required this.deviceInfo,
  });

  static Future<SystemInfoService> init() async {
    final packageInfoPlugin = await PackageInfo.fromPlatform();
    final deviceInfoPlugin = DeviceInfoPlugin();

    final appInfo = AppInfo(
      name: packageInfoPlugin.appName,
      version: packageInfoPlugin.version,
      buildNumber: packageInfoPlugin.buildNumber,
    );

    final DeviceInfo deviceInfo;

    if (Platform.isIOS) {
      final infoIOS = await deviceInfoPlugin.iosInfo;

      deviceInfo = DeviceInfo(
        id: infoIOS.identifierForVendor,
        manufacturer: 'Apple',
        model: infoIOS.model,
        operatingSystem: DeviceOS.iOS,
        osVersion: infoIOS.systemVersion,
      );
    } else if (Platform.isAndroid) {
      final infoAndroid = await deviceInfoPlugin.androidInfo;

      deviceInfo = DeviceInfo(
        id: infoAndroid.id,
        manufacturer: infoAndroid.manufacturer,
        model: infoAndroid.model,
        operatingSystem: DeviceOS.android,
        osVersion: infoAndroid.version.release,
      );
    } else {
      throw Exception('Unsupported system!');
    }

    return SystemInfoService._(
      appInfo: appInfo,
      deviceInfo: deviceInfo,
    );
  }

  String getUserAgent() {
    if (deviceInfo.operatingSystem == DeviceOS.iOS) {
      return "${appInfo.name}/${appInfo.version};${appInfo.buildNumber}/iOS ${deviceInfo.osVersion};${deviceInfo.model}";
    }

    if (deviceInfo.operatingSystem == DeviceOS.android) {
      return "${appInfo.name}/${appInfo.version};${appInfo.buildNumber}/Android ${deviceInfo.osVersion}; ${deviceInfo.manufacturer} ${deviceInfo.model}";
    }

    return "${appInfo.name}/${appInfo.version};${appInfo.buildNumber}/Unknown";
  }
}
