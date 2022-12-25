import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nocab/extensions/size_extension.dart';
import 'package:nocab/models/database/device_db.dart';
import 'package:nocab/models/database/file_db.dart';
import 'package:nocab/models/database/transfer_db.dart';
import 'package:nocab/services/settings/settings.dart';
import 'package:open_filex/open_filex.dart';

class HistoryDetails extends StatefulWidget {
  final TransferDatabase transfer;
  const HistoryDetails({super.key, required this.transfer});

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .51,
      maxChildSize: .9,
      minChildSize: .4,
      snapSizes: const [.51, .9],
      snap: true,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 2,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: widget.transfer.status.color.withOpacity(.6),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                widget.transfer.status.name.toUpperCase(),
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Text("Managed by ${widget.transfer.managedBy.name.toUpperCase()}",
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.grey, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDeviceInfo(widget.transfer.senderDevice, context),
                        const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.arrow_forward_rounded)),
                        _buildDeviceInfo(widget.transfer.receiverDevice, context)
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTransferInfoCard(
                            "Requested At", SettingsService().getSettings.dateFormatType.dateFormat.format(widget.transfer.requestedAt)),
                        if (widget.transfer.startedAt != null) ...[
                          _buildTransferInfoCard(
                              "Started At", SettingsService().getSettings.dateFormatType.dateFormat.format(widget.transfer.startedAt!))
                        ],
                        if (widget.transfer.endedAt != null) ...[
                          _buildTransferInfoCard("Ended At", SettingsService().getSettings.dateFormatType.dateFormat.format(widget.transfer.endedAt!))
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTransferInfoCard("File Count", widget.transfer.files.length.toString()),
                        _buildTransferInfoCard("Total File Size",
                            widget.transfer.files.fold(0, (previousValue, element) => previousValue + element.byteSize).formatBytes()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTransferInfoCard("Message", widget.transfer.message ?? "-", limitWidth: double.infinity),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.transfer.files.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: _buildFileInfo(widget.transfer.files[index], widget.transfer.status),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildDeviceInfo(DeviceDb deviceInfo, BuildContext context) {
    return Tooltip(
      message: "${deviceInfo.deviceName.toUpperCase()}\n${deviceInfo.deviceOs}\n${deviceInfo.deviceIp}",
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
        width: MediaQuery.of(context).size.width * .4,
        decoration: BoxDecoration(
          border: deviceInfo.isCurrentDevice ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
          color: !deviceInfo.isCurrentDevice ? Theme.of(context).colorScheme.primary.withOpacity(.1) : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              if (deviceInfo.isCurrentDevice) ...[
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(50)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Text(
                        "You",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              ],
              Padding(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferInfoCard(String title, String message, {double? limitWidth = 110}) {
    return SizedBox(
      width: limitWidth,
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          Text(message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildFileInfo(FileDb file, TransferDbStatus status) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        file.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Text(file.byteSize.formatBytes(), style: const TextStyle(fontSize: 14)),
                  ],
                ),
                FutureBuilder(
                  future: File(file.path ?? "").exists(),
                  builder: (context, snapshot) {
                    if (snapshot.data == false) {
                      return const Tooltip(
                        message: "File moved or deleted. Maybe not even existed in the universe",
                        textAlign: TextAlign.center,
                        margin: EdgeInsets.all(16),
                        child: Padding(padding: EdgeInsets.only(right: 8.0), child: Icon(Icons.error_rounded, color: Colors.red)),
                      );
                    }
                    return TextButton(onPressed: () => OpenFilex.open(file.path), child: const Text("Open File"));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
