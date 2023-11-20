import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'network_proxy_method_channel.dart';

enum NetworkProxyType { http, https, socks, auto }

class NetworkProxyConf {
  final NetworkProxyType type;
  final bool enable;
  final String host;
  final int port;
  final String? user;
  final String? password;

  NetworkProxyConf(
    this.type,
    this.enable,
    this.host,
    this.port, {
    this.user,
    this.password,
  });
}

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

  Future<bool> getProxyEnable({NetworkProxyType? type}) {
    throw UnimplementedError('getProxyEnable() has not been implemented.');
  }

  Future<bool> setProxyEnable(bool enable, {NetworkProxyType? type}) {
    throw UnimplementedError('setProxyEnable() has not been implemented.');
  }

  Future<List<NetworkProxyConf>> getProxy({NetworkProxyType? type}) {
    throw UnimplementedError('getProxy() has not been implemented.');
  }

  Future<bool> setProxy(NetworkProxyConf conf) {
    throw UnimplementedError('setProxy() has not been implemented.');
  }
}
