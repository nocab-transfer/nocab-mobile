import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class SettingsModel {
  late final String deviceName;
  late final int finderPort;
  late final int mainPort;
  late final bool darkMode;
  late final Color seedColor;
  late final Locale locale;
  late String downloadPath;
  late DateFormatType dateFormatType;

  SettingsModel({
    required this.deviceName,
    required this.finderPort,
    required this.mainPort,
    required this.darkMode,
    required this.locale,
    required this.seedColor,
    required this.downloadPath,
    required this.dateFormatType,
  });

  SettingsModel.fromJson(Map<String, dynamic> json) {
    deviceName = json['deviceName'];
    finderPort = json['finderPort'];
    mainPort = json['mainPort'];
    darkMode = json['darkMode'];
    locale = Locale(json['language']);
    seedColor = Color(json['seedColor']);
    downloadPath = json['downloadPath'];
    dateFormatType = DateFormatType.getFromName(json['dateFormatType'] ?? "normal24");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceName'] = deviceName;
    data['finderPort'] = finderPort;
    data['mainPort'] = mainPort;
    data['darkMode'] = darkMode;
    data['language'] = locale.languageCode;
    data['seedColor'] = seedColor.value;
    data['downloadPath'] = downloadPath;
    data['dateFormatType'] = dateFormatType.name;
    return data;
  }
}

extension SettingsExtenios on SettingsModel {
  SettingsModel copyWith({
    String? deviceName,
    int? finderPort,
    int? mainPort,
    bool? darkMode,
    bool? useMaterial3,
    Color? seedColor,
    bool? useSystemColor,
    String? language,
    String? downloadPath,
    DateFormatType? dateFormatType,
  }) {
    return SettingsModel(
      deviceName: deviceName ?? this.deviceName,
      finderPort: finderPort ?? this.finderPort,
      mainPort: mainPort ?? this.mainPort,
      darkMode: darkMode ?? this.darkMode,
      seedColor: seedColor ?? this.seedColor,
      locale: Locale(language ?? locale.languageCode),
      downloadPath: downloadPath ?? this.downloadPath,
      dateFormatType: dateFormatType ?? this.dateFormatType,
    );
  }
}

enum DateFormatType {
  base24("HH:mm dd/MM/yyyy"),
  base12("hh:mm a dd/MM/yyyy"),

  imAmerican("hh:mm a MM/dd/yyyy"),
  imAsian("HH:mm yyyy/MM/dd");

  const DateFormatType(this.stringFormat);
  final String stringFormat;

  DateFormat get dateFormat => DateFormat(stringFormat);

  static DateFormatType getFromName(String name) {
    return DateFormatType.values.firstWhere((element) => element.name == name, orElse: () => DateFormatType.values.first);
  }
}
