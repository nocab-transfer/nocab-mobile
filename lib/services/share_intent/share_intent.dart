import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareIntent {
  static final ShareIntent _singleton = ShareIntent._internal();

  factory ShareIntent() {
    return _singleton;
  }

  ShareIntent._internal();

  Future<void> initialize({Function(List<String> paths)? onData}) async {
    ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) onData?.call(value.map((e) => e.path).toList());
    });

    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) onData?.call(value.map((e) => e.path).toList());
    });
  }
}
