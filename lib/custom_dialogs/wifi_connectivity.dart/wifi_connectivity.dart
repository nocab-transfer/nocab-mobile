import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/effects.dart';
import 'package:flutter_animate/extensions/extensions.dart';

class WifiConnectivityDialog extends StatefulWidget {
  const WifiConnectivityDialog({super.key});

  @override
  State<WifiConnectivityDialog> createState() => _WifiConnectivityDialogState();
}

class _WifiConnectivityDialogState extends State<WifiConnectivityDialog> {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        child: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_rounded, size: 70, color: Colors.blue)
                  .animate(onPlay: (controller) => controller.repeat())
                  .shakeX(duration: const Duration(seconds: 1))
                  .shake(duration: const Duration(seconds: 1))
                  .then(delay: 1.seconds),
              const SizedBox(height: 8),
              Text('Waiting for Wifi Connection', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
