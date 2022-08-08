import 'package:nocab/models/deviceinfo_model.dart';

abstract class DeviceFinderState {
  const DeviceFinderState();
}

class NoDevice extends DeviceFinderState {
  const NoDevice();
}

class Found extends DeviceFinderState {
  final List<DeviceInfo> devices;
  const Found(this.devices);
}
