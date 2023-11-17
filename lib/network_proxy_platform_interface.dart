import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'network_proxy_method_channel.dart';

abstract class NetworkProxyPlatform extends PlatformInterface {
  /// Constructs a NetworkProxyPlatform.
  NetworkProxyPlatform() : super(token: _token);

  static final Object _token = Object();

  static NetworkProxyPlatform _instance = MethodChannelNetworkProxy();

  /// The default instance of [NetworkProxyPlatform] to use.
  ///
  /// Defaults to [MethodChannelNetworkProxy].
  static NetworkProxyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NetworkProxyPlatform] when
  /// they register themselves.
  static set instance(NetworkProxyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
