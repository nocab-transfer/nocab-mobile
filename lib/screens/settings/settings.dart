import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nocab/custom_dialogs/alert_box/alert_box.dart';
import 'package:nocab/custom_dialogs/settings_dialogs/settings_dialogs.dart';
import 'package:nocab/extensions/lang_code_to_name.dart';
import 'package:nocab/models/settings_model.dart';
import 'package:nocab/provider/theme_provider.dart';
import 'package:nocab/screens/logs/logs.dart';
import 'package:nocab/screens/settings/setting_card.dart';
import 'package:nocab/services/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:nocab_core/nocab_core.dart';

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
          titleSpacing: 8,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.arrow_back_ios_rounded),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onDoubleTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Logs())),
                child: const Text("Settings"),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            OutlinedButton.icon(
              onPressed: () {}, // TODO: Add about
              icon: const Icon(Icons.question_mark_rounded, size: 16),
              label: const Text('About'),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SettingCard(
                    title: 'Device Name',
                    caption: 'The name of this device as shown the other devices',
                    onTap: () => showModal(
                      context: context,
                      builder: (context) => SettingsDialogs.textField(
                        title: "Device Name",
                        subtitle: "The bame of this device as shown the other devices",
                        controller: TextEditingController(),
                        hintText: SettingsService().getSettings.deviceName,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          // block emoji
                          FilteringTextInputFormatter.deny(
                            RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                          )
                        ],
                        obscureText: false,
                        onSaved: (text) {
                          if (text.trim().isNotEmpty) {
                            SettingsService().setSettings(SettingsService().getSettings.copyWith(deviceName: text));
                            DeviceManager().updateDeviceInfo(name: text);
                            return;
                          }
                          SettingsService().setSettings(SettingsService().getSettings.copyWith(deviceName: Platform.operatingSystem));
                          DeviceManager().updateDeviceInfo(name: Platform.operatingSystem);
                        },
                      ),
                    ),
                    widget: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                    leading: Icons.device_unknown_rounded,
                  ),
                  SettingCard(
                    title: 'Theme Color',
                    caption: 'Change the color of the application',
                    leading: Icons.color_lens_rounded,
                    onTap: () => showModal(
                      context: context,
                      builder: (context) => SettingsDialogs.colorPicker(
                        title: "Theme Color",
                        subtitle: "Change the color of the application",
                        onColorClicked: (color) {
                          SettingsService().setSettings(SettingsService().getSettings.copyWith(seedColor: color));
                          Provider.of<ThemeProvider>(context, listen: false).changeSeedColor(color);
                        },
                        colors: Colors.accents
                            .map((e) => ThemeData(
                                  colorSchemeSeed: e,
                                  useMaterial3: true,
                                  brightness: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
                                ).colorScheme.primary)
                            .toList(),
                      ),
                    ),
                    widget: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary),
                      child: Icon(Icons.ads_click_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                    ),
                  ),
                  SettingCard(
                    title: 'Dark Mode',
                    caption: 'Change the theme of the application',
                    leading: Icons.brightness_4_rounded,
                    onTap: () => Provider.of<ThemeProvider>(context, listen: false).changeThemeMode(
                        Provider.of<ThemeProvider>(context, listen: false).themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark),
                    widget: Switch(
                      value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
                      thumbIcon: switchIcon,
                      onChanged: (value) {
                        SettingsService().setSettings(SettingsService().getSettings.copyWith(darkMode: value));
                        Provider.of<ThemeProvider>(context, listen: false).changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SettingCard(
                    title: 'Date & Time Format',
                    caption: 'Change the date and time format',
                    leading: Icons.date_range_rounded,
                    onTap: () => showModal(
                      context: context,
                      builder: (context) => SettingsDialogs.selection(
                        title: "Date & Time Format",
                        subtitle: "Change the date and time format",
                        items: DateFormatType.values
                            .map((e) => SettingsDialogSelectionItem<DateFormatType>(
                                  title: e.dateFormat.format(DateTime(2022, 11, 18, 20, 28)),
                                  subtitle: e.stringFormat,
                                  selected: SettingsService().getSettings.dateFormatType == e,
                                  value: e,
                                ))
                            .toList(),
                        onItemClicked: (value) => SettingsService().setSettings(
                          SettingsService().getSettings.copyWith(dateFormatType: value),
                        ),
                      ),
                    ),
                    widget: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                  SettingCard(
                    title: 'Language',
                    caption: 'Change the language of the application',
                    leading: Icons.language,
                    onTap: () => showModal(
                      context: context,
                      builder: (context) => SettingsDialogs.selection(
                        title: "Language",
                        subtitle: "Change the language of the application",
                        items: [const Locale('en')] // TODO
                            .map((e) => SettingsDialogSelectionItem<Locale>(
                                  title: e.langName,
                                  selected: SettingsService().getSettings.locale == e,
                                  value: e,
                                ))
                            .toList(),
                        onItemClicked: (value) {
                          //TODO: change locale
                          SettingsService().setSettings(SettingsService().getSettings.copyWith(language: value.languageCode));
                        },
                      ),
                    ),
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
                  SettingCard(
                    title: 'Finder Port',
                    caption:
                        'The port will be used to communicate with the device you want to connect to. Changing this value may cause the application to malfunction.',
                    leading: Icons.portable_wifi_off_rounded,
                    helpText: 'This will take effect after restarting the application.',
                    onTap: () => showModal(
                      context: context,
                      builder: (context) => SettingsDialogs.textField(
                        title: "Finder Port",
                        subtitle:
                            "The port will be used to communicate with the device you want to connect to. Changing this value may cause the application to malfunction.",
                        controller: TextEditingController(),
                        hintText: SettingsService().getSettings.finderPort.toString(),
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onSaved: (text) => SettingsService().setSettings(
                          SettingsService().getSettings.copyWith(finderPort: int.tryParse(text)),
                        ),
                      ),
                    ),
                    widget: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                  SettingCard(
                    title: 'Force Regenerate Settings',
                    caption: 'This will regenerate the settings file. This will take effect after restarting the application.',
                    leading: Icons.loop_rounded,
                    dangerous: true,
                    onTap: () => showModal(
                        context: context,
                        builder: (context) => AlertBox(
                              title: "Regenerate Settings",
                              message: "This will delete all your settings and regenerate them. Are you sure you want to continue?",
                              actions: [
                                TextButton.icon(
                                  onPressed: () => SettingsService().recreateSettings().then((value) {
                                    Navigator.pop(context);
                                  }),
                                  icon: const Icon(Icons.loop_rounded),
                                  label: const Text('Confirm'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    //textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                                    //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    //textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                                    //side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ],
                            )),
                    widget: const Padding(
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
