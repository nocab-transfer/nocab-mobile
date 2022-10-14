import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog_cubit.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog_state.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog_state_views.dart';

class ReceiverDialog extends StatelessWidget {
  const ReceiverDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReceiverDialogCubit()..startReceiver(),
      child: BlocConsumer<ReceiverDialogCubit, ReceiverDialogState>(
        listener: (context, state) {},
        builder: (context, state) => WillPopScope(
            onWillPop: () async => state.canPop,
            child: buildWidget(context, state)),
      ),
    );
  }

  Widget buildWidget(BuildContext context, ReceiverDialogState state) {
    switch (state.runtimeType) {
      case ReceiverInit:
        return const ReceiverInitView();
      case ConnectionWait:
        return ConnectionWaitView(
          onPop: () => context
              .read<ReceiverDialogCubit>()
              .stopReceiver()
              .then((value) => Navigator.pop(context)),
          deviceInfo: (state as ConnectionWait).deviceInfo,
        );
      case RequestConfirmation:
        return RequestConfirmationView(
          request: (state as RequestConfirmation).shareRequest,
          onAccepted: () => context
              .read<ReceiverDialogCubit>()
              .acceptRequest(state.shareRequest, state.socket),
          onRejected: () => context
              .read<ReceiverDialogCubit>()
              .rejectRequest(state.shareRequest, state.socket)
              .then((value) => Navigator.pop(context)),
        );
      case Connecting:
        return ConnectingView(
            serverDeviceInfo: (state as Connecting).serverDeviceInfo);
      case Transferring:
        return TransferringView(
          serverDeviceInfo: (state as Transferring).serverDeviceInfo,
          currentFile: state.currentFile,
          files: state.files,
          filesTransferred: state.filesTransferred,
          progress: state.progress,
          speed: state.speed,
        );
      case TransferSuccess:
        return TransferSuccessView(
            serverDeviceInfo: (state as TransferSuccess).serverDeviceInfo,
            files: state.files);
      case TransferFailed:
        return TransferFailedView(
          message: (state as TransferFailed).message,
        );
      default:
        Navigator.pop(context);
        break;
    }
    return Container();
  }
}
