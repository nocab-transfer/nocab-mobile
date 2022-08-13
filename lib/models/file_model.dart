import 'package:nocab/models/deviceinfo_model.dart';

class FileInfo {
  String? name;
  int? byteSize;
  bool? isEncrypted;
  String? hash;
  String? path; //local

  FileInfo({required this.name, required this.byteSize, required this.isEncrypted, required this.hash, this.path});

  FileInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    byteSize = json['byteSize'];
    isEncrypted = json['isEncrypted'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['byteSize'] = byteSize;
    data['isEncrypted'] = isEncrypted;
    data['hash'] = hash;
    return data;
  }

  static FileInfo empty() {
    return FileInfo(name: "File", byteSize: 1, isEncrypted: false, hash: "unused", path: null);
  }
}

class ShareResponse {
  bool? response;
  String? info;

  ShareResponse({required this.response, this.info});

  ShareResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    info = json['info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['response'] = response;
    map['info'] = info;
    return map;
  }
}

class ShareRequest {
  late List<FileInfo> files;
  late DeviceInfo deviceInfo;
  late int transferPort;
  late String? uniqueId;

  ShareRequest({required this.files, required this.deviceInfo, required this.transferPort, required this.uniqueId});

  ShareRequest.fromJson(Map<String, dynamic> json) {
    files = List<FileInfo>.from(json['files'].map((x) => FileInfo.fromJson(x)));
    deviceInfo = DeviceInfo.fromJson(json['deviceInfo']);
    transferPort = json['transferPort'];
    uniqueId = json['uniqueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['files'] = List<dynamic>.from(files.map((x) => x.toJson()));
    map['deviceInfo'] = deviceInfo.toJson();
    map['transferPort'] = transferPort;
    map['uniqueId'] = uniqueId;
    return map;
  }
}
