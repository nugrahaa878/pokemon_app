enum DeviceOS {
  iOS,
  android,
}

class AppInfo {
  final String name;
  final String version;
  final String buildNumber;

  AppInfo({
    required this.name,
    required this.version,
    required this.buildNumber,
  });

  @override
  String toString() =>
      'AppInfo(name: $name, version: $version, buildNumber: $buildNumber)';
}

class DeviceInfo {
  final String model;
  final DeviceOS operatingSystem;
  final String osVersion;
  final String manufacturer;
  final String? id;

  DeviceInfo({
    required this.model,
    required this.operatingSystem,
    required this.osVersion,
    required this.manufacturer,
    required this.id,
  });

  @override
  String toString() {
    return 'DeviceInfo(model: $model, operatingSystem: $operatingSystem, osVersion: $osVersion, manufacturer: $manufacturer, id: $id)';
  }
}
