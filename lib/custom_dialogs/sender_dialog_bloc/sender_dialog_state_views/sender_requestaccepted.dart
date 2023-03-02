import 'package:flutter/material.dart';
import 'package:nocab_core/nocab_core.dart';

class RequestAcceptedView extends StatelessWidget {
  final DeviceInfo serverDeviceInfo;
  const RequestAcceptedView({Key? key, required this.serverDeviceInfo}) : super(key: key);

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
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            height: 208,
            width: 150,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(Icons.check, color: Colors.green, size: 50),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Request accepted\nWaiting for write", style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
