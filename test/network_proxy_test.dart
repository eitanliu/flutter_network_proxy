import 'package:flutter_test/flutter_test.dart';
import 'package:network_proxy/network_proxy.dart';
import 'package:network_proxy_interface/network_proxy_method_channel.dart';
import 'package:network_proxy_interface/network_proxy_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNetworkProxyPlatform
    with MockPlatformInterfaceMixin
    implements NetworkProxyPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> getProxyEnable({NetworkProxyType? type}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> setProxyEnable(bool enable, {NetworkProxyType? type}) {
    throw UnimplementedError();
  }

  @override
  Future<List<NetworkProxyConf>> getProxy({NetworkProxyType? type}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> setProxy(NetworkProxyConf conf) {
    throw UnimplementedError();
  }
}

void main() {
  final NetworkProxyPlatform initialPlatform = NetworkProxyPlatform.instance;

  test('$MethodChannelNetworkProxy is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNetworkProxy>());
  });

  test('getPlatformVersion', () async {
    NetworkProxy networkProxyPlugin = NetworkProxy();
    MockNetworkProxyPlatform fakePlatform = MockNetworkProxyPlatform();
    NetworkProxyPlatform.instance = fakePlatform;

    expect(await networkProxyPlugin.getPlatformVersion(), '42');
  });
}
