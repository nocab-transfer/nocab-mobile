import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog_cubit.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog_state.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog_state_views.dart';
import 'package:nocab/custom_widgets/sponsor_related/sponsor_snackbar.dart';
import 'package:nocab/extensions/size_extension.dart';
import 'package:nocab/models/database/transfer_db.dart';
import 'package:nocab/services/database/database.dart';
import 'package:nocab/services/settings/settings.dart';

class ReceiverDialog extends StatelessWidget {
  const ReceiverDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReceiverDialogCubit()..startReceiver(),
      child: BlocConsumer<ReceiverDialogCubit, ReceiverDialogState>(
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

  Widget buildWidget(BuildContext context, ReceiverDialogState state) {
    switch (state.runtimeType) {
      case ReceiverInit:
        return const ReceiverInitView();
      case ConnectionWait:
        return ConnectionWaitView(
          onPop: () => context.read<ReceiverDialogCubit>().stopReceiver().then((value) => Navigator.pop(context)),
          deviceInfo: (state as ConnectionWait).deviceInfo,
        );
      case RequestConfirmation:
        return RequestConfirmationView(
          request: (state as RequestConfirmation).shareRequest,
          onAccepted: () => context.read<ReceiverDialogCubit>().acceptRequest(state.shareRequest),
          onRejected: () => context.read<ReceiverDialogCubit>().rejectRequest(state.shareRequest).then((value) => Navigator.pop(context)),
        );
      case Connecting:
        return ConnectingView(serverDeviceInfo: (state as Connecting).serverDeviceInfo);
      case Transferring:
        return TransferringView(
          serverDeviceInfo: (state as Transferring).serverDeviceInfo,
          currentFile: state.currentFile,
          files: state.files,
          filesTransferred: state.filesTransferred,
          progress: state.progress,
          speed: state.speed,
          onCancel: () => context.read<ReceiverDialogCubit>().cancel(),
        );
      case TransferSuccess:
        return TransferSuccessView(serverDeviceInfo: (state as TransferSuccess).serverDeviceInfo, files: state.files);
      case TransferFailed:
        return TransferFailedView(
          message: (state as TransferFailed).message,
        );
      case TransferCancelled:
        return const TransferCancelledView();
      default:
        Navigator.pop(context);
        break;
    }
    return Container();
  }
}
