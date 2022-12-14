import 'package:device_info_plus/device_info_plus.dart';

extension DeviceInfoPluginExtension on BaseDeviceInfo {
  String get deviceName {
    switch (runtimeType) {
      case AndroidDeviceInfo:
        return (this as AndroidDeviceInfo).model ?? "Android";
      case IosDeviceInfo:
        return (this as IosDeviceInfo).name ?? "iPhone";
      default:
        return "Unknown";
    }
  }
}
