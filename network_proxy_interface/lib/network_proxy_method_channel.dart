import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'network_proxy_platform_interface.dart';

/// An implementation of [NetworkProxyPlatform] that uses method channels.
class MethodChannelNetworkProxy extends NetworkProxyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('network_proxy');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
