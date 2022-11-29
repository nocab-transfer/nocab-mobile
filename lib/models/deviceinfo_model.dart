class DeviceInfo {
  String? name;
  String? ip;
  int? port;
  String? opsystem;
  String? deviceId;

  DeviceInfo({required this.name, required this.ip, required this.port, required this.opsystem, required this.deviceId});

  DeviceInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ip = json['ip'];
    port = json['port'];
    opsystem = json['opsystem'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['ip'] = ip;
    data['port'] = port;
    data['opsystem'] = opsystem;
    data['deviceId'] = deviceId;
    return data;
  }
}
