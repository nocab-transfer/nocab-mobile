import 'package:flutter/material.dart';
import 'package:nocab/screens/settings/setting_card.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var switchIcon = MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.onPrimary);
        }
        return Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onInverseSurface);
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back_ios_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("Settings"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Material(
                  color: Colors.transparent,
                  child: OutlinedButton.icon(
                    onPressed: () {}, // TODO: Add about
                    icon: const Icon(Icons.question_mark_rounded, size: 16),
                    label: const Text('About'),
                  ),
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SettingCard(
                    title: 'Device Name',
                    caption: 'The name of this device as shown the other devices',
                    widget: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    leading: Icons.device_unknown_rounded,
                  ),
                  SettingCard(
                    title: 'Theme Color',
                    caption: 'Change the color of the application',
                    leading: Icons.color_lens_rounded,
                    widget: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //borderRadius: const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      //child: Icon(Icons.ads_click_rounded, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  SettingCard(
                    title: 'Dark Mode',
                    caption: 'Change the theme of the application',
                    leading: Icons.brightness_4_rounded,
                    widget: Switch(value: true, thumbIcon: switchIcon, onChanged: (value) {}, activeColor: Theme.of(context).colorScheme.primary),
                  ),
                  const SettingCard(
                    title: 'Date & Time Format',
                    caption: 'Change the date and time format',
                    leading: Icons.date_range_rounded,
                    widget: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                  SettingCard(
                    title: 'Language',
                    caption: 'Change the language of the application',
                    leading: Icons.language,
                    onTap: () {},
                    widget: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                  const Divider(),
                  Text('Advanced Settings', style: Theme.of(context).textTheme.titleMedium),
                  const Text('These options are for advanced users only. Changing these options may cause the application to malfunction.',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  const SettingCard(
                    title: 'Finder Port',
                    caption:
                        'The port will be used to communicate with the device you want to connect to. Changing this value may cause the application to malfunction.',
                    leading: Icons.portable_wifi_off_rounded,
                    helpText: 'This will take effect after restarting the application.',
                    widget: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
