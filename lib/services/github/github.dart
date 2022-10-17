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

      var latestRelease = includePrerelease
          ? jsonData.first
          : jsonData.firstWhere(
              (element) => element["prerelease"] == false,
              orElse: () => jsonData.first,
            );
      String latestVersion = latestRelease["tag_name"];
      if (latestVersion != "v$version" || kDebugMode) {
        return latestRelease;
      }
    }
    return null;
  }
}
