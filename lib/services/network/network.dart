import 'dart:io';

class Network {
  static Future<NetworkInterface> getCurrentNetworkInterface(List<NetworkInterface> networkInterfaces) async {
    List<String> defaultInterfaceNames = [
      'Wi-Fi',
      'Ethernet',
      'Local Area Connection',
      'Bridge',
      'en',
      'hotspot',
      'w1',
      'eth',
      'wlan0',
    ];

    return networkInterfaces.firstWhere(
      (element) => defaultInterfaceNames.contains(element.name),
      orElse: () => networkInterfaces.first, // return first if not any matched :(
    );
  }

  static Future<int> getUnusedPort() {
    return ServerSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      var port = socket.port;
      socket.close();
      return port;
    });
  }
}
