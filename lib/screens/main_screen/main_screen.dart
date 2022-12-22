import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:nocab/custom_dialogs/receiver_dialog_bloc/receiver_dialog.dart';
import 'package:nocab/custom_dialogs/sender_dialog_bloc/sender_dialog.dart';
import 'package:nocab/custom_widgets/svh_color_handler/svg_color_handler.dart';
import 'package:flutter/material.dart';
import 'package:nocab/screens/settings/settings.dart';
import 'package:nocab/services/github/github.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NoCab Mobile', style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.settings_rounded),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildUpdate(context),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgColorHandler(
                      svgPath: "assets/images/human.svg",
                      colorSwitch: {
                        const Color(0xFF7d5fff): Theme.of(context).colorScheme.primary,
                        const Color(0xFF2f2e41): Theme.of(context).colorScheme.secondaryContainer,
                        const Color(0xFFe6e6e6): Theme.of(context).colorScheme.onPrimaryContainer,
                        const Color(0xFF3F3D56): Theme.of(context).colorScheme.onPrimaryContainer,
                      },
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SvgColorHandler(
                        svgPath: "assets/images/paperplane.svg",
                        colorSwitch: {const Color(0xFF7d5fff): Theme.of(context).colorScheme.primary},
                        height: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
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

  Widget _buildUpdate(BuildContext context) {
    return FutureBuilder(
        future: Github().checkForUpdates(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.error),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(Icons.download_rounded, color: Theme.of(context).colorScheme.onError),
                            ).animate(onComplete: (controller) => controller.repeat()).shakeX(amount: 2).then(delay: 3000.ms),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Update Available',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text.rich(
                                TextSpan(text: snapshot.data!["current"], children: [
                                  const TextSpan(text: ' > '),
                                  TextSpan(text: snapshot.data!["tag_name"]),
                                ]),
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
                              ),
                            ],
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () => launchUrlString(snapshot.data!["html_url"], mode: LaunchMode.externalNonBrowserApplication),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.onError,
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ),
              ).animate().slideX(begin: -.05, curve: Curves.easeOut).fadeIn());
        });
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
