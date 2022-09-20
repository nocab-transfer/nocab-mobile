import 'package:flutter/material.dart';
import 'package:nocab/custom_widgets/file_list/file_list.dart';
import 'package:nocab/models/file_model.dart';

class RequestConfirmationView extends StatelessWidget {
  final ShareRequest request;
  final Function()? onAccepted;
  final Function()? onRejected;
  const RequestConfirmationView({Key? key, required this.request, required this.onAccepted, required this.onRejected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                height: 70,
                child: Center(
                    child: Icon(
                  Icons.file_present_rounded,
                  size: 36,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "${request.deviceInfo.name ?? "Unknown"}\nwants to send you a file",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Ip: ${request.deviceInfo.ip} - Port: ${request.transferPort}",
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                ),
              ),
              FileList(
                files: request.files,
                height: request.files.length * 66 > 350 ? 350 : request.files.length * 66,
                width: MediaQuery.of(context).size.width - 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      onPressed: onRejected,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        fixedSize: const Size(120, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        side: BorderSide(width: 2, color: Theme.of(context).colorScheme.error),
                      ),
                      child: Text(
                        "Reject",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onAccepted,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 40),
                        //padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      ),
                      child: Text(
                        "Accept",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                      ),
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
}
