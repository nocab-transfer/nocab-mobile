import 'package:animations/animations.dart';
import 'package:nocab/custom_dialogs/sender_dialog_bloc/sender_dialog.dart';
import 'package:nocab/custom_widgets/svh_color_handler/svg_color_handler.dart';
import 'package:nocab/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Good Morning!",
                    style: Theme.of(context).textTheme.headline5!,
                  ),
                  Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Provider.of<ThemeProvider>(context, listen: false).toogleTheme(),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.settings_rounded, size: 24),
                      ),
                    ),
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
            //const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _receiveHandler(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    //padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    primary: Theme.of(context).colorScheme.surfaceVariant,
                    onPrimary: Theme.of(context).hoverColor,
                  ),
                  child: Text(
                    "Receive",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _sendHandler(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    //padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  ),
                  child: Text(
                    "Send",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendHandler(BuildContext context) {
    showModal(context: context, configuration: const FadeScaleTransitionConfiguration(barrierDismissible: false), builder: ((context) => const SenderDialog()));
  }

  void _receiveHandler(BuildContext context) {
    //showModal(context: context, configuration: const FadeScaleTransitionConfiguration(barrierDismissible: true), builder: ((context) => const ReceiverDialog()));
  }
}
