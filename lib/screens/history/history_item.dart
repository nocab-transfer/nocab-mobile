import 'package:flutter/material.dart';
import 'package:nocab/models/database/device_db.dart';
import 'package:nocab/models/database/transfer_db.dart';
import 'package:nocab/services/settings/settings.dart';

class HistoryItem extends StatelessWidget {
  final TransferDatabase transfer;
  final int index;
  final Function(TransferDatabase transfer)? onClicked;
  final bool isSelected;
  const HistoryItem({Key? key, required this.transfer, required this.index, required this.onClicked, this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => !isSelected ? onClicked?.call(transfer) : null,
        splashColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(isSelected ? 1 : .4),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Requested At",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w300),
                      ),
                      Text(
                        SettingsService().getSettings.dateFormatType.dateFormat.format(transfer.requestedAt), //transfer.requestedAt.toString(),
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 30,
                    width: 95,
                    decoration: BoxDecoration(
                      color: transfer.status.color.withOpacity(.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        transfer.status.name.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(color: transfer.status.color, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Row(
                    children: [
                      _buildDeviceInfo(transfer.senderDevice, context),
                      const Icon(Icons.arrow_forward_rounded),
                      const SizedBox(width: 8),
                      _buildDeviceInfo(transfer.receiverDevice, context)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceInfo(DeviceDb deviceInfo, BuildContext context) {
    return SizedBox(
      width: 85,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              deviceInfo.deviceName.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, color: deviceInfo.isCurrentDevice ? Theme.of(context).colorScheme.primary : null),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              deviceInfo.deviceOs,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              deviceInfo.deviceIp,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
