import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_widgets/sponsor_related/sponsor_snackbar.dart';
import 'package:nocab/extensions/size_extension.dart';
import 'package:nocab/models/database/transfer_db.dart';
import 'package:nocab/services/database/database.dart';
import 'package:nocab/services/settings/settings.dart';
import 'package:nocab_core/nocab_core.dart';

import 'sender_dialog_cubit.dart';
import 'sender_dialog_state.dart';
import 'sender_dialog_state_views.dart';

class SenderDialog extends StatelessWidget {
  final List<FileInfo>? files;
  const SenderDialog({super.key, this.files});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SenderDialogCubit()..start(files),
      child: BlocConsumer<SenderDialogCubit, SenderDialogState>(
        listener: (context, state) async {
          if (state is TransferSuccess && !SettingsService().getSettings.hideSponsorSnackbar) {
            await Future.delayed(const Duration(seconds: 1)); // wait for database to update
            int successfullTransfers = await Database().getCountFiltered(status: TransferDbStatus.success);
            int latestTransferSize = state.files.fold(0, (totalSize, element) => totalSize! + element.byteSize) ?? 0;
            if (successfullTransfers == 0) return;
            if (successfullTransfers == 2 || successfullTransfers % 10 == 0 || latestTransferSize > 1.gbToBytes) {
              if (context.mounted) SponsorSnackbar.show(context, latestTransferSize: latestTransferSize, transferCount: successfullTransfers);
            }
          }
        },
        builder: (context, state) => WillPopScope(
          onWillPop: () async => state.canPop,
          child: buildWidget(context, state),
        ),
      ),
    );
  }

  Widget buildWidget(BuildContext context, SenderDialogState state) {
    switch (state.runtimeType) {
      case SenderInit:
        return const SenderInitView();
      case FileSelectCancel:
        return const FileSelectCancelView();
      case FileCacheLoading:
        return const FileCacheLoadingView();
      case FileConfirmation:
        return FileConfirmationView(
          files: (state as FileConfirmation).files,
          onAccepted: (deviceInfo, files) => context.read<SenderDialogCubit>().send(files: files, serverDeviceInfo: deviceInfo),
        );
      case Connecting:
        return ConnectingView(serverDeviceInfo: (state as Connecting).serverDeviceInfo);
      case RequestSent:
        return RequestSentView(serverDeviceInfo: (state as RequestSent).serverDeviceInfo);
      case RequestAccepted:
        return RequestAcceptedView(serverDeviceInfo: (state as RequestAccepted).serverDeviceInfo);
      case RequestRejected:
        return RequestRejectedView(message: (state as RequestRejected).message);
      case Transferring:
        return TransferringView(
          serverDeviceInfo: (state as Transferring).serverDeviceInfo,
          files: state.files,
          filesTransferred: state.filesTransferred,
          currentFile: state.currentFile,
          speed: state.speed,
          progress: state.progress,
          onCancel: () => context.read<SenderDialogCubit>().cancel(),
        );
      case TransferSuccess:
        return TransferSuccessView(serverDeviceInfo: (state as TransferSuccess).serverDeviceInfo, files: state.files);
      case TransferFailed:
        return TransferFailedView(message: (state as TransferFailed).message);
      case TransferCancelled:
        return const TransferCancelledView();
      default:
        Navigator.pop(context);
        return const SenderInitView();
    }
  }
}
