import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

class Github {
  final bool includePrerelease = true;

  Future<Map?> checkForUpdates() async {
    String releasesUrl = "https://api.github.com/repos/nocab-transfer/nocab-mobile/releases";

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    var data = await http.get(Uri.parse(releasesUrl));
    if (data.statusCode == 200) {
      List jsonData = jsonDecode(data.body);

      Map latestRelease = includePrerelease
          ? jsonData.first
          : jsonData.firstWhere(
              (element) => element["prerelease"] == false,
              orElse: () => jsonData.first,
            );
      String latestVersion = latestRelease["tag_name"];
      if (_isVersionGreaterThan(latestVersion.replaceAll('v', ''), version) || kDebugMode) {
        return latestRelease..addAll(<String, String>{"current": version});
      }
    }
    return null;
  }

  bool _isVersionGreaterThan(String newVersion, String currentVersion) {
    List<String> currentV = currentVersion.split(".");
    List<String> newV = newVersion.split(".");
    bool a = false;
    for (var i = 0; i <= 2; i++) {
      a = int.parse(newV[i]) > int.parse(currentV[i]);
      if (int.parse(newV[i]) != int.parse(currentV[i])) break;
    }
    return a;
  }
}
