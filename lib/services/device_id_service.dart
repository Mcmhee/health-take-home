import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceHelper {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown_ios';
    } else {
      WebBrowserInfo webBrowserInfo = await _deviceInfo.webBrowserInfo;
      return webBrowserInfo.userAgent ?? 'unknown_web';
    }
  }
}
