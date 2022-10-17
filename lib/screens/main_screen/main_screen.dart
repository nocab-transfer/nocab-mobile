import 'package:animations/animations.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog.dart';
import 'package:nocab/custom_dialogs/sender_dialog_bloc/sender_dialog.dart';
import 'package:nocab/custom_widgets/svh_color_handler/svg_color_handler.dart';
import 'package:nocab/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:nocab/services/github/github.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Good Morning!",
                    style: Theme.of(context).textTheme.headlineSmall!,
                  ),
                  Row(
                    children: [
                      FutureBuilder(
                        future: Github().checkForUpdates(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => launchUrlString(snapshot.data!["html_url"], mode: LaunchMode.externalNonBrowserApplication),
                                child: Container(
                                  height: 40,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Theme.of(context).colorScheme.error),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.error,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (snapshot.data!["tag_name"].length > 9 ? "Update" : snapshot.data!["tag_name"]) + "\navailable",
                                              style: Theme.of(context).textTheme.bodySmall,
                                              textAlign: TextAlign.center,
                                            ),
                                            Icon(Icons.download_rounded, size: 24, color: Theme.of(context).colorScheme.error),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      Material(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Provider.of<ThemeProvider>(context, listen: false).toogleTheme(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.settings_rounded),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 500,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(32),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgColorHandler(
                      svgPath: "assets/images/human.svg",
                      colorSwitch: {const Color(0xFF7d5fff): Theme.of(context).colorScheme.primary},
                      height: 300,
                    ),
                  ),
                  SvgColorHandler(
                    svgPath: "assets/images/paperplane.svg",
                    colorSwitch: {const Color(0xFF7d5fff): Theme.of(context).colorScheme.primary},
                    height: 50,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _receiveHandler(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).hoverColor,
                      fixedSize: const Size(150, 50),
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    ),
                    child: Text(
                      "Receive",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _sendHandler(context),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(150, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    ),
                    child: Text(
                      "Send",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendHandler(BuildContext context) {
    showModal(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(barrierDismissible: false),
        builder: ((context) => const SenderDialog()));
  }

  void _receiveHandler(BuildContext context) {
    Permission.storage.request().then((value) {
      if (value.isGranted) {
        showModal(
            context: context,
            configuration: const FadeScaleTransitionConfiguration(barrierDismissible: false),
            builder: ((context) => const ReceiverDialog()));
      }
    });
  }
}
