import 'package:flutter/material.dart';
import 'package:nocab/models/deviceinfo_model.dart';

class ConnectingView extends StatelessWidget {
  final DeviceInfo serverDeviceInfo;
  const ConnectingView({Key? key, required this.serverDeviceInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 208,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 16),
                Text(
                  "Trying to connect to ${serverDeviceInfo.name}...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
                  textAlign: TextAlign.center,
                ),
                Text(
                  serverDeviceInfo.opsystem ?? "",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
