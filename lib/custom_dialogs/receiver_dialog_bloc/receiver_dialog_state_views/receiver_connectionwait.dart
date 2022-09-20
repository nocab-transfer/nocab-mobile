import 'package:flutter/material.dart';
import 'package:nocab/custom_widgets/svh_color_handler/svg_color_handler.dart';
import 'package:nocab/models/deviceinfo_model.dart';

class ConnectionWaitView extends StatelessWidget {
  final DeviceInfo deviceInfo;
  final Function()? onPop;
  const ConnectionWaitView({Key? key, required this.deviceInfo, required this.onPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(8),
      child: Container(
        height: 350,
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(20)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: onPop,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close_rounded, size: 24),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SvgColorHandler(
                      svgPath: "assets/images/airplane.svg",
                      colorSwitch: {
                        const Color(0xFF6C63FF): Theme.of(context).colorScheme.primary,
                        const Color(0xFF3f3d56): Theme.of(context).colorScheme.primaryContainer,
                        const Color(0xFFe6e6e6): Theme.of(context).colorScheme.primaryContainer,
                      },
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Device shown as: ", style: Theme.of(context).textTheme.titleLarge),
                          Text(deviceInfo.name ?? "Unknown", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                        ],
                      ),
                    ),
                    Text("Find ${deviceInfo.name} on sender device", style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                Text("Waiting for connection...", style: Theme.of(context).textTheme.labelLarge),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {}, // TODO: implement QR Scanner Screen
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    ),
                    child: Text(
                      "Scan Qr",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
