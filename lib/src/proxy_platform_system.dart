import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:network_proxy_interface/network_proxy_method_channel.dart';
import 'package:network_proxy_interface/network_proxy_platform_interface.dart';

import 'proxy_platform.dart';

class ProxyPlatformImpl implements ProxyPlatform {
  @override
  void init() {
    // This is to manually endorse Dart implementations until automatic
    // registration of Dart plugins is implemented. For details see
    // https://github.com/flutter/flutter/issues/52267.
    // Only do the initial registration if it hasn't already been overridden
    // with a non-default instance.
    if (!kIsWeb && NetworkProxyPlatform.instance is MethodChannelNetworkProxy) {
      if (Platform.isLinux) {
        // NetworkProxyPlatform.instance = NetworkProxyLinux();
      } else if (Platform.isMacOS) {
        // NetworkProxyPlatform.instance = NetworkProxyMacos();
      } else if (Platform.isWindows) {
        // NetworkProxyPlatform.instance = NetworkProxyWindows();
      }
    }
  }
}
