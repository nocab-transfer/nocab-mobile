import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:nocab/extensions/variables_from_base_deviceinfo.dart';
import 'package:nocab/models/settings_model.dart';
import 'package:nocab/services/network/network.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SettingsService {
  static final SettingsService _singleton = SettingsService._internal();
  bool? isMsixInstalled;

  List<String> errors = [];

  late File _settingsFile;
  File get getSettingsFile => _settingsFile;

  factory SettingsService() {
    return _singleton;
  }

  SettingsService._internal();

  final _changeController = StreamController<SettingsModel>.broadcast();
  Stream<SettingsModel> get onSettingChanged => _changeController.stream;

  SettingsModel? _settings;
  SettingsModel get getSettings {
    if (_settings == null) throw Exception("Settings not initialized");
    return _settings!;
  }

  // returns true if settings creatings for the first time
  Future<bool> initialize() async {
    try {
      _settingsFile = File(p.join((await getApplicationSupportDirectory()).path, 'settings.json'));

      if (await _settingsFile.exists()) {
        var settings = SettingsModel.fromJson(json.decode(await _settingsFile.readAsString()));
        if (!(await Directory(settings.downloadPath).exists())) {
          throw p.PathException("Download path does not exist\n${settings.downloadPath}");
        }
        _settings = settings;
        return false;
      }

      await _settingsFile.create(recursive: true);
      _settings = await _createNewSettings();
      await _settingsFile.writeAsString(json.encode(_settings?.toJson()));
      return true;
    } catch (e) {
      _settings = await _createNewSettings();
      errors.add("$e\n\nUsing default options");
      return false;
    }
  }

  Future<SettingsModel> _createNewSettings() async {
    var rawLocale = Platform.localeName.split('.')[0];
    return SettingsModel(
      deviceName: (await DeviceInfoPlugin().deviceInfo).deviceName,
      darkMode: SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark,
      mainPort: await Network.getUnusedPort(),
      finderPort: 62193,
      locale: rawLocale.contains('_') ? Locale(rawLocale.split('_')[0]) : Locale(rawLocale),
      seedColor: Colors.deepPurpleAccent,
      downloadPath: Platform.isAndroid
          ? "/storage/emulated/0/Download"
          : Platform.isIOS
              ? (await getApplicationDocumentsDirectory()).path
              : (await getDownloadsDirectory())!.path,
      dateFormatType: DateFormatType.base24,
    );
  }

  Future<void> recreateSettings() async {
    try {
      errors.clear();
      if (await _settingsFile.exists()) await _settingsFile.delete();
      await initialize();
      _changeController.add(_settings!);
    } catch (e) {
      errors.add(e.toString());
      _changeController.add(_settings!);
    }
  }

  Future<bool> setSettings(SettingsModel settings) async {
    try {
      _settings = settings;
      _changeController.add(settings);
      await _settingsFile.writeAsString(json.encode(_settings?.toJson()));
      return true;
    } catch (e) {
      errors.add(e.toString());
      _changeController.add(_settings!);
      return false;
    }
  }
}
