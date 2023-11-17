import 'package:network_proxy_interface/network_proxy_platform_interface.dart';

import 'src/proxy_platform.dart';

class NetworkProxy {
  static bool _manualDartRegistrationNeeded = true;

  static init() {
    if (_manualDartRegistrationNeeded) {
      ProxyPlatform().init();
      _manualDartRegistrationNeeded = false;
    }
  }

  NetworkProxy() {
    init();
  }

  Future<String?> getPlatformVersion() {
    return NetworkProxyPlatform.instance.getPlatformVersion();
  }
}
