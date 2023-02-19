import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:nocab/custom_dialogs/wifi_connectivity.dart/wifi_connectivity.dart';
import 'package:nocab/main.dart';

class Network {
  static final Network _instance = Network._internal();
  factory Network() => _instance;
  Network._internal();

  bool _dialogShown = false;

  void initialize(Function(String ip) onInterfaceChanged) {
    Connectivity().onConnectivityChanged.listen((event) async {
      if (event == ConnectivityResult.wifi) {
        String? ip = await NetworkInfo().getWifiIP();
        if (ip == null) return;

        onInterfaceChanged.call(ip);
      } else {
        String? ip = await NetworkInfo().getWifiIP();
        if (ip == null) _showConnectivityDialog();
      }
    });
  }

  Future<String?> getLocalIp() async {
    var ip = await NetworkInfo().getWifiIP();
    if (ip == null) _showConnectivityDialog();
    return ip;
  }

  static Future<int> getUnusedPort() {
    return ServerSocket.bind(InternetAddress.anyIPv4, 0).then((socket) {
      var port = socket.port;
      socket.close();
      return port;
    });
  }

  Future<void> _showConnectivityDialog() async {
    if (_dialogShown) return;

    while (navigatorKey.currentState?.context == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    _dialogShown = true;
    // ignore: use_build_context_synchronously
    showModal(
      context: navigatorKey.currentState!.context,
      configuration: const FadeScaleTransitionConfiguration(barrierDismissible: false),
      builder: ((context) => const WifiConnectivityDialog()),
    ).then((value) => _dialogShown = false);
  }
}
