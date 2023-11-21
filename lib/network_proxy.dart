import 'package:network_proxy_interface/network_proxy_platform_interface.dart';

import 'src/proxy_platform.dart';

export 'package:network_proxy_interface/network_proxy_platform_interface.dart';

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

  Future<bool> getProxyEnable({NetworkProxyType? type}) {
    return NetworkProxyPlatform.instance.getProxyEnable(type: type);
  }

  Future<bool> setProxyEnable(bool enable, {NetworkProxyType? type}) {
    return NetworkProxyPlatform.instance.setProxyEnable(enable, type: type);
  }

  Future<List<NetworkProxyConf>> getProxy({NetworkProxyType? type}) {
    return NetworkProxyPlatform.instance.getProxy(type: type);
  }

  Future<bool> setProxy(NetworkProxyConf conf) {
    return NetworkProxyPlatform.instance.setProxy(conf);
  }
}
