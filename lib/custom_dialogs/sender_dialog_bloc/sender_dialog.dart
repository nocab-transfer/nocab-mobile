import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nocab/models/file_model.dart';

import 'sender_dialog_cubit.dart';
import 'sender_dialog_state.dart';
import 'sender_dialog_state_views.dart';

class SenderDialog extends StatelessWidget {
  final List<FileInfo>? files;
  const SenderDialog({super.key, this.files});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider(
        create: (context) => SenderDialogCubit()..start(files),
        child: buildWidget(),
      ),
    );
  }

  Widget buildWidget() => BlocConsumer<SenderDialogCubit, SenderDialogState>(
        listener: (context, state) {},
        builder: (context, state) {
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
              );
            case TransferSuccess:
              return TransferSuccessView(serverDeviceInfo: (state as TransferSuccess).serverDeviceInfo, files: state.files);
            case TransferFailed:
              return TransferFailedView(message: (state as TransferFailed).message);
            default:
              Navigator.pop(context);
              return const SenderInitView();
          }
        },
      );
}
