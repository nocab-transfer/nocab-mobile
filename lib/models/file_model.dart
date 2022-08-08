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
  late String? senderName;
  late String senderOpSystem;
  late int port;
  late List<FileInfo> files;
  late String? uniqueId;

  ShareRequest({required this.senderName, required this.senderOpSystem, required this.files, required this.port, required this.uniqueId});

  ShareRequest.fromJson(Map<String, dynamic> json) {
    senderName = json['senderName'];
    senderOpSystem = json['senderOpSystem'];
    port = json['port'];
    files = List<FileInfo>.from(json['files'].map((x) => FileInfo.fromJson(x)));
    uniqueId = json['uniqueId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['senderName'] = senderName;
    map['senderOpSystem'] = senderOpSystem;
    map['port'] = port;
    map['files'] = List<dynamic>.from(files.map((x) => x.toJson()));
    map['uniqueId'] = uniqueId;
    return map;
  }
}
