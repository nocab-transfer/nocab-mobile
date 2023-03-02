import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_widgets/device_finder_bloc/device_finder_cubit.dart';
import 'package:nocab/custom_widgets/device_finder_bloc/device_finder_state.dart';
import 'package:nocab_core/nocab_core.dart';
import 'package:vibration/vibration.dart';

class DeviceFinder extends StatefulWidget {
  final Function(DeviceInfo deviceInfo)? onPressed;
  final Function(List<DeviceInfo> deviceInfos)? onDeviceFound;
  const DeviceFinder({Key? key, this.onPressed, this.onDeviceFound}) : super(key: key);

  @override
  State<DeviceFinder> createState() => _DeviceFinderState();
}

class _DeviceFinderState extends State<DeviceFinder> {
  bool isVibrated = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceFinderCubit()..startScanning(),
      child: buildWidget(),
    );
  }

  Widget buildWidget() => BlocConsumer<DeviceFinderCubit, DeviceFinderState>(
        listener: (context, state) {
          if (state is Found && !isVibrated) {
            Vibration.hasVibrator().then((value) async {
              if (value == false) return;
              var control = await Vibration.hasCustomVibrationsSupport();
              if (control == true) {
                return Vibration.vibrate(pattern: [0, 150, 75, 150], intensities: [0, 255, 0, 255]);
              }

              return Vibration.vibrate(duration: 500);
            });
            isVibrated = true;
            widget.onDeviceFound?.call(state.devices);
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case NoDevice: return _buildNoDevice();
            case Found: return _buildDeviceList((state as Found).devices);
            default: return _buildNoDevice();
          }
        },
      );

  Widget _buildNoDevice() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
          ),
          Text('Searching for devices...'),
        ],
      ),
    );
  }

  Widget _buildDeviceList(List<DeviceInfo> devices) {
    return ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onPressed?.call(devices[index]),
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: const Icon(Icons.desktop_windows_rounded),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                title: Text(devices[index].name),
                subtitle: Text(devices[index].ip),
              ),
            ),
          );
        });
  }
}
